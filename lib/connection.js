

export function getTokenFromStore(name) {
  let cookie = document.cookie,
    cookieEntries = cookie.split(/;/),
    cookieObj = {};
  cookieEntries.map(entry => {
    let [key, value] = entry.split(/=/);
    key = key.replace(/^\s+|\s+$/g,'');
    cookieObj[key] = value;
  });
  return cookieObj[name];
};

export function deleteTokenInStore() {

}

