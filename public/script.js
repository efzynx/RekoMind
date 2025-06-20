import { API_BASE_URL } from './js/config.js';
import { state, initializeState, updateState } from './js/state.js';
import * as elements from './js/dom_elements.js';
import * as ui from './js/ui_handlers.js';
import * as auth from './js/auth_api.js';
import * as quiz from './js/quiz_api.js';
import * as recommendation from './js/recommendation_api.js';
import * as history from './js/history_api.js';
import { setupEventListeners } from './js/event_listeners.js';
import * as admin from './js/admin_api.js';


document.addEventListener('DOMContentLoaded', () => {
  initializeState();
  elements.initializeDomElements();
  setupEventListeners();
  ui.updateAuthUI();
  ui.showView('setup');
  quiz.fetchAndDisplayCategories();
  auth.fetchUserInfo();
});