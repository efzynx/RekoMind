// File: script.js (LENGKAP - Fix "Missing results UI elements" pada run ke-2)

// --- Konfigurasi & State ---
const API_BASE_URL = "/api/v1"; //vercel
// const API_BASE_URL = "http://localhost:8000/api/v1"; //localhost

let currentQuizSessionId = null; let questions = []; let currentQuestionIndex = 0; let userAnswers = [];
let isLoggedIn = false; let authToken = localStorage.getItem('authToken'); let currentUserEmail = null;
let isGuestMode = false; let guestInfo = { name: null, status: null, institution: null };

// --- Deklarasi Variabel Referensi DOM ---
let setupDiv = null, quizActiveDiv = null, resultsDiv = null, loadingIndicator = null, historySection = null, historyListDiv = null;
let authArea = null, loggedOutView = null, loggedInView = null, userEmailSpan = null, showLoginBtn = null, showRegisterBtn = null, logoutBtn = null, showHistoryBtn = null, closeHistoryBtn = null;
let loginFormSection = null, registerFormSection = null, loginForm = null, registerForm = null, loginEmailInput = null, loginPasswordInput = null, loginErrorDiv = null, registerEmailInput = null, registerPasswordInput = null, registerErrorDiv = null, cancelLoginBtn = null, cancelRegisterBtn = null;
let categorySelectorDiv = null, categoryLoadingP = null, selectAllButton = null, deselectAllButton = null, startFeedbackDiv = null, startButton = null;
let questionCategorySpan = null, questionTextP = null, optionsContainer = null, questionCounterSpan = null, feedbackDiv = null, nextButton = null;
// Kita tidak perlu variabel global untuk elemen *di dalam* results lagi
// let finalScoreSpan = null, correctCountSpan = null, totalCountSpan = null, categoryAnalysisDiv = null, recommendationsDiv = null, recommendationsLoadingP = null;
let resetButton = null;
let guestPromptModal = null, guestInfoModal = null, promptLoginBtn = null, promptRegisterBtn = null, promptGuestBtn = null, promptCancelBtn = null;
let guestInfoForm = null, guestNameInput = null, guestStatusSelect = null, guestSchoolInputDiv = null, guestSchoolInput = null, guestUniversityInputDiv = null, guestUniversityInput = null, guestInfoErrorDiv = null, cancelGuestInfoBtn = null;
let toggleLoginPasswordBtn = null, toggleRegisterPasswordBtn = null;

// --- Fungsi Utilitas UI ---
function showLoading() { if(loadingIndicator) { loadingIndicator.classList.remove('hidden'); loadingIndicator.classList.add('flex'); } }
function hideLoading() { if(loadingIndicator) { loadingIndicator.classList.add('hidden'); loadingIndicator.classList.remove('flex'); } }
function showView(viewToShow) { console.log(`Attempting to show view: ${viewToShow}`); const allViews = [ setupDiv, quizActiveDiv, resultsDiv, loginFormSection, registerFormSection, historySection, guestPromptModal, guestInfoModal ]; const modals = ['guestPrompt', 'guestInfo']; let targetElementFound = false; allViews.forEach(view => { if (view) { view.classList.add('hidden'); view.classList.remove('flex'); } }); let viewElementToShow = null; switch (viewToShow) { case 'setup': viewElementToShow = setupDiv; break; case 'quiz': viewElementToShow = quizActiveDiv; break; case 'results': viewElementToShow = resultsDiv; break; case 'login': viewElementToShow = loginFormSection; break; case 'register': viewElementToShow = registerFormSection; break; case 'history': viewElementToShow = historySection; break; case 'guestPrompt': viewElementToShow = guestPromptModal; break; case 'guestInfo': viewElementToShow = guestInfoModal; break; default: console.warn(`Unknown view: ${viewToShow}. Defaulting to setup.`); viewElementToShow = setupDiv; } if (viewElementToShow) { viewElementToShow.classList.remove('hidden'); if(modals.includes(viewToShow)) viewElementToShow.classList.add('flex'); console.log(`Displayed view: ${viewToShow}`); targetElementFound = true; } else { console.error(`!!! Element variable for view '${viewToShow}' is NULL in showView!`); if (setupDiv) setupDiv.classList.remove('hidden'); } return targetElementFound; }

// --- Fungsi Update UI Auth ---
function updateAuthUI() { /* ... kode SAMA seperti sebelumnya ... */ if (!loggedOutView || !loggedInView || !userEmailSpan || !showHistoryBtn) return; if (isLoggedIn) { loggedOutView.classList.add('hidden'); loggedInView.classList.remove('hidden'); userEmailSpan.textContent = currentUserEmail || 'User'; userEmailSpan.title = currentUserEmail || 'User'; if(showHistoryBtn) showHistoryBtn.classList.remove('hidden'); } else { loggedOutView.classList.remove('hidden'); loggedInView.classList.add('hidden'); userEmailSpan.textContent = ''; userEmailSpan.title = ''; if(historySection) historySection.classList.add('hidden'); if(showHistoryBtn) showHistoryBtn.classList.add('hidden'); } if(isLoggedIn){ if(loginFormSection) loginFormSection.classList.add('hidden'); if(registerFormSection) registerFormSection.classList.add('hidden'); } }

