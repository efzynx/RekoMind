import { elements } from './dom_elements.js';
import * as auth from './auth_api.js';
import * as quiz from './quiz_api.js';
import * as ui from './ui_handlers.js';
import * as history from './history_api.js';
import { state } from './state.js';
import { updateState } from './state.js';
import { API_BASE_URL } from './config.js';
import * as adminAPI from './admin_api.js';
// import * as analysisAPI from './analysis_api.js';
import { runAndDisplayHolisticAnalysis } from './analysis_api.js';



async function handleDeepAnalysisClick() {
    if (elements.deepAnalysisLoading) elements.deepAnalysisLoading.classList.remove('hidden');
    if (elements.deepAnalysisResults) elements.deepAnalysisResults.innerHTML = ''; // Kosongkan hasil lama
    try {
        const analysisResult = await analysisAPI.fetchDeepAnalysisAPI();
        ui.displayDeepAnalysisUI(analysisResult);
    } catch (error) {
        console.error("Event: Gagal mengambil analisis mendalam", error);
        if (elements.deepAnalysisResults) elements.deepAnalysisResults.innerHTML = `<p class="text-red-500">Gagal memuat analisis: ${error.message}</p>`;
    } finally {
        if (elements.deepAnalysisLoading) elements.deepAnalysisLoading.classList.add('hidden');
    }
}

