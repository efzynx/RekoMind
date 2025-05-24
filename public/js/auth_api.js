import { API_BASE_URL } from './config.js';
import { state, updateState } from './state.js';
import * as ui from './ui_handlers.js';
import * as quiz from './quiz_api.js';
import { elements } from './dom_elements.js';

export async function handleRegister(event) {
    event.preventDefault();
    const formElements = {
        form: elements.registerForm, 
        name: elements.registerNameInput, 
        email: elements.registerEmailInput, 
        pass: elements.registerPasswordInput,
        edu: elements.registerEducationLevelSelect, 
        inst: elements.registerInstitutionInput, 
        fav: elements.registerFavSubjectsInput, 
        err: elements.registerErrorDiv
    };
    
    if(Object.values(formElements).some(el => el === null || typeof el === 'undefined')) {
        console.error("Form registrasi (atau salah satu elemennya) belum terinisialisasi dengan benar!");
        if(formElements.err) formElements.err.textContent = "Kesalahan internal: elemen form tidak ada.";
        return;
    }
    formElements.err.textContent = '';

    const nameVal = formElements.name.value.trim();
    const emailVal = formElements.email.value.trim();
    const passwordVal = formElements.pass.value;
    const educationLevelVal = formElements.edu.value;
    const institutionNameVal = formElements.inst.value.trim();
    const favoriteSubjectsVal = formElements.fav.value.trim();

    if (!nameVal || !emailVal || !passwordVal || !educationLevelVal) { 
        formElements.err.textContent = 'Nama, Email, Password, dan Jenjang Pendidikan wajib diisi.'; 
        return; 
    }
    if (passwordVal.length < 8) { 
        formElements.err.textContent = 'Password minimal 8 karakter.'; 
        return; 
    }
    if ((educationLevelVal === 'Siswa' || educationLevelVal === 'Mahasiswa') && !institutionNameVal) { 
        formElements.err.textContent = `Nama ${educationLevelVal === 'Siswa' ? 'Sekolah' : 'Universitas'} wajib diisi.`; 
        return; 
    }

    ui.showLoading();
    try {
        const payload = {
            email: emailVal, 
            password: passwordVal, 
            name: nameVal, 
            education_level: educationLevelVal,
            institution_name: (educationLevelVal === 'Siswa' || educationLevelVal === 'Mahasiswa') ? institutionNameVal : null,
            favorite_subjects: favoriteSubjectsVal || null
        };
        
        console.log("Mengirim payload registrasi:", payload);
        const response = await fetch(`${API_BASE_URL}/auth/register`, { 
            method: 'POST', 
            headers: { 'Content-Type': 'application/json' }, 
            body: JSON.stringify(payload) 
        });
        
        const data = await response.json();
        if (!response.ok) {
            let errMsg = `Registrasi gagal (Status: ${response.status})`;
            if (data && data.detail) {
                if (typeof data.detail === 'string') { 
                    errMsg = data.detail;
                } else if (Array.isArray(data.detail) && data.detail[0]?.msg) { 
                    errMsg = data.detail.map(d => `${d.loc.slice(-1)[0]}: ${d.msg}`).join('; ');
                } else if (typeof data.detail === 'object' && Object.values(data.detail)[0]?.reason) { 
                    errMsg = Object.values(data.detail)[0].reason; 
                }
            }
            throw new Error(errMsg);
        }
        
        console.log('Registrasi berhasil:', data); 
        alert('Registrasi berhasil! Silakan login.'); 
        ui.showView('login');
        if(formElements.form) formElements.form.reset(); 
        if(elements.registerInstitutionInputDiv) elements.registerInstitutionInputDiv.classList.add('hidden');
    } catch (error) { 
        console.error("Kesalahan Registrasi:", error); 
        if(formElements.err) formElements.err.textContent = error.message;
    } finally { 
        ui.hideLoading(); 
    }
}

export async function handleLogin(event) {
    event.preventDefault();
    if(!elements.loginForm || !elements.loginEmailInput || !elements.loginPasswordInput || !elements.loginErrorDiv) return;
    
    elements.loginErrorDiv.textContent = ''; 
    ui.showLoading();
    
    try {
        const formData = new FormData();
        formData.append('username', elements.loginEmailInput.value);
        formData.append('password', elements.loginPasswordInput.value);
        
        const response = await fetch(`${API_BASE_URL}/auth/login`, { 
            method: 'POST', 
            body: formData 
        });
        
        const data = await response.json();
        if (!response.ok) throw new Error(data.detail || `Login gagal (HTTP ${response.status})`);
        
        updateState({
            authToken: data.access_token,
            isLoggedIn: true,
            currentUserEmail: elements.loginEmailInput.value
        });
        
        await fetchUserInfo(); // Verifikasi token & dapatkan info user lengkap
        ui.showView('setup'); 
        if(elements.loginForm) elements.loginForm.reset();
    } catch (error) {
        console.error("Login Err:", error); 
        elements.loginErrorDiv.textContent = error.message;
        updateState({
            authToken: null,
            isLoggedIn: false,
            currentUserEmail: null,
            currentUserName: null // user info name
        });
        ui.updateAuthUI();
    } finally { 
        ui.hideLoading(); 
    }
}

export function handleLogout() {
    ui.showLoading(); 
    console.log("Logging out...");
    
    updateState({
        authToken: null,
        isLoggedIn: false,
        currentUserEmail: null,
        currentUserName: null, // user info name
        isGuestMode: false,
        guestInfo: { name: null, status: null, institution: null }
    });
    
    ui.updateAuthUI(); 
    ui.showView('setup'); 
    console.log("Logged out."); 
    ui.hideLoading();
}

export async function fetchUserInfo() {
    const authToken = localStorage.getItem('authToken');
    if (!authToken) { 
        console.log("No auth token found."); 
        updateState({
            isLoggedIn: false,
            currentUserEmail: null,
            currentUserName: null // user info
        });
        ui.updateAuthUI(); 
        return; 
    }
    
    console.log("Fetching user info..."); 
    if (!state.isLoggedIn && elements.loadingIndicator) ui.showLoading();
    
    try {
        const response = await fetch(`${API_BASE_URL}/users/me`, { 
            method: 'GET', 
            headers: { 'Authorization': `Bearer ${authToken}` } 
        });
        
        if (response.status === 401) { 
            throw new Error('Sesi tidak valid atau token kedaluwarsa.'); 
        }
        
        if (!response.ok) { 
            const errorData = await response.json().catch(() => ({
                detail: `Gagal ambil data user (HTTP ${response.status})`
            })); 
            throw new Error(errorData.detail); 
        }
        
        const userData = await response.json();
        updateState({
            currentUserEmail: userData.email,
            currentUserName: userData.name, // user info name
            isLoggedIn: true
        });
        console.log("User info OK:", userData);
    } catch (error) { 
        console.error("Fetch User Info Err:", error.message); 
        handleLogout();
    } finally { 
        ui.updateAuthUI(); 
        if (!state.isLoggedIn || !state.authToken) ui.hideLoading();
    }
}