// --- Fungsi Auth API Calls --- (Tidak ada perubahan)
async function handleRegister(event) { /* ... kode SAMA ... */ event.preventDefault(); if(!registerErrorDiv || !registerEmailInput || !registerPasswordInput || !registerForm) return; registerErrorDiv.textContent = ''; showLoading(); try { const response = await fetch(`${API_BASE_URL}/auth/register`, { method: 'POST', headers: { 'Content-Type': 'application/json' }, body: JSON.stringify({ email: registerEmailInput.value, password: registerPasswordInput.value }), }); const data = await response.json(); if (!response.ok) throw new Error(data.detail || `Registrasi gagal (${response.status})`); console.log('Reg OK:', data); alert('Registrasi berhasil! Login.'); showView('login'); registerForm.reset(); } catch (error) { console.error("Reg Err:", error); registerErrorDiv.textContent = error.message; } finally { hideLoading(); } }
async function handleLogin(event) { /* ... kode SAMA ... */ event.preventDefault(); if(!loginErrorDiv || !loginEmailInput || !loginPasswordInput || !loginForm) return; loginErrorDiv.textContent = ''; showLoading(); try { const formData = new FormData(); formData.append('username', loginEmailInput.value); formData.append('password', loginPasswordInput.value); const response = await fetch(`${API_BASE_URL}/auth/login`, { method: 'POST', body: formData }); const data = await response.json(); if (!response.ok) throw new Error(data.detail || `Login gagal (${response.status}).`); console.log('Login OK:', data); authToken = data.access_token; if (!authToken) throw new Error("Token tidak diterima."); localStorage.setItem('authToken', authToken); isLoggedIn = true; currentUserEmail = loginEmailInput.value; await fetchUserInfo(); showView('setup'); loginForm.reset(); } catch (error) { console.error("Login Err:", error); loginErrorDiv.textContent = error.message; isLoggedIn = false; authToken = null; localStorage.removeItem('authToken'); updateAuthUI(); } finally { hideLoading(); } }
function handleLogout() { /* ... kode SAMA ... */ showLoading(); console.log("Logging out..."); authToken = null; localStorage.removeItem('authToken'); isLoggedIn = false; currentUserEmail = null; isGuestMode = false; guestInfo = { name: null, status: null, institution: null }; updateAuthUI(); showView('setup'); console.log("Logged out."); hideLoading(); }
async function fetchUserInfo() { /* ... kode SAMA ... */ authToken = localStorage.getItem('authToken'); if (!authToken) { console.log("No auth token."); isLoggedIn = false; currentUserEmail = null; updateAuthUI(); return; } console.log("Fetching user info..."); if (!isLoggedIn) showLoading(); try { const response = await fetch(`${API_BASE_URL}/users/me`, { method: 'GET', headers: { 'Authorization': `Bearer ${authToken}` } }); if (response.status === 401) { throw new Error('Sesi tidak valid.'); } if (!response.ok) { const errorData = await response.json().catch(() => ({detail: `Gagal ambil data user (${response.status})`})); throw new Error(errorData.detail); } const userData = await response.json(); currentUserEmail = userData.email; isLoggedIn = true; console.log("User info OK:", userData); } catch (error) { console.error("Fetch User Err:", error.message); handleLogout(); } finally { updateAuthUI(); hideLoading(); } }

// --- Fungsi Memuat Kategori --- (Tidak ada perubahan)
async function fetchAndDisplayCategories() { /* ... kode SAMA ... */ if (!categorySelectorDiv || !categoryLoadingP) { console.error("Category UI elements variable is null!"); return; } categoryLoadingP.classList.remove('hidden'); try { const response = await fetch(`${API_BASE_URL}/quiz/categories`); if (!response.ok) throw new Error(`Gagal memuat kategori: ${response.statusText}`); const categories = await response.json(); categoryLoadingP.classList.add('hidden'); categorySelectorDiv.innerHTML = ''; if (categories && categories.length > 0) { categories.sort((a, b) => a.name.localeCompare(b.name)); categories.forEach(cat => { const div = document.createElement('div'); div.classList.add('flex', 'items-center', 'mb-2'); const checkbox = document.createElement('input'); checkbox.type = 'checkbox'; checkbox.id = `cat-${cat.id}`; checkbox.value = cat.id; checkbox.name = 'category'; checkbox.classList.add('mr-2', 'h-4', 'w-4', 'text-blue-600', 'bg-gray-100', 'border-gray-300', 'rounded', 'focus:ring-blue-500'); const label = document.createElement('label'); label.htmlFor = `cat-${cat.id}`; label.textContent = cat.name; label.classList.add('ms-2', 'text-sm', 'font-medium', 'text-gray-900'); div.appendChild(checkbox); div.appendChild(label); categorySelectorDiv.appendChild(div); }); } else { categorySelectorDiv.innerHTML = '<p class="text-red-500 italic">Tidak ada kategori.</p>'; } } catch (error) { console.error("Fetch Categories Err:", error); categoryLoadingP.classList.add('hidden'); categorySelectorDiv.innerHTML = `<p class="text-red-500 italic">${error.message || 'Gagal hubungi server.'}</p>`; } }

