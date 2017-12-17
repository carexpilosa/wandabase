

export function tokenReducer(state = null, action) {
  switch (action.type) {
  case 'GET_TOKEN':
    return '12345';
  case 'DELETE_TOKEN':
    return 'deleted';
  case 'SET_TOKEN':
    return 'set';
  default: return state;
  }
}

