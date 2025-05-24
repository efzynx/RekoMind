import { API_BASE_URL } from './config.js';
import { state } from './state.js';
import * as ui from './ui_handlers.js';

export async function fetchRecommendations(requestPayload, recommendationsDisplayDiv) {
    console.log("Fetching recommendations based on payload:", requestPayload);
    if (!recommendationsDisplayDiv) { 
        console.error("Recommendations DIV not passed to fetchRecommendations!"); 
        ui.hideLoading(); 
        return; 
    }
    
    recommendationsDisplayDiv.innerHTML = '<p class="text-gray-500 italic p-4 text-center">Memuat rekomendasi...</p>'; 
    ui.showLoading();
    
    try {
        const headers = {'Content-Type': 'application/json'}; 
        if (state.isLoggedIn && state.authToken) { 
            headers['Authorization'] = `Bearer ${state.authToken}`; 
        }
        
        const response = await fetch(`${API_BASE_URL}/recommendations/`, { 
            method: 'POST', 
            headers: headers, 
            body: JSON.stringify(requestPayload) 
        });
        
        const responseText = await response.text(); 
        console.log("Raw recs response:", response.status, responseText);
        
        if (response.status === 401 && state.isLoggedIn) {
            throw new Error('Sesi tidak valid.');
        }
        
        if (!response.ok) { 
            let errD = `Gagal memuat rekomendasi (HTTP ${response.status})`; 
            try { 
                const eData = JSON.parse(responseText); 
                errD = eData.detail || errD; 
                if (Array.isArray(eData.detail) && eData.detail[0]?.msg ) {
                    errD = eData.detail.map(d=>`${d.loc.slice(-1)[0]}: ${d.msg}`).join('; ');
                } else if (typeof eData.detail === 'object' && Object.values(eData.detail)[0]?.reason) {
                    errD = Object.values(eData.detail)[0].reason; 
                }
            } catch (e) {} 
            throw new Error(errD); 
        }
        
        const recommendations = JSON.parse(responseText); 
        console.log("Parsed recs:", recommendations);
        recommendationsDisplayDiv.innerHTML = '';
        
        if (recommendations && recommendations.length > 0) { 
            console.log(`Displaying ${recommendations.length} recs.`); 
            recommendations.forEach(rec => { 
                const div = document.createElement('div'); 
                div.classList.add('border-b', 'pb-3', 'mb-3', 'border-gray-200'); 
                let content = `
                    <h4 class="font-semibold text-blue-700">${rec.title}</h4>
                    <p class="text-sm text-gray-700 mt-1">${rec.summary}</p>
                `; 
                if (rec.url) {
                    content += `
                        <a href="${rec.url}" target="_blank" rel="noopener noreferrer" 
                           class="text-sm text-blue-500 hover:underline">Baca lebih lanjut...</a>
                    `;
                } 
                div.innerHTML = content; 
                recommendationsDisplayDiv.appendChild(div); 
            });
        } else { 
            console.log("No recommendations."); 
            recommendationsDisplayDiv.innerHTML = '<p class="text-gray-500 italic p-4 text-center">Tidak ada rekomendasi spesifik untuk saat ini.</p>'; 
        }
    } catch (error) { 
        console.error("Fetch Recs Error:", error); 
        recommendationsDisplayDiv.innerHTML = `
            <p class="text-red-500 italic p-4 text-center">Gagal memuat rekomendasi: ${error.message}</p>
        `; 
        if (error.message.includes("Sesi tidak valid")) { 
            handleLogout(); 
        }
    } finally { 
        console.log("fetchRecommendations finished."); 
        ui.hideLoading(); 
    }
}