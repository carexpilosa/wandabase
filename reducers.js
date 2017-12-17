import { createStore, combineReducers } from 'redux';

const initialState = {
  token: 'helloToken'
};

const rootReducer = combineReducers({
  token: tokenReducer,
  //initialState
});

export const store = createStore( rootReducer );

export function tokenReducer(state = null, action) {
  switch (action.type) {
  case 'GET_TOKEN':
    console.log('reducer: get token');
    return '12345';
  case 'DELETE_TOKEN':
    console.log('reducer: delete token');
    return 'deleted';
  case 'SET_TOKEN':
    console.log('reducer: set token to '+state);
    return state;
  default: return state;
  }
}