// --- Fungsi Logika Kuis --- (Tidak ada perubahan)
async function fetchQuizQuestions() { /* ... kode SAMA ... */ if (!startFeedbackDiv || !categorySelectorDiv) return; if (!isLoggedIn) { startFeedbackDiv.textContent = "Anda harus login."; showView('login'); return; } showLoading(); startFeedbackDiv.textContent = ''; const selectedCategoryCheckboxes = categorySelectorDiv.querySelectorAll('input[name="category"]:checked'); const selectedCategoryIds = Array.from(selectedCategoryCheckboxes).map(cb => cb.value); const amount = 10; console.log("Selected IDs:", selectedCategoryIds); let apiUrl = `${API_BASE_URL}/quiz/start?amount=${amount}`; if (selectedCategoryIds.length > 0) { const categoryParams = selectedCategoryIds.map(id => `category_id=${encodeURIComponent(id)}`).join('&'); apiUrl += `&${categoryParams}`; } console.log("Fetching URL:", apiUrl); try { const headers = {}; if (isLoggedIn && authToken) { headers['Authorization'] = `Bearer ${authToken}`; } else { throw new Error("Otentikasi diperlukan."); } const response = await fetch(apiUrl, { headers: headers }); if (response.status === 401) { throw new Error('Sesi tidak valid.'); } if (!response.ok) { const errorData = await response.json().catch(() => ({ detail: `Gagal memuat soal (${response.status})` })); throw new Error(errorData.detail || response.statusText); } const data = await response.json(); if (data && data.session_id && Array.isArray(data.questions)) { currentQuizSessionId = data.session_id; questions = data.questions; console.log("Received session ID:", currentQuizSessionId); } else { console.error("Data kuis tidak sesuai:", data); throw new Error("Format data kuis tidak dikenali."); } if (questions.length === 0) { startFeedbackDiv.textContent = "Tidak ada soal ditemukan."; showView('setup'); hideLoading(); return; } currentQuestionIndex = 0; userAnswers = []; isGuestMode = false; showView('quiz'); displayQuestion(currentQuestionIndex); } catch (error) { console.error("Fetch Quiz Err:", error); startFeedbackDiv.textContent = `Gagal memulai kuis: ${error.message}`; if (error.message.includes("Sesi tidak valid")) { handleLogout(); } showView('setup'); hideLoading(); } }
async function fetchGuestQuizQuestions() { /* ... kode SAMA ... */ if (!startFeedbackDiv || !categorySelectorDiv) return; showLoading(); startFeedbackDiv.textContent = ''; const selectedCategoryCheckboxes = categorySelectorDiv.querySelectorAll('input[name="category"]:checked'); const selectedCategoryIds = Array.from(selectedCategoryCheckboxes).map(cb => cb.value); const amount = 10; console.log("Guest start. Categories:", selectedCategoryIds, "Info:", guestInfo); let apiUrl = `${API_BASE_URL}/quiz/start-guest?amount=${amount}`; if (selectedCategoryIds.length > 0) { const categoryParams = selectedCategoryIds.map(id => `category_id=${encodeURIComponent(id)}`).join('&'); apiUrl += `&${categoryParams}`; } console.log("Fetching Guest URL:", apiUrl); try { const response = await fetch(apiUrl); if (!response.ok) { const errorData = await response.json().catch(() => ({ detail: `Gagal memuat soal tamu (${response.status})` })); throw new Error(errorData.detail || response.statusText); } const data = await response.json(); if (data && data.session_id && Array.isArray(data.questions)) { currentQuizSessionId = data.session_id; questions = data.questions; console.log("Received GUEST session ID:", currentQuizSessionId); } else { console.error("Struktur data kuis tamu tidak sesuai:", data); throw new Error("Format data kuis tamu tidak dikenali."); } if (questions.length === 0) { startFeedbackDiv.textContent = "Tidak ada soal ditemukan."; showView('setup'); hideLoading(); return; } currentQuestionIndex = 0; userAnswers = []; isGuestMode = true; showView('quiz'); displayQuestion(currentQuestionIndex); } catch (error) { console.error("Fetch Guest Quiz Err:", error); startFeedbackDiv.textContent = `Gagal memulai kuis tamu: ${error.message}`; showView('setup'); hideLoading(); } }
function displayQuestion(index) { /* ... kode SAMA ... */ if(!questionCategorySpan || !questionTextP || !optionsContainer || !questionCounterSpan || !nextButton || !feedbackDiv) { console.error("Missing elements in displayQuestion DOM Refs"); return; } hideLoading(); if (index >= questions.length) { submitQuiz(); return; } const q = questions[index]; questionCategorySpan.textContent = q.category_name; questionTextP.textContent = q.question; optionsContainer.innerHTML = ''; feedbackDiv.textContent = ''; nextButton.disabled = true; q.options.forEach(option => { const button = document.createElement('button'); button.textContent = option; button.classList.add( 'quiz-option', 'block', 'w-full', 'text-left', 'p-3', 'border', 'border-gray-300', 'rounded-md', 'text-gray-800', 'hover:bg-blue-100', 'focus:outline-none', 'focus:ring-2', 'focus:ring-blue-400', 'focus:border-transparent', 'transition', 'duration-150'); button.onclick = () => selectAnswer(q.id, option, button); optionsContainer.appendChild(button); }); questionCounterSpan.textContent = `Soal ${index + 1} dari ${questions.length}`; if (index === questions.length - 1) nextButton.textContent = "Lihat Hasil"; else nextButton.textContent = "Selanjutnya"; }
function selectAnswer(questionId, selectedOption, selectedButton) { /* ... kode SAMA ... */ if (!feedbackDiv || !nextButton) return; const existingAnswerIndex = userAnswers.findIndex(ans => ans.question_id === questionId); if (existingAnswerIndex > -1) userAnswers[existingAnswerIndex].user_answer = selectedOption; else userAnswers.push({ question_id: questionId, user_answer: selectedOption }); document.querySelectorAll('.quiz-option').forEach(btn => { btn.classList.remove('selected', 'bg-blue-400', 'text-white', 'border-blue-500'); btn.classList.add('text-gray-800', 'border-gray-300'); }); selectedButton.classList.add('selected', 'bg-blue-400', 'text-white', 'border-blue-500'); selectedButton.classList.remove('text-gray-800'); feedbackDiv.textContent = ''; nextButton.disabled = false; }
function nextQuestion() { /* ... kode SAMA ... */ if (!feedbackDiv) return; const currentQuestionId = questions[currentQuestionIndex].id; const currentAnswer = userAnswers.find(ans => ans.question_id === currentQuestionId); if (!currentAnswer) { feedbackDiv.textContent = "Pilih jawaban dulu!"; return; } showLoading(); currentQuestionIndex++; if (currentQuestionIndex < questions.length) setTimeout(() => displayQuestion(currentQuestionIndex), 100); else submitQuiz(); }
async function submitQuiz() { /* ... kode SAMA (cek guest, kirim token jika login)... */ if (!feedbackDiv) return; console.log("submitQuiz called. isGuestMode:", isGuestMode); if (isGuestMode) { console.log("Submit as GUEST"); if (!currentQuizSessionId) { console.error("No GUEST session ID."); feedbackDiv.textContent = "Error: Sesi tamu tidak valid."; return; } const lastQuestionId = questions[currentQuestionIndex]?.id; const lastAnswer = userAnswers.find(ans => ans.question_id === lastQuestionId); if (!lastAnswer && currentQuestionIndex === questions.length -1) { feedbackDiv.textContent = "Jawab soal terakhir dulu!"; return; } showLoading(); const guestSubmitUrl = `${API_BASE_URL}/quiz/${currentQuizSessionId}/calculate-guest-result`; console.log("Submitting GUEST to:", guestSubmitUrl); try { const response = await fetch(guestSubmitUrl, { method: 'POST', headers: {'Content-Type': 'application/json'}, body: JSON.stringify({ answers: userAnswers }) }); const data = await response.json(); if (!response.ok) { throw new Error(data.detail || `Gagal kalkulasi hasil tamu (${response.status})`); } console.log("Guest result OK:", data); displayResults(data); } catch (error) { console.error("Error calculating guest result:", error); feedbackDiv.textContent = `Gagal menampilkan hasil: ${error.message}`; hideLoading(); } return; } console.log("Submit as LOGGED IN USER"); if (!currentQuizSessionId) { console.error("Tidak ada ID sesi kuis."); feedbackDiv.textContent = "Error: Sesi kuis tidak valid."; hideLoading(); return; } if (!isLoggedIn || !authToken) { feedbackDiv.textContent = "Login diperlukan untuk submit."; hideLoading(); showView('login'); return; } const lastQuestionId = questions[currentQuestionIndex]?.id; const lastAnswer = userAnswers.find(ans => ans.question_id === lastQuestionId); if (!lastAnswer && currentQuestionIndex === questions.length -1) { feedbackDiv.textContent = "Jawab soal terakhir dulu!"; hideLoading(); return; } showLoading(); try { const headers = {'Content-Type': 'application/json', 'Authorization': `Bearer ${authToken}`}; const submitUrl = `${API_BASE_URL}/quiz/${currentQuizSessionId}/submit`; console.log("Submitting LOGGED IN to:", submitUrl); const response = await fetch(submitUrl, { method: 'POST', headers: headers, body: JSON.stringify({ answers: userAnswers }) }); const data = await response.json(); if (response.status === 401) { throw new Error('Sesi tidak valid.'); } if (!response.ok) { throw new Error(data.detail || `Gagal submit (${response.status})`); } console.log("Logged in submit OK, results:", data); displayResults(data); } catch (error) { console.error("Submit Error (Logged In):", error); feedbackDiv.textContent = `Gagal submit: ${error.message}`; if (error.message.includes("Sesi tidak valid")) { handleLogout(); } hideLoading(); } }

