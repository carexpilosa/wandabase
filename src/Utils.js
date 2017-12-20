

export const fetchUrl = (url, fetchParams, stateResponseKey, outerThis) => {
  fetch(url, fetchParams)
    .then(function(response) {
      return response.json();
    })
    .then(function(json) {
      let newState = {};
      newState[stateResponseKey] = json;
      outerThis.setState(newState);
    })
    .catch(function(error) {
      console.log('ERROR => ' + error);
      return `{error = "${error}"}`;
    });
};