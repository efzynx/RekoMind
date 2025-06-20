# File: services/quiz_service.py

from typing import List, Dict, Tuple, Optional
import uuid
import random

from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select, desc

try:
    from models.user_models import User
    from models.history_models import QuizAttempt, UserAnswerDetail
    from models.quiz_models import QuizResult, AnswerIn, QuestionOut, WeaknessAnalysis, IncorrectQuestionDetail
except ImportError as e:
    User = type("User", (), {}) # type: ignore
    QuizAttempt = type("QuizAttempt", (), {}) # type: ignore
    QuizResult = type("QuizResult", (), {}) # type: ignore
    AnswerIn = type("AnswerIn", (), {}) # type: ignore
    QuestionOut = type("QuestionOut", (), {}) # type: ignore
    WeaknessAnalysis = type("WeaknessAnalysis", (), {}) # type: ignore
    IncorrectQuestionDetail = type("IncorrectQuestionDetail", (), {}) # type: ignore
    print(f"Gagal impor di quiz_service: {e}")
    

from utils.opentdb_api import fetch_questions, OPENTDB_CATEGORIES
from utils.helpers import decode_html_entities

temp_correct_answers_storage: Dict[str, Dict[str, str]] = {}
temp_quiz_questions_storage: Dict[str, Dict[str, Dict]] = {}

def clear_quiz_session(quiz_session_id: str):
    popped_answers = temp_correct_answers_storage.pop(quiz_session_id, None)
    popped_details = temp_quiz_questions_storage.pop(quiz_session_id, None)
    if popped_answers or popped_details: print(f"Cleared temp data for session {quiz_session_id}")

async def get_new_quiz(
    quiz_session_id: str, amount: int = 10, category_ids: Optional[List[int]] = None, difficulty: Optional[str] = None
) -> List[QuestionOut]:
    print(f"Service: get_new_quiz. Session: {quiz_session_id}, Categories: {category_ids}, Difficulty: {difficulty}")
    fetched_questions_raw: List[Dict] = [] 
    if not category_ids:
        print(f"Fetching {amount} questions from all categories. Difficulty: {difficulty}"); fetched_questions_raw = fetch_questions(amount=amount, difficulty=difficulty)
    elif len(category_ids) == 1:
        target_category_id = category_ids[0]; print(f"Fetching {amount}q from category {target_category_id}. Difficulty: {difficulty}"); fetched_questions_raw = fetch_questions(amount=amount, category_id=target_category_id, difficulty=difficulty)
    else:
        fetch_multiplier = 5; amount_to_fetch = max(amount * fetch_multiplier, 50); print(f"Fetching {amount_to_fetch}q for filtering. Categories: {category_ids}. Difficulty: {difficulty}"); all_fetched_raw = fetch_questions(amount=amount_to_fetch, difficulty=difficulty)
        if all_fetched_raw: selected_category_names = {OPENTDB_CATEGORIES.get(cid) for cid in category_ids if cid in OPENTDB_CATEGORIES}; selected_category_names.discard(None); print(f"Filtering based on selected category names: {selected_category_names}"); filtered_questions_raw = [q for q in all_fetched_raw if q.get('category_name') in selected_category_names]; fetched_questions_raw = filtered_questions_raw[:amount]; print(f"Filtered to {len(fetched_questions_raw)}q for categories: {selected_category_names}")
        else: print("Failed to fetch questions for filtering."); fetched_questions_raw = []
    if not fetched_questions_raw: print(f"No questions fetched or filtered for session {quiz_session_id}"); return []
    quiz_questions_for_user: List[QuestionOut] = []; correct_answers_map: Dict[str, str] = {}; questions_details_map: Dict[str, Dict] = {}; used_ids_in_session = set()
    for i, q_from_fetch in enumerate(fetched_questions_raw):
        base_id_from_fetch = q_from_fetch.get('id', f"q_fallback_{i}"); unique_id = f"{base_id_from_fetch}_{quiz_session_id[:8]}"; collision_count = 0
        while unique_id in used_ids_in_session: collision_count += 1; unique_id = f"{base_id_from_fetch}_{quiz_session_id[:8]}_{collision_count}"
        used_ids_in_session.add(unique_id)
        question_text = q_from_fetch.get('question', ''); category_name_text = q_from_fetch.get('category_name', 'Unknown'); difficulty_text = q_from_fetch.get('difficulty', 'unknown'); options_list = q_from_fetch.get('options', []); correct_answer_text = q_from_fetch.get('correct_answer', '')
        questions_details_map[unique_id] = {'id': unique_id, 'question': question_text, 'category_name': category_name_text, 'difficulty': difficulty_text, 'options': options_list, 'correct_answer': correct_answer_text } # Simpan detail yang sudah bersih
        correct_answers_map[unique_id] = correct_answer_text
        quiz_questions_for_user.append(QuestionOut(id=unique_id, category_name=category_name_text, difficulty=difficulty_text, question=question_text, options=options_list))
    print("\n--- FINAL check (get_new_quiz): quiz_questions_for_user data BEFORE sending to frontend ---")
    for idx, final_q_out in enumerate(quiz_questions_for_user): print(f"  Soal ke-{idx} (ID: {final_q_out.id}): Options Len={len(final_q_out.options)}, Options Content={final_q_out.options}")
    temp_correct_answers_storage[quiz_session_id] = correct_answers_map; temp_quiz_questions_storage[quiz_session_id] = questions_details_map; print(f"Stored {len(correct_answers_map)} correct answers for session {quiz_session_id}"); return quiz_questions_for_user