// --- MODIFIKASI displayResults: Hapus setTimeout, perbaiki cek & panggil fetchRecs ---
function displayResults(results) {
    console.log("Attempting display results:", results);
    console.log("Calling showView('results')...");
    const viewShown = showView('results'); // Pindah view
    if (!viewShown) {
        console.error("!!! Failed to show the 'results' view! Aborting displayResults.");
        hideLoading();
        return;
    }

    // Ambil referensi elemen HASIL LAGI TEPAT SEBELUM DIGUNAKAN
    const res_finalScoreSpan = document.getElementById('final-score');
    const res_correctCountSpan = document.getElementById('correct-count');
    const res_totalCountSpan = document.getElementById('total-count');
    const res_categoryAnalysisDiv = document.getElementById('category-analysis');
    const res_recommendationsDiv = document.getElementById('recommendations');
    // Kita TIDAK perlu #recommendations-loading lagi di sini

    // --- Log hasil pencarian elemen ---
    console.log("Finding elements INSIDE displayResults:");
    console.log("#final-score:", res_finalScoreSpan);
    console.log("#correct-count:", res_correctCountSpan);
    console.log("#total-count:", res_totalCountSpan);
    console.log("#category-analysis:", res_categoryAnalysisDiv);
    console.log("#recommendations:", res_recommendationsDiv);
    // -----------------------------------


    // Lakukan pengecekan null untuk elemen KRUSIAL sebelum mengisi
    if(!res_finalScoreSpan || !res_correctCountSpan || !res_totalCountSpan || !res_categoryAnalysisDiv || !res_recommendationsDiv) {
        console.error(">>> Missing CRITICAL results UI elements! Check IDs & HTML structure. <<<");
        if (resultsDiv) { // Coba tampilkan error di div utama hasil
             resultsDiv.innerHTML = `<p class="text-red-500 p-4 text-center">Error: Gagal menampilkan elemen halaman hasil.</p>
             <button id="reset-quiz-btn-fallback" class="mt-4 mx-auto block bg-gray-500 hover:bg-gray-700 text-white font-bold py-2 px-4 rounded">Kembali</button>`;
             const fallbackBtn = document.getElementById('reset-quiz-btn-fallback');
             if (fallbackBtn) fallbackBtn.onclick = resetQuiz;
        }
        hideLoading();
        return; // Hentikan fungsi
    }
    console.log("Critical results elements found.");

    // Lanjutkan mengisi UI jika elemen krusial ditemukan
    try {
        console.log("Populating score...");
        res_finalScoreSpan.textContent = results.score_percentage?.toFixed(1) ?? 'N/A';
        res_correctCountSpan.textContent = results.correct_answers_count ?? '?';
        res_totalCountSpan.textContent = results.total_questions ?? '?';

        console.log("Populating category analysis...");
        res_categoryAnalysisDiv.innerHTML = ''; // Kosongkan analisis lama
        if (results.analysis && results.analysis.length > 0) {
            results.analysis.forEach(cat => { /* ... (kode populasi analisis sama) ... */ const div = document.createElement('div'); div.classList.add('p-3', 'border', 'rounded', 'bg-gray-50'); const scoreColor = cat.score_percentage < 60 ? 'text-red-600' : 'text-green-600'; div.innerHTML = `<span class="font-medium text-gray-800">${cat.category_name}:</span> <span class="${scoreColor} font-bold">${cat.score_percentage?.toFixed(1) ?? 'N/A'}%</span> <span class="text-sm text-gray-600"> (${cat.correct_count ?? '?'}/${cat.total_questions ?? '?'} benar)</span>`; res_categoryAnalysisDiv.appendChild(div); });
        } else {
            console.log("No category analysis data.");
            res_categoryAnalysisDiv.innerHTML = '<p class="text-gray-500 italic">Tidak ada data analisis kategori.</p>';
        }
    } catch (uiError) {
         console.error("Error populating results UI:", uiError);
         if(res_categoryAnalysisDiv) res_categoryAnalysisDiv.innerHTML = '<p class="text-red-500 italic">Error menampilkan analisis.</p>';
    }

    // Panggil fetchRecommendations setelah UI dasar diupdate
    console.log("Calling fetchRecommendations...");
    fetchRecommendations(results.analysis); // Fungsi ini akan handle loading/hiding

}
// --- AKHIR MODIFIKASI displayResults ---


