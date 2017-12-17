export function getToken() {
  return {
    type: 'GET_TOKEN'
  }
};

export function deleteToken(token) {
  return {
    type: 'DELETE_TOKEN',
    token
  }
}

export function setToken(token) {
  return {
    type: 'SET_TOKEN',
    token
  }
}

