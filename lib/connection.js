

export function getCookie(name) {
  let cookieEntries = document.cookie.split(/;/),
    cookieObj = {};
  cookieEntries.map(entry => {
    let [key, value] = entry.split(/=/);
    key = key.replace(/^\s+|\s+$/g,'');
    cookieObj[key] = value;
  });
  console.log(cookieObj);
  return cookieObj[name];
};

