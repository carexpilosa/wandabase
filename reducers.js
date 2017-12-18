import { createStore, combineReducers } from 'redux';

const initialState = {
  token: 'helloToken'
};

const rootReducer = combineReducers({
  token: tokenReducer,
  //initialState,
});

export const store = createStore(
  rootReducer,
  window.__REDUX_DEVTOOLS_EXTENSION__ && window.__REDUX_DEVTOOLS_EXTENSION__()
);

export function tokenReducer(state='', action) {
  switch (action.type) {
  case 'DELETE_TOKEN':
    return '';
  case 'SET_TOKEN':
    return action.token;
  default: return state;
  }
}

