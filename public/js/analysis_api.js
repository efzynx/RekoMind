import { API_BASE_URL } from './config.js';
import { state } from './state.js';
import { displayDeepAnalysisUI } from './ui_handlers.js';

export async function fetchDeepAnalysisAPI() {
    if (!state.isLoggedIn || !state.authToken)
        throw new Error("Otentikasi diperlukan.");

    const headers = {
        'Authorization': `Bearer ${state.authToken}`
    };

    const res = await fetch(`${API_BASE_URL}/analysis/me`, { headers });
    if (!res.ok) throw new Error("Gagal mengambil analisis.");
    return await res.json();
}

export async function fetchAndDisplayDeepAnalysis() {
    try {
        const data = await fetchDeepAnalysisAPI();
        console.log('Hasil analisis:', data);
        displayDeepAnalysisUI(data);
    } catch (error) {
        console.error('Error saat memuat deep analysis:', error);
        const resultsDiv = document.getElementById('deep-analysis-results');
        if (resultsDiv) {
            resultsDiv.innerHTML = `<p class="text-red-500 italic">Gagal memuat analisis: ${error.message}</p>`;
        }
    }
}
