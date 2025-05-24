# File: utils/opentdb_api.py (PERBAIKAN FINAL untuk NameError)

import requests
import random
from typing import List, Dict, Optional
import html
import urllib.parse

OPENTDB_BASE_URL = "https://opentdb.com/api.php"
OPENTDB_CATEGORIES = {
    9: "General Knowledge", 10: "Entertainment: Books", 11: "Entertainment: Film",
    12: "Entertainment: Music", 13: "Entertainment: Musicals & Theatres",
    14: "Entertainment: Television", 15: "Entertainment: Video Games", 16: "Entertainment: Board Games",
    17: "Science & Nature", 18: "Science: Computers", 19: "Science: Mathematics",
    20: "Mythology", 21: "Sports", 22: "Geography", 23: "History", 24: "Politics",
    25: "Art", 26: "Celebrities", 27: "Animals", 28: "Vehicles",
    29: "Entertainment: Comics", 30: "Science: Gadgets", 31: "Entertainment: Japanese Anime & Manga",
    32: "Entertainment: Cartoon & Animations",
}

def decode_html_entities(text: str) -> str:
    """Mendekode URL-encoded string dan HTML entities."""
    if not text:
        return ""
    try:
        decoded_url_text = urllib.parse.unquote(text)
        decoded_html_text = html.unescape(decoded_url_text)
        return decoded_html_text
    except Exception as e:
        print(f"Warning: Error decoding text '{text[:50]}...': {e}")
        return text

def fetch_questions(amount: int = 10, category_id: Optional[int] = None, difficulty: Optional[str] = None) -> List[Dict]:
    """Mengambil pertanyaan dari Open Trivia Database API."""
    params = {"amount": amount, "type": "multiple", "encode": "url3986"}
    if category_id and category_id in OPENTDB_CATEGORIES:
        params["category"] = category_id
    if difficulty and difficulty in ["easy", "medium", "hard"]:
        params["difficulty"] = difficulty

    print(f"--- OpenTDB API Call ---")
    print(f"Requesting URL: {OPENTDB_BASE_URL}")
    print(f"With Params: {params}")

    try:
        response = requests.get(OPENTDB_BASE_URL, params=params, timeout=25)
        response.raise_for_status()
        data = response.json()
        print(f"Raw JSON Response from OpenTDB: {data}")

        if data.get("response_code") != 0:
            print(f"API Error from OpenTDB: Code {data.get('response_code')}. Params: {params}")
            return []

        processed_questions = []
        batch_prefix = f"q_otdb_{random.randint(1000,9999)}"

        for idx, item in enumerate(data.get("results", [])):
            print(f"\n--- Processing Question {idx+1} ---")
            print(f"Raw Item: {item}")

            if not all(k in item for k in ('question', 'correct_answer', 'incorrect_answers')) or \
               not isinstance(item.get("incorrect_answers"), list):
                 print(f"WARNING: Skipping incomplete or malformed question data: {item}")
                 continue
            
            question_text = decode_html_entities(str(item.get("question", "")))
            
            # --- PASTIKAN DEFINISI INI ADA DAN BENAR SEBELUM DIPAKAI ---
            correct_answer_text = decode_html_entities(str(item.get("correct_answer", "")))
            # ----------------------------------------------------------

            incorrect_answers_list_raw = item.get("incorrect_answers", [])
            decoded_incorrect_answers = [decode_html_entities(str(ans)) for ans in incorrect_answers_list_raw]
            
            category_name_raw = item.get("category", "Unknown Category")
            decoded_category_name = decode_html_entities(str(category_name_raw))
            decoded_difficulty = decode_html_entities(str(item.get("difficulty", "unknown")))

            print(f"  Decoded Question: {question_text}")
            print(f"  Decoded Correct Answer: {correct_answer_text}") # Menggunakan variabel yang sudah pasti ada
            print(f"  Decoded Incorrect Answers: {decoded_incorrect_answers}")

            if not correct_answer_text:
                print(f"WARNING: Skipping question due to empty correct_answer: {item}")
                continue

            options = []
            options.extend(decoded_incorrect_answers)
            options.append(correct_answer_text) # <<< GUNAKAN correct_answer_text
            
            options = [opt for opt in options if opt and str(opt).strip()] 

            print(f"  Options before shuffle (len: {len(options)}): {options}")
            
            if len(set(options)) < 2:
                print(f"WARNING: Not enough unique options ({len(set(options))}) for question '{question_text}'. Skipping.")
                continue
            
            random.shuffle(options)
            print(f"  Options after shuffle: {options}")

            processed_question = {
                "id": f"{batch_prefix}_{idx}",
                "category_name": decoded_category_name,
                "difficulty": decoded_difficulty,
                "question": question_text,
                "options": options,
                "correct_answer": correct_answer_text, # Jawaban benar yang sudah didecode
            }
            processed_questions.append(processed_question)

        print(f"--- End OpenTDB API Call ---")
        print(f"Successfully fetched and processed {len(processed_questions)} questions.")
        return processed_questions

    except requests.exceptions.Timeout:
        print(f"Error: Timeout fetching questions from OpenTDB. Params: {params}")
        return []
    except requests.exceptions.RequestException as e:
        print(f"Error fetching questions from OpenTDB: {e}. Params: {params}")
        return []
    except Exception as e:
        import traceback
        print(f"An unexpected error occurred in fetch_questions: {e}")
        print(traceback.format_exc())
        return []