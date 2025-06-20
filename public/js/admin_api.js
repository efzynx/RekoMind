// File: public/js/admin_api.js
// Berisi fungsi-fungsi terkait API khusus admin

import { API_BASE_URL } from './config.js';
// import * as state from './state.js';
import { state } from './state.js';

export async function downloadHistoryAPI() {
    if (!state.isLoggedIn || !state.authToken) {
        throw new Error("Otentikasi admin diperlukan.");
    }
    if (!state.isSuperuser) {
        throw new Error("Hanya admin yang dapat melakukan aksi ini.");
    }

    console.log("API Admin: Mencoba mengunduh file riwayat...");
    try {
        const response = await fetch(`${API_BASE_URL}/admin/download-history`, {
            headers: {
                'Authorization': `Bearer ${state.authToken}`
            }
        });

        if (response.status === 401 || response.status === 403) {
            throw new Error("Akses ditolak. Anda bukan superuser atau sesi tidak valid.");
        }
        if (!response.ok) {
            throw new Error(`Gagal mengunduh file dari server (HTTP ${response.status})`);
        }

        const disposition = response.headers.get('content-disposition');
        let filename = 'rekomind_answer_history.csv';
        if (disposition && disposition.indexOf('attachment') !== -1) {
            const filenameRegex = /filename[^;=\n]*=((['"]).*?\2|[^;\n]*)/;
            const matches = filenameRegex.exec(disposition);
            if (matches != null && matches[1]) { 
                filename = matches[1].replace(/['"]/g, '');
            }
        }

        const blob = await response.blob();
        const url = window.URL.createObjectURL(blob);
        const a = document.createElement('a');
        a.style.display = 'none';
        a.href = url;
        a.download = filename;
        document.body.appendChild(a);
        a.click();
        window.URL.revokeObjectURL(url);
        document.body.removeChild(a);
        
        return { success: true, message: `Download '${filename}' berhasil dimulai.` };

    } catch (error) {
        console.error('API Admin: Error saat mengunduh file:', error);
        throw error; // Lemparkan error agar bisa ditangani oleh pemanggil
    }
}
