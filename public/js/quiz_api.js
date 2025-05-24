import { API_BASE_URL } from './config.js';
import { state, updateState } from './state.js';
import * as ui from './ui_handlers.js';
import * as recommendation from './recommendation_api.js';
import { elements } from './dom_elements.js';

export async function fetchAndDisplayCategories() {
    if (!elements.categorySelectorDiv || !elements.categoryLoadingP) { 
        console.error("Category UI elements not ready for fetchAndDisplayCategories!"); 
        return; 
    }
    
    elements.categoryLoadingP.classList.remove('hidden'); 
    elements.categorySelectorDiv.innerHTML = '';
    
    try {
        const response = await fetch(`${API_BASE_URL}/quiz/categories`);
        if (!response.ok) throw new Error(`Gagal memuat kategori (HTTP ${response.status})`);
        
        const categories = await response.json();
        elements.categoryLoadingP.classList.add('hidden');
        
        if (categories && categories.length > 0) {
            categories.sort((a, b) => a.name.localeCompare(b.name));
            categories.forEach(cat => {
                const div = document.createElement('div');
                div.classList.add('flex', 'items-center', 'mb-2');
                
                const checkbox = document.createElement('input');
                checkbox.type = 'checkbox';
                checkbox.id = `cat-${cat.id}`;
                checkbox.value = cat.id;
                checkbox.name = 'category';
                checkbox.classList.add('mr-2', 'h-4', 'w-4', 'text-blue-600', 'bg-gray-100', 'border-gray-300', 'rounded', 'focus:ring-blue-500');
                
                const label = document.createElement('label');
                label.htmlFor = `cat-${cat.id}`;
                label.textContent = cat.name;
                label.classList.add('ms-2', 'text-sm', 'font-medium', 'text-gray-900');
                
                div.appendChild(checkbox);
                div.appendChild(label);
                elements.categorySelectorDiv.appendChild(div);
            });
        } else { 
            elements.categorySelectorDiv.innerHTML = '<p class="text-red-500 italic">Tidak ada kategori tersedia.</p>'; 
        }
    } catch (error) {
        console.error("Fetch Categories Err:", error);
        if(elements.categoryLoadingP) elements.categoryLoadingP.classList.add('hidden');
        if(elements.categorySelectorDiv) {
            elements.categorySelectorDiv.innerHTML = 
                `<p class="text-red-500 italic">Gagal memuat kategori: ${error.message || 'Tidak bisa menghubungi server.'}</p>`;
        }
    }
}

export async function fetchQuestionsGeneric(endpoint) {
    if (!elements.startFeedbackDiv) { 
        console.error("startFeedbackDiv is null in fetchQuestionsGeneric"); 
        return false; 
    }
    
    ui.showLoading(); 
    elements.startFeedbackDiv.textContent = '';
    
    try {
        const headers = {};
        if (state.isLoggedIn && state.authToken && endpoint.includes("/quiz/start?")) {
            headers['Authorization'] = `Bearer ${state.authToken}`;
        }
        
        const response = await fetch(endpoint, { headers });
        if (response.status === 401 && state.isLoggedIn) { 
            throw new Error('Sesi tidak valid atau token kedaluwarsa.'); 
        }
        
        if (!response.ok) { 
            const errorData = await response.json().catch(() => ({ 
                detail: `Gagal memuat soal (HTTP ${response.status})` 
            })); 
            throw new Error(errorData.detail || response.statusText); 
        }
        
        const data = await response.json();
        if (data && data.session_id && Array.isArray(data.questions)) {
            updateState({
                currentQuizSessionId: data.session_id,
                questions: data.questions,
                currentQuestionIndex: 0,
                userAnswers: []
            });
            
            console.log("Received session ID:", state.currentQuizSessionId);
            console.log("QUESTIONS DATA:", JSON.parse(JSON.stringify(state.questions)));
            
            if (state.questions.length > 0 && state.questions[0]?.options) {
                console.log("First question's options:", data.questions[0].options, 
                          "Is Array?", Array.isArray(data.questions[0].options));
            }
        } else { 
            console.error("Data kuis dari backend tidak sesuai format:", data); 
            throw new Error("Format data kuis tidak dikenali dari server."); 
        }
        
        if (state.questions.length === 0) { 
            elements.startFeedbackDiv.textContent = "Tidak ada soal ditemukan untuk kriteria ini."; 
            ui.showView('setup'); 
            ui.hideLoading(); 
            return false; 
        }
        
        ui.showView('quiz'); 
        displayQuestion(state.currentQuestionIndex); 
        return true;
    } catch (error) {
        console.error("Fetch Questions Generic Err:", error);
        elements.startFeedbackDiv.textContent = `Gagal memulai kuis: ${error.message}`;
        if (error.message.includes("Sesi tidak valid")) { 
            handleLogout(); 
        }
        ui.showView('setup'); 
        ui.hideLoading(); 
        return false;
    }
}

