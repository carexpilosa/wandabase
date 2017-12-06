/* global require */

import React from 'react';

const config = require ('../../wanderbase.config');
export default class CreateMember extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      jsonResponse: {}
    };
  }

  render() {
    return (
      <div>
        <h3>Login</h3>
        <label htmlFor="username">Username: </label>
        <input name="username" id="username" type="text" />
        <br />
        <label htmlFor="password">Password: </label>
        <input name="password" id="password" type="password" />
        <br />
        <button onClick={(e) => { this._do(e); } }>CLICK</button>
        <br />
        { this.state.jsonResponse
            && JSON.stringify(this.state.jsonResponse) !== '{}'
          ? JSON.stringify(this.state.jsonResponse)
          : null }
      </div>
    );
  }

  _do (e) {
    let data = {};
    for(let i=0; i < e.target.parentElement.children.length; i++) {
      let child = e.target.parentElement.children[i];
      if(child.id === 'username') {
        data['username'] = child.value;
      } else if(child.id === 'password') {
        data['password'] = child.value;
      }
    }
    let that = this;
    let url = `${config.dbconnPath}/dbconn.pl/auth`;
    fetch(url, {
      method: 'post',
      body: JSON.stringify(data)
    }) // Call the fetch function passing the url of the API as a parameter
      .then(function(response) {
        return response.json();
      })
      .then(function(json) {
        that.setState({jsonResponse: json});
      })
      .catch(function(error) {
        // This is where you run code if the server returns any errors
        console.log('ERROR: ' + error);
      });
  }
}
