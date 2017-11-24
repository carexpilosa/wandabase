import React from 'react';
export default class CreateAccount extends React.Component {
  constructor(props) {
    super(props);
  }

  render() {
    return (
      <div>
        Neuer Account
        { /*<form action="http://localhost/wanda/srvrest.pl" method="post"> */ }
          <label htmlFor="username">Username: </label>
          <input name="username" type="text" />
          <br />
          <label htmlFor="password">Password: </label>
          <input name="password" type="password" />
          <br />
          <label htmlFor="gender">Gender: </label>
          <select name="gender" type="select">
            <option>m</option>
            <option>w</option>
          </select>
          <br />
          <label htmlFor="isadmin">Is Admin</label>
          <input type="checkbox" name="is_admin" />
          <br />
          <label htmlFor="motto">Motto</label>
          <textarea name="motto" rows="4" cols="50"></textarea>
          <br />
          <button onClick={(e) => { this._do(e) } }>CLICK</button>
        { /* </form> */ }
      </div>
    );
  }

  _do (e) {
    console.log(e.target);
    let url = 'http://localhost/wanda/srvrest.pl';
    fetch(url, {
      method: 'post',
      body: JSON.stringify({
        "username": "Fritz",
        "password": "Manfred",
        "gender": "f",
        "is_admin": "on",
        "motto": "Hol raus, was rauszuholen geht"
      })
    }) // Call the fetch function passing the url of the API as a parameter
    .then(function(response) {
      return response.json();
    })
    .then(function(json) {
      console.log(json);
    })
    .catch(function(error) {
      // This is where you run code if the server returns any errors
      console.log('ERROR: ' + error);
    });
  }
}