// --- Modifikasi fetchRecommendations: Buat elemen loading sendiri ---
async function fetchRecommendations(analysisData) {
    console.log("Fetching recs based on:", analysisData);
    const recommendationsDiv = document.getElementById('recommendations'); // Cari div utama saja
    if (!recommendationsDiv) { console.error("Recommendations DIV not found!"); hideLoading(); return; }

    // Tampilkan pesan loading langsung di div utama
    recommendationsDiv.innerHTML = '<p id="recommendations-loading-temp" class="text-gray-500 italic p-4 text-center">Memuat rekomendasi...</p>';
    showLoading(); // Tampilkan overlay loading juga

    try {
        const headers = {'Content-Type': 'application/json'};
        if (isLoggedIn && authToken) { headers['Authorization'] = `Bearer ${authToken}`; }

        const response = await fetch(`${API_BASE_URL}/recommendations/`, { method: 'POST', headers: headers, body: JSON.stringify(analysisData) });
        const responseText = await response.text(); // Baca teks dulu
        console.log("Raw recs response:", response.status, responseText);

        if (response.status === 401 && isLoggedIn) throw new Error('Sesi tidak valid.');
        if (!response.ok) { let errD = `Gagal memuat rekomendasi (${response.status})`; try { const eData = JSON.parse(responseText); errD = eData.detail || errD; } catch (e) {} throw new Error(errD); }

        const recommendations = JSON.parse(responseText);
        console.log("Parsed recs:", recommendations);

        recommendationsDiv.innerHTML = ''; // Kosongkan lagi sebelum isi rekomendasi asli

        if (recommendations && recommendations.length > 0) {
             console.log(`Displaying ${recommendations.length} recs.`);
            recommendations.forEach(rec => {
                const div = document.createElement('div'); div.classList.add('border-b', 'pb-3', 'mb-3');
                let content = `<h4 class="font-semibold text-blue-700">${rec.title}</h4><p class="text-sm text-gray-700 mt-1">${rec.summary}</p>`;
                if (rec.url) content += `<a href="${rec.url}" target="_blank" rel="noopener noreferrer" class="text-sm text-blue-500 hover:underline">Baca lebih lanjut...</a>`;
                div.innerHTML = content; recommendationsDiv.appendChild(div);
            });
        } else {
            console.log("No recommendations.");
            recommendationsDiv.innerHTML = '<p class="text-gray-500 italic p-4 text-center">Tidak ada rekomendasi spesifik.</p>';
        }
    } catch (error) {
        console.error("Fetch Recs Error:", error);
        recommendationsDiv.innerHTML = `<p class="text-red-500 italic p-4 text-center">Gagal memuat rekomendasi: ${error.message}</p>`; // Tampilkan error
        if (error.message.includes("Sesi tidak valid")) { handleLogout(); }
    } finally {
        console.log("fetchRecommendations finished.");
        hideLoading(); // Sembunyikan overlay loading
    }
}
// --- AKHIR MODIFIKASI fetchRecommendations ---


