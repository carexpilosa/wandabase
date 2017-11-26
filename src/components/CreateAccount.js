import React from 'react';
export default class CreateAccount extends React.Component {
  constructor(props) {
    super(props);
  }

  render() {
    return (
      <div>
        Neuer Account
          <label htmlFor="username">Username: </label>
          <input name="username" id="username" type="text" />
          <br />
          <label htmlFor="password">Password: </label>
          <input name="password" id="password" type="password" />
          <br />
          <label htmlFor="gender">Gender: </label>
          <select name="gender" id="gender" type="select">
            <option>m</option>
            <option>f</option>
          </select>
          <br />
          <label htmlFor="isadmin">Is Admin</label>
          <input type="checkbox" name="is_admin" id="is_admin" />
          <br />
          <label htmlFor="motto">Motto</label>
          <textarea name="motto" id="motto" rows="4" cols="50"></textarea>
          <br />
          <button onClick={(e) => { this._do(e) } }>CLICK</button>
      </div>
    );
  }

  _do (e) {
    console.log(e.target);
    let url = 'http://localhost/wanda/dbconn.pl';
    fetch(url, {
      method: 'post',
      body: JSON.stringify({
        "username": document.getElementById('username').value,
        "password": document.getElementById('password').value,
        "gender": document.getElementById('gender').value,
        "is_admin": document.getElementById('is_admin').value,
        "motto": document.getElementById('motto').value
      })
    }) // Call the fetch function passing the url of the API as a parameter
    .then(function(response) {
      console.log(response);
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
