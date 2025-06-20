import { elements } from './dom_elements.js';
import { state } from './state.js';

export function showLoading() {
    if (elements.loadingIndicator) {
        elements.loadingIndicator.classList.remove('hidden');
        elements.loadingIndicator.classList.add('flex');
    }
}

export function hideLoading() {
    if (elements.loadingIndicator) {
        elements.loadingIndicator.classList.add('hidden');
        elements.loadingIndicator.classList.remove('flex');
    }
}

export function showView(viewToShow) {
    console.log(`Attempting to show view: ${viewToShow}`);
    const allViewElements = [
        elements.setupDiv, elements.quizActiveDiv, elements.resultsDiv,
        elements.loginFormSection, elements.registerFormSection,
        elements.historySection, elements.guestPromptModal, elements.guestInfoModal
    ];
    const modalViewNames = ['guestPrompt', 'guestInfo'];

    allViewElements.forEach(view => {
        if (view) {
            view.classList.add('hidden');
            view.classList.remove('flex'); // Khusus untuk modal
        }
    });

    let viewElementToShow = null;
    switch (viewToShow) {
        case 'setup':       viewElementToShow = elements.setupDiv; break;
        case 'quiz':        viewElementToShow = elements.quizActiveDiv; break;
        case 'results':     viewElementToShow = elements.resultsDiv; break;
        case 'login':       viewElementToShow = elements.loginFormSection; break;
        case 'register':    viewElementToShow = elements.registerFormSection; break;
        case 'history':     viewElementToShow = elements.historySection; break;
        case 'guestPrompt': viewElementToShow = elements.guestPromptModal; break;
        case 'guestInfo':   viewElementToShow = elements.guestInfoModal; break;
        default:
            console.warn(`showView: Unknown view '${viewToShow}'. Defaulting to 'setup'.`);
            viewElementToShow = elements.setupDiv;
    }

    if (viewElementToShow) {
        viewElementToShow.classList.remove('hidden');
        if (modalViewNames.includes(viewToShow)) {
            viewElementToShow.classList.add('flex');
        }
        console.log(`Successfully displayed view: ${viewToShow}`);
        return true;
    } else {
        console.error(`!!! Element for view '${viewToShow}' is null or not found in showView! Check DOMContentLoaded or HTML IDs.`);
        if (elements.setupDiv) elements.setupDiv.classList.remove('hidden');
        return false;
    }
}

// function auto capitalize name on header
export function capitalizeFirstLetter(string) {
    return string.charAt(0).toUpperCase() + string.slice(1);
}

const displayName = (name) => {
    if (!name) return 'Pengguna';
    const nameParts = name.split(' ');
    if (nameParts.length > 1) {
        return nameParts.map(part => capitalizeFirstLetter(part)).join(' ');
    }
    return capitalizeFirstLetter(name);
}

export function updateAuthUI() {
    if (!elements.loggedOutView || !elements.loggedInView  || !elements.userGreetingSpan /*|| !elements.userEmailSpan*/ || !elements.showHistoryBtn) {
        console.warn("Auth UI elements not fully initialized for updateAuthUI.");
        return;
    }
    if (state.isLoggedIn) {
        elements.loggedOutView.classList.add('hidden');
        elements.loggedInView.classList.remove('hidden');
        // untuk menampilkan user email di header
        // elements.userEmailSpan.textContent = state.currentUserEmail || 'Pengguna';
        // elements.userEmailSpan.title = state.currentUserEmail || 'Pengguna';
        // elements.userGreetingSpan.textContent = user.displayName || 'Pengguna';
        elements.userGreetingSpan.textContent = `Hi, ${displayName(state.currentUserName)}`;
        elements.userGreetingSpan.title = `Hi, ${displayName(state.currentUserName)}`;
        elements.showHistoryBtn.classList.remove('hidden');
        if (state.isSuperuser) {
            elements.downloadHistoryBtn.classList.remove('hidden');
            console.log("UI: Menampilkan tombol admin.");
        } else {
            elements.downloadHistoryBtn.classList.add('hidden');
        }
    } else {
        elements.loggedOutView.classList.remove('hidden');
        elements.loggedInView.classList.add('hidden');
        // elements.userEmailSpan.textContent = '';
        // elements.userEmailSpan.title = '';
        elements.userGreetingSpan.textContent = '';
        elements.userGreetingSpan.title = '';
        if(elements.historySection) elements.historySection.classList.add('hidden');
        elements.showHistoryBtn.classList.add('hidden');
        elements.downloadHistoryBtn.classList.add('hidden');
    }
    
    if(state.isLoggedIn){
        if(elements.loginFormSection && !elements.loginFormSection.classList.contains('hidden')) showView('setup');
        if(elements.registerFormSection && !elements.registerFormSection.classList.contains('hidden')) showView('setup');
    }
}

export function togglePasswordVisibility(inputId, buttonElement) {
    const passwordInput = document.getElementById(inputId);
    const spanElement = buttonElement?.querySelector('span');
    if (!passwordInput || !spanElement) {
        console.error(`Input (${inputId}) atau tombol/span toggle tidak ditemukan`);
        return;
    }
    const type = passwordInput.getAttribute('type') === 'password' ? 'text' : 'password';
    passwordInput.setAttribute('type', type);
    spanElement.textContent = type === 'password' ? 'Lihat' : 'Sembunyi';
}

export function displayDeepAnalysisUI(analysisData) {
    if (!elements.deepAnalysisResults) return;
    elements.deepAnalysisResults.classList.remove('hidden');
    elements.deepAnalysisResults.innerHTML = ''; // Kosongkan dulu

    let content = `<h4 class="text-lg font-semibold text-indigo-800 mb-2">Hasil Analisis Mendalam</h4>`;
    content += `<p class="text-gray-700 italic mb-4">${analysisData.summary_text}</p>`;

    if (analysisData.weakest_concepts && analysisData.weakest_concepts.length > 0) {
        console.warn('displayDeepAnalysisUI: data kosong atau tidak valid:', analysisData);
        content += `<p class="font-semibold text-gray-800 mb-1">Topik Kelemahan:</p>`;
        content += `<ul class="list-disc list-inside space-y-1">`;
        analysisData.weakest_concepts.forEach(concept => {
            content += `<li class="text-sm text-red-700">${concept.topic} (Tingkat Kesalahan: ${concept.error_rate}%)</li>`;
            console.warn("Data analisis tidak valid:", analysisData);
        });
        content += `</ul>`;
    }

    elements.deepAnalysisResults.innerHTML = content;
}