// --- Fungsi History ---
async function fetchAndDisplayHistory() { /* ... kode SAMA seperti sebelumnya ... */ const historyListDiv = document.getElementById('history-list'); if (!historyListDiv) return; if (!isLoggedIn || !authToken) { alert("Login untuk melihat riwayat."); showView('login'); return; } showLoading(); historyListDiv.innerHTML = '<p class="text-gray-500 p-4 text-center">Memuat riwayat...</p>'; showView('history'); try { const headers = { 'Authorization': `Bearer ${authToken}` }; const response = await fetch(`${API_BASE_URL}/history`, { headers: headers }); if (response.status === 401) { throw new Error('Sesi tidak valid.'); } if (!response.ok) { const errorData = await response.json().catch(() => ({detail: `Gagal memuat riwayat (${response.status})`})); throw new Error(errorData.detail); } const historyData = await response.json(); historyListDiv.innerHTML = ''; if (historyData && historyData.length > 0) { historyData.forEach(attempt => { const div = document.createElement('div'); div.classList.add('p-3', 'border-b'); const date = new Date(attempt.timestamp).toLocaleString('id-ID', { dateStyle: 'medium', timeStyle: 'short' }); const categories = attempt.categories_played ? attempt.categories_played.split(',').map(c=>c.trim()).join(', ') : 'Semua'; const scoreClass = attempt.score < 60 ? 'text-red-600' : 'text-green-600'; div.innerHTML = ` <div class="flex justify-between items-center mb-1"> <span class="text-sm font-medium text-gray-700">${date}</span> <span class="font-bold ${scoreClass}">${attempt.score.toFixed(1)}%</span> </div> <p class="text-xs text-gray-500">(${attempt.correct_answers} / ${attempt.total_questions} benar) - Kategori: ${categories}</p> `; historyListDiv.appendChild(div); }); } else { historyListDiv.innerHTML = '<p class="text-gray-500 p-4 text-center">Belum ada riwayat.</p>'; } } catch (error) { console.error("Fetch History Error:", error); historyListDiv.innerHTML = `<p class="text-red-500 p-4 text-center">Gagal memuat riwayat: ${error.message}</p>`; if (error.message.includes("Sesi tidak valid")) { handleLogout(); } } finally { hideLoading(); } }

// --- Fungsi Reset Kuis ---
function resetQuiz() { /* ... kode SAMA seperti sebelumnya ... */ const el = { sf: document.getElementById('start-feedback'), f: document.getElementById('feedback'), ca: document.getElementById('category-analysis'), rc: document.getElementById('recommendations')}; currentQuizSessionId = null; questions = []; currentQuestionIndex = 0; userAnswers = []; if(el.sf) el.sf.textContent = ''; if(el.f) el.f.textContent = ''; if(el.ca) el.ca.innerHTML = ''; if(el.rc) el.rc.innerHTML = ''; isGuestMode = false; guestInfo = { name: null, status: null, institution: null }; showView('setup'); }

// --- Fungsi Toggle Visibilitas Password ---
function togglePasswordVisibility(inputId, buttonElement) { /* ... kode SAMA ... */ const passwordInput = document.getElementById(inputId); const spanElement = buttonElement?.querySelector('span'); if (!passwordInput || !spanElement) { console.error(`Input (${inputId}) atau tombol/span toggle tidak ditemukan`); return; } const type = passwordInput.getAttribute('type') === 'password' ? 'text' : 'password'; passwordInput.setAttribute('type', type); spanElement.textContent = type === 'password' ? 'Lihat' : 'Sembunyi'; }