export async function fetchQuizQuestions() {
    if (!elements.categorySelectorDiv) { 
        console.error("categorySelectorDiv null in fetchQuizQuestions"); 
        return;
    }
    
    const selectedCategoryCheckboxes = elements.categorySelectorDiv.querySelectorAll('input[name="category"]:checked');
    const selectedCategoryIds = Array.from(selectedCategoryCheckboxes).map(cb => cb.value);
    const selectedDifficultyInput = document.querySelector('input[name="quiz_difficulty"]:checked');
    const difficulty = selectedDifficultyInput ? selectedDifficultyInput.value : "";
    const amount = 10;
    
    console.log(`Logged In - Selected IDs: [${selectedCategoryIds.join(', ')}]. Difficulty: ${difficulty || 'Any'}`);
    
    let apiUrl = `${API_BASE_URL}/quiz/start?amount=${amount}`;
    if (selectedCategoryIds.length > 0) { 
        apiUrl += `&${selectedCategoryIds.map(id => `category_id=${encodeURIComponent(id)}`).join('&')}`; 
    }
    if (difficulty) { 
        apiUrl += `&difficulty=${encodeURIComponent(difficulty)}`; 
    }
    
    console.log("Fetching URL for logged in user:", apiUrl);
    updateState({ isGuestMode: false });
    await fetchQuestionsGeneric(apiUrl);
}

export async function fetchGuestQuizQuestions() {
    if (!elements.categorySelectorDiv) { 
        console.error("categorySelectorDiv null in fetchGuestQuizQuestions"); 
        return;
    }
    
    const selectedCategoryCheckboxes = elements.categorySelectorDiv.querySelectorAll('input[name="category"]:checked');
    const selectedCategoryIds = Array.from(selectedCategoryCheckboxes).map(cb => cb.value);
    const selectedDifficultyInput = document.querySelector('input[name="quiz_difficulty"]:checked');
    const difficulty = selectedDifficultyInput ? selectedDifficultyInput.value : "";
    const amount = 10;
    
    console.log(`Guest - Selected IDs: [${selectedCategoryIds.join(', ')}]. Difficulty: ${difficulty || 'Any'}. Info:`, state.guestInfo);
    
    let apiUrl = `${API_BASE_URL}/quiz/start-guest?amount=${amount}`;
    if (selectedCategoryIds.length > 0) { 
        apiUrl += `&${selectedCategoryIds.map(id => `category_id=${encodeURIComponent(id)}`).join('&')}`; 
    }
    if (difficulty) { 
        apiUrl += `&difficulty=${encodeURIComponent(difficulty)}`; 
    }
    
    console.log("Fetching Guest URL:", apiUrl);
    updateState({ isGuestMode: true });
    await fetchQuestionsGeneric(apiUrl);
}

