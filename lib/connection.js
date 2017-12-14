

export function getCookie(name) {
  console.log('COOKIE => ' + document.cookie);
  let cookie = document.cookie,
    cookieEntries = cookie.split(/;/),
    cookieObj = {};
  cookieEntries.map(entry => {
    let [key, value] = entry.split(/=/);
    key = key.replace(/^\s+|\s+$/g,'');
    cookieObj[key] = value;
  });
  console.log('COOKIE => ' + document.cookie);
  return cookieObj[name];
};

