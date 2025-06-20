export const elements = {
  // Views
  setupDiv: null,
  quizActiveDiv: null,
  resultsDiv: null,
  loadingIndicator: null,
  historySection: null,
  historyListDiv: null,
  
  // Auth elements
  authArea: null,
  loggedOutView: null,
  loggedInView: null,
  userEmailSpan: null,
  userGreetingSpan: null, //pengganti email greeting
  showLoginBtn: null,
  showRegisterBtn: null,
  logoutBtn: null,
  showHistoryBtn: null,
  closeHistoryBtn: null,
  downloadHistoryBtn: null,
  
  // Forms
  loginFormSection: null,
  registerFormSection: null,
  loginForm: null,
  registerForm: null,
  loginEmailInput: null,
  loginPasswordInput: null,
  loginErrorDiv: null,
  registerEmailInput: null,
  registerPasswordInput: null,
  registerErrorDiv: null,
  cancelLoginBtn: null,
  cancelRegisterBtn: null,
  
  // Quiz elements
  categorySelectorDiv: null,
  categoryLoadingP: null,
  selectAllButton: null,
  deselectAllButton: null,
  startFeedbackDiv: null,
  startButton: null,
  questionCategorySpan: null,
  questionTextP: null,
  optionsContainer: null,
  questionCounterSpan: null,
  feedbackDiv: null,
  nextButton: null,
  resetButton: null,
  
  // Guest elements
  guestPromptModal: null,
  guestInfoModal: null,
  promptLoginBtn: null,
  promptRegisterBtn: null,
  promptGuestBtn: null,
  promptCancelBtn: null,
  guestInfoForm: null,
  guestNameInput: null,
  guestStatusSelect: null,
  guestSchoolInputDiv: null,
  guestSchoolInput: null,
  guestUniversityInputDiv: null,
  guestUniversityInput: null,
  guestInfoErrorDiv: null,
  cancelGuestInfoBtn: null,
  
  // Register form additional elements
  registerNameInput: null,
  registerEducationLevelSelect: null,
  registerInstitutionInputDiv: null,
  registerInstitutionLabel: null,
  registerInstitutionInput: null,
  registerFavSubjectsInput: null,
  
  // Password toggle buttons
  toggleLoginPasswordBtn: null,
  toggleRegisterPasswordBtn: null,

  // analysis
  runDeepAnalysisBtn: null,
  deepAnalysisLoading: null,
  deepAnalysisResults: null
};


export function initializeDomElements() {
  // Views
  elements.setupDiv = document.getElementById('quiz-setup');
  elements.quizActiveDiv = document.getElementById('quiz-active');
  elements.resultsDiv = document.getElementById('quiz-results');
  elements.loadingIndicator = document.getElementById('loading-indicator');
  elements.historySection = document.getElementById('history-section');
  elements.historyListDiv = document.getElementById('history-list');
  
  // Auth elements
  elements.authArea = document.getElementById('auth-area');
  elements.loggedOutView = document.getElementById('logged-out-view');
  elements.loggedInView = document.getElementById('logged-in-view');
  // elements.userEmailSpan = document.getElementById('user-email');
  elements.userGreetingSpan = document.getElementById('user-greeting'); //pengganti email greeting
//   elements.userGreetingSpan.title = 'Pengguna';
  elements.showLoginBtn = document.getElementById('show-login-btn');
  elements.showRegisterBtn = document.getElementById('show-register-btn');
  elements.logoutBtn = document.getElementById('logout-btn');
  elements.showHistoryBtn = document.getElementById('show-history-btn');
  elements.closeHistoryBtn = document.getElementById('close-history-btn');
  elements.downloadHistoryBtn = document.getElementById('download-history-btn');
  
  // Forms
  elements.loginFormSection = document.getElementById('login-form-section');
  elements.registerFormSection = document.getElementById('register-form-section');
  elements.loginForm = document.getElementById('login-form');
  elements.registerForm = document.getElementById('register-form');
  elements.loginEmailInput = document.getElementById('login-email');
  elements.loginPasswordInput = document.getElementById('login-password');
  elements.loginErrorDiv = document.getElementById('login-error');
  elements.registerEmailInput = document.getElementById('register-email');
  elements.registerPasswordInput = document.getElementById('register-password');
  elements.registerErrorDiv = document.getElementById('register-error');
  elements.cancelLoginBtn = document.getElementById('cancel-login-btn');
  elements.cancelRegisterBtn = document.getElementById('cancel-register-btn');
  
  // Quiz elements
  elements.categorySelectorDiv = document.getElementById('category-selector');
  elements.categoryLoadingP = document.getElementById('category-loading');
  elements.selectAllButton = document.getElementById('select-all-btn');
  elements.deselectAllButton = document.getElementById('deselect-all-btn');
  elements.startFeedbackDiv = document.getElementById('start-feedback');
  elements.startButton = document.getElementById('start-quiz-btn');
  elements.questionCategorySpan = document.getElementById('question-category');
  elements.questionTextP = document.getElementById('question-text');
  elements.optionsContainer = document.getElementById('options-container');
  elements.questionCounterSpan = document.getElementById('question-counter');
  elements.feedbackDiv = document.getElementById('feedback');
  elements.nextButton = document.getElementById('next-question-btn');
  elements.resetButton = document.getElementById('reset-quiz-btn');
  
  // Guest elements
  elements.guestPromptModal = document.getElementById('guest-prompt-modal');
  elements.guestInfoModal = document.getElementById('guest-info-modal');
  elements.promptLoginBtn = document.getElementById('prompt-login-btn');
  elements.promptRegisterBtn = document.getElementById('prompt-register-btn');
  elements.promptGuestBtn = document.getElementById('prompt-guest-btn');
  elements.promptCancelBtn = document.getElementById('prompt-cancel-btn');
  elements.guestInfoForm = document.getElementById('guest-info-form');
  elements.guestNameInput = document.getElementById('guest-name');
  elements.guestStatusSelect = document.getElementById('guest-status');
  elements.guestSchoolInputDiv = document.getElementById('guest-school-input');
  elements.guestSchoolInput = document.getElementById('guest-school');
  elements.guestUniversityInputDiv = document.getElementById('guest-university-input');
  elements.guestUniversityInput = document.getElementById('guest-university');
  elements.guestInfoErrorDiv = document.getElementById('guest-info-error');
  elements.cancelGuestInfoBtn = document.getElementById('cancel-guest-info-btn');
  
  // Register form additional elements
  elements.registerNameInput = document.getElementById('register-name');
  elements.registerEducationLevelSelect = document.getElementById('register-education-level');
  elements.registerInstitutionInputDiv = document.getElementById('register-institution-input-div');
  elements.registerInstitutionLabel = document.getElementById('register-institution-label');
  elements.registerInstitutionInput = document.getElementById('register-institution');
  elements.registerFavSubjectsInput = document.getElementById('register-fav-subjects');
  
  // Password toggle buttons
  elements.toggleLoginPasswordBtn = document.getElementById('toggle-login-password');
  elements.toggleRegisterPasswordBtn = document.getElementById('toggle-register-password');

  // analysis elements
  elements.runDeepAnalysisBtn = document.getElementById('run-deep-analysis-btn');
  elements.deepAnalysisLoading = document.getElementById('deep-analysis-loading');
  elements.deepAnalysisResults = document.getElementById('deep-analysis-results')
}

console.log('loggedOutView:', elements.loggedOutView);
console.log('loggedInView:', elements.loggedInView);
console.log('userGreetingSpan:', elements.userGreetingSpan);