export function displayQuestion(index) {
    if(!elements.questionCategorySpan || !elements.questionTextP || !elements.optionsContainer || 
       !elements.questionCounterSpan || !elements.nextButton || !elements.feedbackDiv) { 
        console.error("Missing critical UI elements for displaying question!"); 
        if(elements.quizActiveDiv) {
            elements.quizActiveDiv.innerHTML = "<p class='text-red-500 p-4 text-center'>Error: Komponen UI kuis tidak lengkap.</p>";
        }
        ui.showView('setup'); 
        ui.hideLoading(); 
        return; 
    }
    
    ui.hideLoading(); 
    if (index >= state.questions.length) { 
        submitQuiz(); 
        return; 
    }
    
    const q = state.questions[index];
    console.log("--- displayQuestion ---");
    console.log("Current Question Index:", index);
    console.log("Question Data (q) to be displayed:", JSON.parse(JSON.stringify(q)));
    
    if (q && q.options) { 
        console.log("q.options for display:", q.options); 
        console.log("Is q.options an Array?", Array.isArray(q.options)); 
        console.log("Length of q.options:", q.options.length); 
        q.options.forEach((opt, i) => { 
            console.log(`Option ${i} for display: "${opt}" (type: ${typeof opt})`); 
        });
    } else { 
        console.error("ERROR in displayQuestion: q or q.options is missing/invalid!"); 
    }

    if (!q || typeof q.question !== 'string' || !Array.isArray(q.options)) { 
        console.error("Invalid question structure for display:", q); 
        if(elements.optionsContainer) {
            elements.optionsContainer.innerHTML = "<p class='text-red-500'>Error: Format soal tidak valid.</p>";
        }
        if(elements.questionCategorySpan) {
            elements.questionCategorySpan.textContent = 'Error';
        }
        if(elements.questionTextP) {
            elements.questionTextP.textContent = 'Gagal memuat soal.';
        }
        if(elements.nextButton) {
            elements.nextButton.disabled = true;
        }
        return; 
    }

    elements.questionCategorySpan.textContent = q.category_name || 'N/A';
    elements.questionTextP.textContent = q.question;
    elements.optionsContainer.innerHTML = ''; 
    elements.feedbackDiv.textContent = ''; 
    elements.nextButton.disabled = true;

    if (q.options.length > 0) {
        q.options.forEach((optionText, optionIndex) => {
            console.log(`Creating button for option ${optionIndex + 1}: "${String(optionText)}"`);
            const button = document.createElement('button'); 
            button.textContent = String(optionText);
            button.classList.add('quiz-option', 'block', 'w-full', 'text-left', 'p-3', 'border', 
                              'border-gray-300', 'rounded-md', 'text-gray-800', 'hover:bg-blue-100', 
                              'focus:outline-none', 'focus:ring-2', 'focus:ring-blue-400', 
                              'focus:border-transparent', 'transition', 'duration-150');
            button.onclick = () => selectAnswer(q.id, optionText, button);
            elements.optionsContainer.appendChild(button);
        });
    } else { 
        console.error("No options available for this question in displayQuestion!", q); 
        if(elements.optionsContainer) {
            elements.optionsContainer.innerHTML = "<p class='text-red-500'>Error: Tidak ada pilihan jawaban untuk soal ini.</p>";
        }
    }
    
    elements.questionCounterSpan.textContent = `Soal ${index + 1} dari ${state.questions.length}`;
    elements.nextButton.textContent = (index === state.questions.length - 1) ? "Lihat Hasil" : "Selanjutnya";
}

export function selectAnswer(questionId, selectedOption, selectedButton) { 
    if (!elements.feedbackDiv || !elements.nextButton) return; 
    
    const existingAnswerIndex = state.userAnswers.findIndex(ans => ans.question_id === questionId);
    if (existingAnswerIndex > -1) {
        state.userAnswers[existingAnswerIndex].user_answer = selectedOption;
    } else {
        state.userAnswers.push({ 
            question_id: questionId, 
            user_answer: selectedOption 
        });
    }
    
    document.querySelectorAll('.quiz-option').forEach(btn => { 
        btn.classList.remove('selected', 'bg-blue-400', 'text-white', 'border-blue-500'); 
        btn.classList.add('text-gray-800', 'border-gray-300'); 
    }); 
    
    selectedButton.classList.add('selected', 'bg-blue-400', 'text-white', 'border-blue-500'); 
    selectedButton.classList.remove('text-gray-800'); 
    elements.feedbackDiv.textContent = ''; 
    elements.nextButton.disabled = false; 
}

export function nextQuestion() { 
    if (!elements.feedbackDiv) return; 
    
    const currentQuestionId = state.questions[state.currentQuestionIndex]?.id;
    const currentAnswer = state.userAnswers.find(ans => ans.question_id === currentQuestionId);
    
    if (!currentAnswer) { 
        elements.feedbackDiv.textContent = "Pilih jawaban dulu!"; 
        return; 
    } 
    
    ui.showLoading(); 
    updateState({ currentQuestionIndex: state.currentQuestionIndex + 1 });
    
    if (state.currentQuestionIndex < state.questions.length) {
        setTimeout(() => displayQuestion(state.currentQuestionIndex), 100);
    } else { 
        submitQuiz(); 
    }
}

