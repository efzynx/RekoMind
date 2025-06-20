// public/js/state.js

export const state = {
  currentQuizSessionId: null,
  questions: [],
  currentQuestionIndex: 0,
  userAnswers: [],
  isLoggedIn: false,
  authToken: localStorage.getItem('authToken'),
  currentUserEmail: localStorage.getItem('currentUserEmail'),
  currentUserName: localStorage.getItem('currentUserName'),
  isGuestMode: false,
  guestInfo: {
    name: null,
    status: null,
    institution: null,
  },
  isSuperuser: localStorage.getItem('isSuperuser') === 'true',
  currentUserRole: localStorage.getItem('currentUserRole') || null,
};

// Inisialisasi ulang state dari localStorage (dipanggil saat app dimulai)
export function initializeState() {
  state.authToken = localStorage.getItem('authToken');
  state.isLoggedIn = !!state.authToken;

  state.currentUserEmail = localStorage.getItem('currentUserEmail');
  state.currentUserName = localStorage.getItem('currentUserName');
  state.isSuperuser = localStorage.getItem('isSuperuser') === 'true';
  state.currentUserRole = localStorage.getItem('currentUserRole');
}

// Update dan sinkronisasi state & localStorage
export function updateState(newState) {
  Object.assign(state, newState);

  if (newState.authToken !== undefined) {
    if (newState.authToken) {
      localStorage.setItem('authToken', newState.authToken);
    } else {
      localStorage.removeItem('authToken');
    }
  }

  if (newState.isSuperuser !== undefined) {
    if (newState.isSuperuser) {
      localStorage.setItem('isSuperuser', 'true');
    } else {
      localStorage.removeItem('isSuperuser');
    }
  }

  if (newState.currentUserEmail !== undefined) {
    if (newState.currentUserEmail) {
      localStorage.setItem('currentUserEmail', newState.currentUserEmail);
    } else {
      localStorage.removeItem('currentUserEmail');
    }
  }

  if (newState.currentUserName !== undefined) {
    if (newState.currentUserName) {
      localStorage.setItem('currentUserName', newState.currentUserName);
    } else {
      localStorage.removeItem('currentUserName');
    }
  }

  if (newState.currentUserRole !== undefined) {
    if (newState.currentUserRole) {
      localStorage.setItem('currentUserRole', newState.currentUserRole);
    } else {
      localStorage.removeItem('currentUserRole');
    }
  }
}

// Reset semua data saat logout
export function resetUserSession() {
  updateState({
    authToken: null,
    isLoggedIn: false,
    currentUserEmail: null,
    currentUserName: null,
    isSuperuser: false,
    currentUserRole: null,
    isGuestMode: false,
    guestInfo: { name: null, status: null, institution: null },
    currentQuizSessionId: null,
    questions: [],
    currentQuestionIndex: 0,
    userAnswers: [],
  });

  localStorage.removeItem('authToken');
  localStorage.removeItem('isSuperuser');
  localStorage.removeItem('currentUserEmail');
  localStorage.removeItem('currentUserName');
  localStorage.removeItem('currentUserRole');
}