async def submit_quiz_answers(
    quiz_session_id: str, user_answers: List[AnswerIn], db: AsyncSession, user: User
) -> Optional[QuizResult]:
    # ... (kode awal untuk ambil data dari cache, hitung skor, dan analisis kategori sama seperti #162)
    correct_answers_map = temp_correct_answers_storage.get(quiz_session_id)
    questions_details_map = temp_quiz_questions_storage.get(quiz_session_id)
    if not correct_answers_map or not questions_details_map: print(f"Error: Quiz session {quiz_session_id} data not found."); return None
    total_questions = len(correct_answers_map)
    if total_questions == 0: return QuizResult(total_questions=0, correct_answers_count=0, score_percentage=0.0, analysis=[], incorrect_questions=[])
    
    correct_count = 0; results_by_category: Dict[str, Dict] = {}; session_categories = set()
    incorrect_questions_details: List[IncorrectQuestionDetail] = []
    
    # --- PERSIAPAN UNTUK MENYIMPAN DETAIL JAWABAN ---
    list_of_answer_details_to_save: List[UserAnswerDetail] = []
    # -----------------------------------------------

    for q_id, q_detail in questions_details_map.items():
        category_name = q_detail.get('category_name', 'Unknown'); session_categories.add(category_name)
        if category_name not in results_by_category: results_by_category[category_name] = {"correct": 0, "total": 0}
        results_by_category[category_name]["total"] += 1
        
        user_ans_obj = next((ans for ans in user_answers if ans.question_id == q_id), None)
        correct_ans_text = correct_answers_map.get(q_id)
        is_correct = False
        user_answer_text = "Tidak dijawab"

        if user_ans_obj:
            user_answer_text = user_ans_obj.user_answer
            is_correct = (correct_ans_text is not None and user_answer_text == correct_ans_text)
        
        if is_correct:
            correct_count += 1
            results_by_category[category_name]["correct"] += 1
        else:
            incorrect_questions_details.append(IncorrectQuestionDetail(
                question_id=q_id, question_text=q_detail.get('question', ''),
                user_answer=user_answer_text, correct_answer=correct_ans_text or "N/A",
                category_name=category_name, difficulty=q_detail.get('difficulty', 'unknown')
            ))

        # --- BUAT OBJEK UNTUK DISIMPAN KE DATABASE ---
        answer_detail_to_save = UserAnswerDetail(
            user_id=user.id, # Foreign Key ke user
            # quiz_attempt_id akan diisi nanti setelah QuizAttempt dibuat
            question_text=q_detail.get('question', ''),
            options_presented=q_detail.get('options', []),
            user_answer=user_answer_text,
            correct_answer=correct_ans_text or "N/A",
            is_correct=is_correct,
            category_name=category_name,
            difficulty=q_detail.get('difficulty', 'unknown')
        )
        list_of_answer_details_to_save.append(answer_detail_to_save)
        # ---------------------------------------------
        
    overall_score = round((correct_count / total_questions) * 100, 2) if total_questions > 0 else 0.0
    analysis_list: List[WeaknessAnalysis] = []
    for cat_name, counts in results_by_category.items():
        cat_total = counts["total"]; cat_correct = counts["correct"]
        cat_score = round((cat_correct / cat_total) * 100, 2) if cat_total > 0 else 0.0
        analysis_list.append(WeaknessAnalysis(category_name=cat_name, score_percentage=cat_score, correct_count=cat_correct, total_questions=cat_total))
    
    quiz_result_obj = QuizResult(total_questions=total_questions, correct_answers_count=correct_count, score_percentage=overall_score, analysis=analysis_list, incorrect_questions=incorrect_questions_details)
    
    try:
        # 1. Buat QuizAttempt (ringkasan sesi)
        categories_played_str = ", ".join(sorted(list(session_categories))) if session_categories else None
        new_attempt = QuizAttempt(
            user_id=user.id, score=overall_score, total_questions=total_questions,
            correct_answers=correct_count, categories_played=categories_played_str
        )
        # 2. Hubungkan detail jawaban ke QuizAttempt
        new_attempt.answer_details = list_of_answer_details_to_save
        
        # 3. Simpan ke DB
        db.add(new_attempt)
        await db.commit()
        await db.refresh(new_attempt)
        print(f"Quiz attempt {new_attempt.id} dan {len(new_attempt.answer_details)} detail jawaban berhasil disimpan untuk user {user.id}")
    except Exception as e:
        await db.rollback()
        print(f"ERROR saat menyimpan quiz attempt dan detail jawaban: {e}")
    
    clear_quiz_session(quiz_session_id)
    return quiz_result_obj