export function setupEventListeners() {
    console.log("Attaching event listeners...");

    // elements.runDeepAnalysisBtn?.addEventListener('click', handleDeepAnalysisClick);
    elements.runDeepAnalysisBtn?.addEventListener('click', runAndDisplayHolisticAnalysis);
    
    // Navigation
    elements.showLoginBtn?.addEventListener('click', () => { 
        ui.showView('login'); 
        if(elements.loginErrorDiv) elements.loginErrorDiv.textContent = ''; 
    });
    
    elements.showRegisterBtn?.addEventListener('click', () => { 
        ui.showView('register'); 
        if(elements.registerErrorDiv) elements.registerErrorDiv.textContent = ''; 
    });
    
    elements.cancelLoginBtn?.addEventListener('click', () => { 
        ui.showView('setup'); 
        elements.loginForm?.reset(); 
        if(elements.loginErrorDiv) elements.loginErrorDiv.textContent = ''; 
    });
    
    
    elements.cancelRegisterBtn?.addEventListener('click', () => { 
        ui.showView('setup'); 
        elements.registerForm?.reset(); 
        if(elements.registerErrorDiv) elements.registerErrorDiv.textContent = ''; 
        if(elements.registerInstitutionInputDiv) elements.registerInstitutionInputDiv.classList.add('hidden'); 
    });
    
    // Auth forms
    elements.loginForm?.addEventListener('submit', auth.handleLogin); 
    elements.registerForm?.addEventListener('submit', auth.handleRegister); 
    elements.logoutBtn?.addEventListener('click', auth.handleLogout);
    elements.downloadHistoryBtn?.addEventListener('click', async () => {
    ui.showLoading();
    try {
        const result = await adminAPI.downloadHistoryAPI();
        alert(result.message);
    } catch (error) {
        console.error("Gagal mengunduh riwayat:", error);
        alert(`Gagal: ${error.message}`);
    } finally {
        ui.hideLoading();
    }
});

    
    // History
    elements.showHistoryBtn?.addEventListener('click', history.fetchAndDisplayHistory); 
    elements.closeHistoryBtn?.addEventListener('click', () => { ui.showView('setup'); });
    
    // Guest mode
    elements.promptLoginBtn?.addEventListener('click', () => ui.showView('login')); 
    elements.promptRegisterBtn?.addEventListener('click', () => ui.showView('register')); 
    elements.promptGuestBtn?.addEventListener('click', () => ui.showView('guestInfo')); 
    elements.promptCancelBtn?.addEventListener('click', () => ui.showView('setup'));
    
    // Register form education level change
    elements.registerEducationLevelSelect?.addEventListener('change', (event) => { 
        const status = event.target.value; 
        if (elements.registerInstitutionInputDiv && elements.registerInstitutionLabel && elements.registerInstitutionInput) { 
            elements.registerInstitutionInputDiv.classList.add('hidden'); 
            elements.registerInstitutionInput.required = false; 
            
            if (status === 'Siswa') { 
                elements.registerInstitutionLabel.textContent = 'Nama Sekolah*'; 
                elements.registerInstitutionInputDiv.classList.remove('hidden'); 
                elements.registerInstitutionInput.required = true; 
            } else if (status === 'Mahasiswa') { 
                elements.registerInstitutionLabel.textContent = 'Nama Universitas*'; 
                elements.registerInstitutionInputDiv.classList.remove('hidden'); 
                elements.registerInstitutionInput.required = true; 
            } 
        } 
    });
    
    // Guest info form status change
    elements.guestStatusSelect?.addEventListener('change', (event) => { 
        const status = event.target.value; 
        if(elements.guestSchoolInputDiv) elements.guestSchoolInputDiv.classList.add('hidden'); 
        if(elements.guestUniversityInputDiv) elements.guestUniversityInputDiv.classList.add('hidden'); 
        if(elements.guestSchoolInput) elements.guestSchoolInput.required = false; 
        if(elements.guestUniversityInput) elements.guestUniversityInput.required = false; 
        
        if (status === 'Siswa') { 
            if(elements.guestSchoolInputDiv) elements.guestSchoolInputDiv.classList.remove('hidden'); 
            if(elements.guestSchoolInput) elements.guestSchoolInput.required = true; 
        } else if (status === 'Mahasiswa') { 
            if(elements.guestUniversityInputDiv) elements.guestUniversityInputDiv.classList.remove('hidden'); 
            if(elements.guestUniversityInput) elements.guestUniversityInput.required = true; 
        } 
    });
    
    // Guest info form submit
    elements.guestInfoForm?.addEventListener('submit', (event) => { 
        event.preventDefault(); 
        if(elements.guestInfoErrorDiv) elements.guestInfoErrorDiv.textContent = ''; 
        
        const name = elements.guestNameInput?.value.trim(); 
        const status = elements.guestStatusSelect?.value; 
        let institution = null; 
        
        if (!name || !status) { 
            if(elements.guestInfoErrorDiv) elements.guestInfoErrorDiv.textContent = 'Nama & Status wajib.'; 
            return; 
        } 
        
        if (status === 'Siswa') { 
            institution = elements.guestSchoolInput?.value.trim(); 
            if (!institution) { 
                if(elements.guestInfoErrorDiv) elements.guestInfoErrorDiv.textContent = 'Nama Sekolah wajib.'; 
                return; 
            } 
        } else if (status === 'Mahasiswa') { 
            institution = elements.guestUniversityInput?.value.trim(); 
            if (!institution) { 
                if(elements.guestInfoErrorDiv) elements.guestInfoErrorDiv.textContent = 'Nama Universitas wajib.'; 
                return; 
            } 
        } 
        
        updateState({
            guestInfo: { name, status, institution },
            isGuestMode: true
        });
        
        console.log("Melanjutkan sebagai tamu:", state.guestInfo); 
        elements.guestInfoModal?.classList.add('hidden'); 
        elements.guestInfoModal?.classList.remove('flex'); 
        quiz.fetchGuestQuizQuestions(); 
    });
    
    elements.cancelGuestInfoBtn?.addEventListener('click', () => { 
        ui.showView('guestPrompt'); 
        elements.guestInfoForm?.reset(); 
        if(elements.guestInfoErrorDiv) elements.guestInfoErrorDiv.textContent = ''; 
        if(elements.guestSchoolInputDiv) elements.guestSchoolInputDiv.classList.add('hidden'); 
        if(elements.guestUniversityInputDiv) elements.guestUniversityInputDiv.classList.add('hidden'); 
    });
    
    // Quiz category selection
    elements.selectAllButton?.addEventListener('click', () => { 
        elements.categorySelectorDiv?.querySelectorAll('input[type="checkbox"]').forEach(cb => { 
            cb.checked = true; 
        }); 
    });
    
    elements.deselectAllButton?.addEventListener('click', () => { 
        elements.categorySelectorDiv?.querySelectorAll('input[type="checkbox"]').forEach(cb => { 
            cb.checked = false; 
        }); 
    });
    
    // Start quiz button
    elements.startButton?.addEventListener('click', () => { 
        if(elements.startFeedbackDiv) elements.startFeedbackDiv.textContent = ''; 
        if (state.isLoggedIn) { 
            quiz.fetchQuizQuestions(); 
        } else { 
            ui.showView('guestPrompt'); 
        } 
    });
    
    // Next question button
    elements.nextButton?.addEventListener('click', () => { 
        const quizActiveDiv = document.getElementById('quiz-active'); 
        if (!quizActiveDiv || quizActiveDiv.classList.contains('hidden')) return; 
        
        const feedbackDiv = document.getElementById('feedback'); 
        if (state.currentQuestionIndex >= state.questions.length - 1) { 
            const lastQuestionId = state.questions[state.currentQuestionIndex]?.id; 
            const lastAnswer = state.userAnswers.find(ans => ans.question_id === lastQuestionId); 
            
            if (!lastAnswer) { 
                if(feedbackDiv) feedbackDiv.textContent = "Jawab soal terakhir dulu!"; 
                return; 
            } 
            quiz.submitQuiz(); 
        } else { 
            quiz.nextQuestion(); 
        } 
    });

    /*
    elements.showHistoryBtn?.addEventListener('click', async () => {
    ui.showView('history');
    await history.fetchAndDisplayHistory();
    try {
        const analysis = await analysisAPI.fetchDeepAnalysisAPI();
        ui.displayDeepAnalysisUI(analysis);
    } catch (error) {
        console.error("Gagal mengambil analisis:", error);
        if (elements.deepAnalysisResults)
            elements.deepAnalysisResults.innerHTML = `<p class="text-red-500 italic">Gagal memuat analisis: ${error.message}</p>`;
    }
});*/

elements.showHistoryBtn?.addEventListener('click', () => {
    ui.showView('history');
    history.fetchAndDisplayHistory(); // Cukup panggil fungsi untuk menampilkan riwayat
});
    
    // Reset quiz button
    elements.resetButton?.addEventListener('click', quiz.resetQuiz);
    
    // Password visibility toggle
    elements.toggleLoginPasswordBtn?.addEventListener('click', () => { 
        ui.togglePasswordVisibility('login-password', elements.toggleLoginPasswordBtn); 
    });
    
    elements.toggleRegisterPasswordBtn?.addEventListener('click', () => { 
        ui.togglePasswordVisibility('register-password', elements.toggleRegisterPasswordBtn); 
    });
    
    console.log("Event listeners attached.");
}