export const state = {
  currentQuizSessionId: null,
  questions: [],
  currentQuestionIndex: 0,
  userAnswers: [],
  isLoggedIn: false,
  authToken: localStorage.getItem('authToken'),
  currentUserEmail: null,
  currentUserName: null,
  isGuestMode: false,
  guestInfo: { name: null, status: null, institution: null }
};


export function initializeState() {
  state.authToken = localStorage.getItem('authToken');
  if (state.authToken) {
    state.isLoggedIn = true;
  }
}

export function updateState(newState) {
  Object.assign(state, newState);
  // Update localStorage jika ada perubahan token
  if (newState.authToken !== undefined) {
    if (newState.authToken) {
      localStorage.setItem('authToken', newState.authToken);
    } else {
      localStorage.removeItem('authToken');
    }
  }
}