async def calculate_guest_quiz_result(quiz_session_id: str, guest_answers: List[AnswerIn]) -> Optional[QuizResult]:
    correct_answers_map = temp_correct_answers_storage.get(quiz_session_id)
    questions_details_map = temp_quiz_questions_storage.get(quiz_session_id)
    if not correct_answers_map or not questions_details_map: print(f"Error: GUEST Session {quiz_session_id} data not found."); clear_quiz_session(quiz_session_id); return None
    total_q = len(correct_answers_map)
    if total_q == 0: print(f"Warning: No questions for GUEST session {quiz_session_id}."); clear_quiz_session(quiz_session_id); return QuizResult(total_questions=0,correct_answers_count=0,score_percentage=0.0,analysis=[], incorrect_questions=[])
    correct_count = 0; results_by_cat: Dict[str, Dict] = {}; incorrect_q_details: List[IncorrectQuestionDetail] = []
    for q_id, q_detail in questions_details_map.items():
        cat_name = q_detail.get('category_name', 'Unknown')
        if cat_name not in results_by_cat: results_by_cat[cat_name] = {"correct": 0, "total": 0}
        results_by_cat[cat_name]["total"] += 1
        user_ans_obj = next((ans for ans in guest_answers if ans.question_id == q_id), None)
        correct_ans_text = correct_answers_map.get(q_id)
        question_text = q_detail.get('question','')
        difficulty_text = q_detail.get('difficulty','unknown')
        if user_ans_obj:
            is_correct = (correct_ans_text is not None and user_ans_obj.user_answer == correct_ans_text)
            if is_correct: correct_count +=1; results_by_cat[cat_name]["correct"] +=1
            else: incorrect_q_details.append(IncorrectQuestionDetail(question_id=q_id,question_text=question_text,user_answer=user_ans_obj.user_answer,correct_answer=correct_ans_text or "N/A",category_name=cat_name,difficulty=difficulty_text))
        else: incorrect_q_details.append(IncorrectQuestionDetail(question_id=q_id,question_text=question_text,user_answer="Tidak dijawab",correct_answer=correct_ans_text or "N/A",category_name=cat_name,difficulty=difficulty_text))
    overall_score = round((correct_count / total_q) * 100, 2) if total_q > 0 else 0.0
    analysis_list: List[WeaknessAnalysis] = []
    for cat_name, counts in results_by_cat.items():
        cat_total = counts["total"]; cat_correct = counts["correct"]; cat_score = round((cat_correct / cat_total) * 100, 2) if cat_total > 0 else 0.0
        analysis_list.append(WeaknessAnalysis(category_name=cat_name,score_percentage=cat_score,correct_count=cat_correct,total_questions=cat_total))
    quiz_result_obj = QuizResult(total_questions=total_q,correct_answers_count=correct_count,score_percentage=overall_score,analysis=analysis_list,incorrect_questions=incorrect_q_details)
    clear_quiz_session(quiz_session_id); print(f"Guest result for {quiz_session_id} calculated."); return quiz_result_obj

async def get_user_quiz_history(user_id: uuid.UUID | int, db: AsyncSession) -> List[QuizAttempt]:
    try: stmt = select(QuizAttempt).where(QuizAttempt.user_id == user_id).order_by(desc(QuizAttempt.timestamp)); result = await db.execute(stmt); attempts = result.scalars().all(); return list(attempts)
    except Exception as e: print(f"Error fetching history for user {user_id}: {e}"); return []