// --- Inisialisasi dan Event Listeners ---
document.addEventListener('DOMContentLoaded', () => {
    console.log("DOM fully loaded and parsed");
    // --- ISI Variabel Referensi DOM ---
    setupDiv = document.getElementById('quiz-setup'); quizActiveDiv = document.getElementById('quiz-active'); resultsDiv = document.getElementById('quiz-results'); loadingIndicator = document.getElementById('loading-indicator'); historySection = document.getElementById('history-section'); historyListDiv = document.getElementById('history-list'); authArea = document.getElementById('auth-area'); loggedOutView = document.getElementById('logged-out-view'); loggedInView = document.getElementById('logged-in-view'); userEmailSpan = document.getElementById('user-email'); showLoginBtn = document.getElementById('show-login-btn'); showRegisterBtn = document.getElementById('show-register-btn'); logoutBtn = document.getElementById('logout-btn'); showHistoryBtn = document.getElementById('show-history-btn'); closeHistoryBtn = document.getElementById('close-history-btn'); loginFormSection = document.getElementById('login-form-section'); registerFormSection = document.getElementById('register-form-section'); loginForm = document.getElementById('login-form'); registerForm = document.getElementById('register-form'); loginEmailInput = document.getElementById('login-email'); loginPasswordInput = document.getElementById('login-password'); loginErrorDiv = document.getElementById('login-error'); registerEmailInput = document.getElementById('register-email'); registerPasswordInput = document.getElementById('register-password'); registerErrorDiv = document.getElementById('register-error'); cancelLoginBtn = document.getElementById('cancel-login-btn'); cancelRegisterBtn = document.getElementById('cancel-register-btn'); categorySelectorDiv = document.getElementById('category-selector'); categoryLoadingP = document.getElementById('category-loading'); selectAllButton = document.getElementById('select-all-btn'); deselectAllButton = document.getElementById('deselect-all-btn'); startFeedbackDiv = document.getElementById('start-feedback'); startButton = document.getElementById('start-quiz-btn'); questionCategorySpan = document.getElementById('question-category'); questionTextP = document.getElementById('question-text'); optionsContainer = document.getElementById('options-container'); questionCounterSpan = document.getElementById('question-counter'); feedbackDiv = document.getElementById('feedback'); nextButton = document.getElementById('next-question-btn'); /* finalScoreSpan = document.getElementById('final-score'); correctCountSpan = document.getElementById('correct-count'); totalCountSpan = document.getElementById('total-count'); categoryAnalysisDiv = document.getElementById('category-analysis'); recommendationsDiv = document.getElementById('recommendations'); recommendationsLoadingP = document.getElementById('recommendations-loading'); */ resetButton = document.getElementById('reset-quiz-btn'); guestPromptModal = document.getElementById('guest-prompt-modal'); guestInfoModal = document.getElementById('guest-info-modal'); promptLoginBtn = document.getElementById('prompt-login-btn'); promptRegisterBtn = document.getElementById('prompt-register-btn'); promptGuestBtn = document.getElementById('prompt-guest-btn'); promptCancelBtn = document.getElementById('prompt-cancel-btn'); guestInfoForm = document.getElementById('guest-info-form'); guestNameInput = document.getElementById('guest-name'); guestStatusSelect = document.getElementById('guest-status'); guestSchoolInputDiv = document.getElementById('guest-school-input'); guestSchoolInput = document.getElementById('guest-school'); guestUniversityInputDiv = document.getElementById('guest-university-input'); guestUniversityInput = document.getElementById('guest-university'); guestInfoErrorDiv = document.getElementById('guest-info-error'); cancelGuestInfoBtn = document.getElementById('cancel-guest-info-btn'); toggleLoginPasswordBtn = document.getElementById('toggle-login-password'); toggleRegisterPasswordBtn = document.getElementById('toggle-register-password');
    console.log("DOM references acquired.");

    // --- Pasang Event Listeners ---
    console.log("Attaching event listeners...");
    // (Kode event listener sama seperti sebelumnya)
    showLoginBtn?.addEventListener('click', () => { showView('login'); if(loginErrorDiv) loginErrorDiv.textContent = ''; }); showRegisterBtn?.addEventListener('click', () => { showView('register'); if(registerErrorDiv) registerErrorDiv.textContent = ''; }); cancelLoginBtn?.addEventListener('click', () => { showView('setup'); loginForm?.reset(); if(loginErrorDiv) loginErrorDiv.textContent = ''; }); cancelRegisterBtn?.addEventListener('click', () => { showView('setup'); registerForm?.reset(); if(registerErrorDiv) registerErrorDiv.textContent = ''; }); loginForm?.addEventListener('submit', handleLogin); registerForm?.addEventListener('submit', handleRegister); logoutBtn?.addEventListener('click', handleLogout); showHistoryBtn?.addEventListener('click', fetchAndDisplayHistory); closeHistoryBtn?.addEventListener('click', () => { showView('setup'); }); promptLoginBtn?.addEventListener('click', () => showView('login')); promptRegisterBtn?.addEventListener('click', () => showView('register')); promptGuestBtn?.addEventListener('click', () => showView('guestInfo')); promptCancelBtn?.addEventListener('click', () => showView('setup')); guestStatusSelect?.addEventListener('change', (event) => { const status = event.target.value; if(guestSchoolInputDiv) guestSchoolInputDiv.classList.add('hidden'); if(guestUniversityInputDiv) guestUniversityInputDiv.classList.add('hidden'); if(guestSchoolInput) guestSchoolInput.required = false; if(guestUniversityInput) guestUniversityInput.required = false; if (status === 'Siswa') { if(guestSchoolInputDiv) guestSchoolInputDiv.classList.remove('hidden'); if(guestSchoolInput) guestSchoolInput.required = true; } else if (status === 'Mahasiswa') { if(guestUniversityInputDiv) guestUniversityInputDiv.classList.remove('hidden'); if(guestUniversityInput) guestUniversityInput.required = true; } }); guestInfoForm?.addEventListener('submit', (event) => { event.preventDefault(); if(guestInfoErrorDiv) guestInfoErrorDiv.textContent = ''; const name = guestNameInput?.value.trim(); const status = guestStatusSelect?.value; let institution = null; if (!name || !status) { if(guestInfoErrorDiv) guestInfoErrorDiv.textContent = 'Nama & Status wajib.'; return; } if (status === 'Siswa') { institution = guestSchoolInput?.value.trim(); if (!institution) { if(guestInfoErrorDiv) guestInfoErrorDiv.textContent = 'Nama Sekolah wajib.'; return; } } else if (status === 'Mahasiswa') { institution = guestUniversityInput?.value.trim(); if (!institution) { if(guestInfoErrorDiv) guestInfoErrorDiv.textContent = 'Nama Universitas wajib.'; return; } } guestInfo = { name, status, institution }; console.log("Melanjutkan sebagai tamu:", guestInfo); isGuestMode = true; guestInfoModal?.classList.add('hidden'); guestInfoModal?.classList.remove('flex'); fetchGuestQuizQuestions(); }); cancelGuestInfoBtn?.addEventListener('click', () => { showView('guestPrompt'); guestInfoForm?.reset(); if(guestInfoErrorDiv) guestInfoErrorDiv.textContent = ''; if(guestSchoolInputDiv) guestSchoolInputDiv.classList.add('hidden'); if(guestUniversityInputDiv) guestUniversityInputDiv.classList.add('hidden'); }); selectAllButton?.addEventListener('click', () => { categorySelectorDiv?.querySelectorAll('input[type="checkbox"]').forEach(cb => { cb.checked = true; }); }); deselectAllButton?.addEventListener('click', () => { categorySelectorDiv?.querySelectorAll('input[type="checkbox"]').forEach(cb => { cb.checked = false; }); }); startButton?.addEventListener('click', () => { if(startFeedbackDiv) startFeedbackDiv.textContent = ''; if (isLoggedIn) { fetchQuizQuestions(); } else { showView('guestPrompt'); } }); nextButton?.addEventListener('click', () => { const quizActiveDiv = document.getElementById('quiz-active'); if (!quizActiveDiv || quizActiveDiv.classList.contains('hidden')) return; const feedbackDiv = document.getElementById('feedback'); if (currentQuestionIndex >= questions.length - 1) { const lastQuestionId = questions[currentQuestionIndex]?.id; const lastAnswer = userAnswers.find(ans => ans.question_id === lastQuestionId); if (!lastAnswer) { if(feedbackDiv) feedbackDiv.textContent = "Jawab soal terakhir dulu!"; return; } submitQuiz(); } else { nextQuestion(); } }); resetButton?.addEventListener('click', resetQuiz); toggleLoginPasswordBtn?.addEventListener('click', () => { togglePasswordVisibility('login-password', toggleLoginPasswordBtn); }); toggleRegisterPasswordBtn?.addEventListener('click', () => { togglePasswordVisibility('register-password', toggleRegisterPasswordBtn); });
    console.log("Event listeners attached.");

    // --- Panggil Fungsi Inisialisasi ---
    const loadingIndicatorCheck = document.getElementById('loading-indicator');
    if (loadingIndicatorCheck) { fetchUserInfo(); showView('setup'); fetchAndDisplayCategories(); } else { console.error("Elemen UI utama (#loading-indicator) tidak ditemukan!"); alert("Terjadi kesalahan saat memuat aplikasi."); }
});

// --- Fungsi Toggle Visibilitas Password ---
function togglePasswordVisibility(inputId, buttonElement) { /* ... kode SAMA ... */ const passwordInput = document.getElementById(inputId); const spanElement = buttonElement?.querySelector('span'); if (!passwordInput || !spanElement) { console.error(`Input (${inputId}) atau tombol/span toggle tidak ditemukan`); return; } const type = passwordInput.getAttribute('type') === 'password' ? 'text' : 'password'; passwordInput.setAttribute('type', type); spanElement.textContent = type === 'password' ? 'Lihat' : 'Sembunyi'; }