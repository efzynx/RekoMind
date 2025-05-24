import { API_BASE_URL } from './config.js';
import { state } from './state.js';
import * as ui from './ui_handlers.js';
import { elements } from './dom_elements.js';

export async function fetchAndDisplayHistory() { 
    if (!elements.historyListDiv) return; 
    if (!state.isLoggedIn || !state.authToken) { 
        alert("Login untuk melihat riwayat."); 
        ui.showView('login'); 
        return; 
    } 
    
    ui.showLoading(); 
    elements.historyListDiv.innerHTML = '<p class="text-gray-500 p-4 text-center">Memuat riwayat...</p>'; 
    ui.showView('history'); 
    
    try {
        const headers = { 'Authorization': `Bearer ${state.authToken}` }; 
        const response = await fetch(`${API_BASE_URL}/history`, { headers: headers }); 
        
        if (response.status === 401) { 
            throw new Error('Sesi tidak valid.'); 
        } 
        
        if (!response.ok) { 
            const errorData = await response.json().catch(() => ({
                detail: `Gagal memuat riwayat (${response.status})`
            })); 
            throw new Error(errorData.detail); 
        } 
        
        const historyData = await response.json(); 
        elements.historyListDiv.innerHTML = ''; 
        
        if (historyData && historyData.length > 0) { 
            historyData.forEach(attempt => { 
                const div = document.createElement('div'); 
                div.classList.add('p-3', 'border-b', 'border-gray-200'); 
                const date = new Date(attempt.timestamp).toLocaleString('id-ID', { 
                    dateStyle: 'medium', 
                    timeStyle: 'short' 
                }); 
                const categories = attempt.categories_played ? 
                    attempt.categories_played.split(',').map(c=>c.trim()).join(', ') : 'Semua'; 
                const scoreClass = attempt.score < 60 ? 'text-red-600' : 'text-green-600'; 
                
                div.innerHTML = ` 
                    <div class="flex justify-between items-center mb-1"> 
                        <span class="text-sm font-medium text-gray-700">${date}</span> 
                        <span class="font-bold ${scoreClass}">${attempt.score.toFixed(1)}%</span> 
                    </div> 
                    <p class="text-xs text-gray-500">(${attempt.correct_answers} / ${attempt.total_questions} benar) - Kategori: ${categories}</p> 
                `; 
                elements.historyListDiv.appendChild(div); 
            }); 
        } else { 
            elements.historyListDiv.innerHTML = '<p class="text-gray-500 p-4 text-center">Belum ada riwayat.</p>'; 
        } 
    } catch (error) { 
        console.error("Fetch History Error:", error); 
        elements.historyListDiv.innerHTML = `
            <p class="text-red-500 p-4 text-center">Gagal memuat riwayat: ${error.message}</p>
        `; 
        if (error.message.includes("Sesi tidak valid")) { 
            handleLogout(); 
        } 
    } finally { 
        ui.hideLoading(); 
    } 
}