export async function submitQuiz() {
    if (!elements.feedbackDiv) return; 
    console.log("submitQuiz called. isGuestMode:", state.isGuestMode);
    
    const quizEndPoint = state.isGuestMode ? 
        `/quiz/${state.currentQuizSessionId}/calculate-guest-result` : 
        `/quiz/${state.currentQuizSessionId}/submit`;
    
    console.log(`Submitting ${state.isGuestMode ? "GUEST" : "LOGGED IN USER"} to: ${API_BASE_URL}${quizEndPoint}`);
    
    if (!state.currentQuizSessionId) { 
        console.error("No quiz session ID."); 
        elements.feedbackDiv.textContent = "Error: Sesi kuis tidak valid."; 
        return; 
    }
    
    if (!state.isGuestMode && (!state.isLoggedIn || !state.authToken)) { 
        elements.feedbackDiv.textContent = "Login diperlukan."; 
        ui.showView('login'); 
        ui.hideLoading(); 
        return; 
    }
    
    const lastQuestionId = (state.questions.length > 0 && state.currentQuestionIndex === state.questions.length -1) ? 
        state.questions[state.currentQuestionIndex].id : null;
    const lastAnswer = state.userAnswers.find(ans => ans.question_id === lastQuestionId);
    
    if (!lastAnswer && state.currentQuestionIndex === state.questions.length -1 && state.questions.length > 0) { 
        elements.feedbackDiv.textContent = "Jawab soal terakhir dulu!"; 
        ui.hideLoading(); 
        return; 
    }

    ui.showLoading();
    try {
        const headers = {'Content-Type': 'application/json'};
        if (!state.isGuestMode) { 
            headers['Authorization'] = `Bearer ${state.authToken}`; 
        }
        
        const response = await fetch(`${API_BASE_URL}${quizEndPoint}`, { 
            method: 'POST', 
            headers: headers, 
            body: JSON.stringify({ answers: state.userAnswers }) 
        });
        
        const data = await response.json();
        if (response.status === 401 && state.isLoggedIn) {
            throw new Error('Sesi tidak valid.');
        }
        
        if (!response.ok) {
            throw new Error(data.detail || `Gagal submit/kalkulasi (HTTP ${response.status})`);
        }
        
        console.log(`${state.isGuestMode ? "Guest" : "Logged in"} submit OK, results:`, data);
        displayResults(data);
    } catch (error) { 
        console.error(`Submit Error (${state.isGuestMode ? "Guest" : "Logged In"}):`, error); 
        elements.feedbackDiv.textContent = `Gagal: ${error.message}`; 
        if (error.message.includes("Sesi tidak valid") && state.isLoggedIn) { 
            handleLogout(); 
        } 
        ui.hideLoading(); 
    }
}

