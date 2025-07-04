// ==============================================================================
// File: public/js/analysis_api.js
// ==============================================================================


import { API_BASE_URL } from './config.js';
import { state } from './state.js';
import { displayHolisticAnalysis, showAnalysisLoading, displayAnalysisError } from './ui_handlers.js';

// Fungsi ini HANYA bertanggung jawab untuk memanggil API
async function fetchHolisticHybridAnalysisAPI() {
    if (!state.isLoggedIn || !state.authToken) {
        throw new Error("Otentikasi diperlukan untuk mendapatkan analisis.");
    }
    
    console.log("Memanggil API Backend untuk analisis hybrid...");

    const response = await fetch(`${API_BASE_URL}/analysis/summary`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
            'Authorization': `Bearer ${state.authToken}`
        },
    });

    if (!response.ok) {
        const errorData = await response.json();
        throw new Error(errorData.detail || 'Gagal mengambil analisis dari server.');
    }

    return await response.json();
}

// Fungsi ini adalah FUNGSI UTAMA yang dipanggil oleh event listener.
// Tugasnya mengelola seluruh alur: loading, panggil API, tampilkan hasil/error.
export async function runAndDisplayHolisticAnalysis() {
    showAnalysisLoading(true);
    try {
        const data = await fetchHolisticHybridAnalysisAPI();
        console.log('Hasil analisis hybrid diterima:', data);
        displayHolisticAnalysis(data); // Panggil UI handler untuk menampilkan hasil
    } catch (error) {
        console.error('Error saat menjalankan analisis holistik:', error);
        displayAnalysisError(error.message); // Panggil UI handler untuk menampilkan error
    } finally {
        showAnalysisLoading(false);
    }
}