export function displayResults(results) {
    console.log("Attempting display results:", results);
    const viewShown = ui.showView('results');
    if (!viewShown) { 
        console.error("!!! Failed to show 'results' view! Aborting."); 
        ui.hideLoading(); 
        return; 
    }

    const res_finalScoreSpan = document.getElementById('final-score');
    const res_correctCountSpan = document.getElementById('correct-count');
    const res_totalCountSpan = document.getElementById('total-count');
    const res_categoryAnalysisDiv = document.getElementById('category-analysis');
    const res_recommendationsDiv = document.getElementById('recommendations');
    const res_incorrectQuestionsDiv = document.getElementById('incorrect-questions-summary');

    console.log("Finding elements INSIDE displayResults:", {
        res_finalScoreSpan, res_correctCountSpan, res_totalCountSpan, 
        res_categoryAnalysisDiv, res_recommendationsDiv, res_incorrectQuestionsDiv
    });
    
    if(!res_finalScoreSpan || !res_correctCountSpan || !res_totalCountSpan || 
       !res_categoryAnalysisDiv || !res_recommendationsDiv || !res_incorrectQuestionsDiv) {
        console.error(">>> Missing CRITICAL results UI elements! Check IDs & HTML structure. <<<");
        if (elements.resultsDiv) { 
            elements.resultsDiv.innerHTML = `
                <p class="text-red-500 p-4 text-center">Error: Gagal struktur hasil.</p>
                <button id="reset-quiz-btn-fallback" class="btn-gray mt-4">Kembali</button>
            `; 
            const fbBtn = document.getElementById('reset-quiz-btn-fallback'); 
            if(fbBtn) fbBtn.addEventListener('click', resetQuiz); 
        }
        ui.hideLoading(); 
        return;
    }
    console.log("Critical results elements found.");

    try { 
        res_finalScoreSpan.textContent = results.score_percentage?.toFixed(1) ?? 'N/A'; 
        res_correctCountSpan.textContent = results.correct_answers_count ?? '?'; 
        res_totalCountSpan.textContent = results.total_questions ?? '?'; 
        
        res_categoryAnalysisDiv.innerHTML = ''; 
        if (results.analysis && results.analysis.length > 0) { 
            results.analysis.forEach(cat => { 
                const div = document.createElement('div'); 
                div.classList.add('p-3', 'border', 'rounded', 'bg-gray-50'); 
                const scoreColor = cat.score_percentage < 60 ? 'text-red-600' : 'text-green-600'; 
                div.innerHTML = `
                    <span class="font-medium text-gray-800">${cat.category_name}:</span> 
                    <span class="${scoreColor} font-bold">${cat.score_percentage?.toFixed(1) ?? 'N/A'}%</span> 
                    <span class="text-sm text-gray-600"> (${cat.correct_count ?? '?'}/${cat.total_questions ?? '?'} benar)</span>
                `; 
                res_categoryAnalysisDiv.appendChild(div); 
            }); 
        } else { 
            res_categoryAnalysisDiv.innerHTML = '<p class="text-gray-500 italic">Tidak ada data analisis kategori.</p>'; 
        } 
    } catch (uiError) { 
        console.error("Error populating results UI:", uiError); 
        if(res_categoryAnalysisDiv) {
            res_categoryAnalysisDiv.innerHTML = '<p class="text-red-500 italic">Error tampilkan analisis.</p>';
        }
    }
    
    if (res_incorrectQuestionsDiv) { 
        res_incorrectQuestionsDiv.innerHTML = ''; 
        if (results.incorrect_questions && results.incorrect_questions.length > 0) { 
            const header = document.createElement('h4'); 
            header.classList.add('text-md', 'font-semibold', 'mb-2', 'text-gray-700', 'mt-4'); 
            header.textContent = "Pembahasan Soal yang Salah:"; 
            res_incorrectQuestionsDiv.appendChild(header); 
            
            results.incorrect_questions.forEach(iq => { 
                const itemDiv = document.createElement('div'); 
                itemDiv.classList.add('p-3', 'border-b', 'text-sm', 'border-gray-200'); 
                itemDiv.innerHTML = `
                    <p class="font-medium text-gray-800">P: ${iq.question_text}</p>
                    <p class="text-red-500">Jawabanmu: ${iq.user_answer}</p>
                    <p class="text-green-600">Jawaban Benar: ${iq.correct_answer}</p>
                `; 
                res_incorrectQuestionsDiv.appendChild(itemDiv); 
            }); 
        } else { 
            res_incorrectQuestionsDiv.innerHTML = '<p class="text-green-600 italic p-3 text-center">Selamat! Semua jawabanmu benar!</p>'; 
        } 
    }

    console.log("Calling fetchRecommendations...");
    if (res_recommendationsDiv) {
        const recommendationRequestPayload = { 
            analysis: results.analysis || [], 
            incorrect_questions: results.incorrect_questions || [] 
        };
        console.log("Payload untuk rekomendasi:", recommendationRequestPayload);
        recommendation.fetchRecommendations(recommendationRequestPayload, res_recommendationsDiv);
    } else { 
        console.error("Cannot call fetchRecommendations, recommendationsDiv is missing AT CALL SITE."); 
        ui.hideLoading(); 
    }
}

export function resetQuiz() { 
    const el = { 
        sf: document.getElementById('start-feedback'), 
        f: document.getElementById('feedback'), 
        ca: document.getElementById('category-analysis'), 
        rc: document.getElementById('recommendations')
    }; 
    
    updateState({
        currentQuizSessionId: null,
        questions: [],
        currentQuestionIndex: 0,
        userAnswers: [],
        isGuestMode: false,
        guestInfo: { name: null, status: null, institution: null }
    });
    
    if(el.sf) el.sf.textContent = '';
    if(el.f) el.f.textContent = '';
    if(el.ca) el.ca.innerHTML = '';
    if(el.rc) el.rc.innerHTML = '';
    
    ui.showView('setup'); 
}