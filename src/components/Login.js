import React from 'react';
import { config } from '../../wanderbase.config';
import { getToken, deleteToken, setToken } from '../../actions';

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
        <div>
          <h3>Login</h3>
          <label htmlFor="username">Username: </label>
          <input name="username" id="username" type="text" />
          <br />
          <label htmlFor="password">Password: </label>
          <input name="password" id="password" type="password" />
          <br />
          <button onClick={(e) => { this.login(e); } }>CLICK</button>
          <br />
          { this.state.jsonResponse
              && JSON.stringify(this.state.jsonResponse) !== '{}'
            ? JSON.stringify(this.state.jsonResponse)
            : null }
        </div>
        <div>
          <h3>Logout</h3>
          <button onClick={() => { this.logout(); } }>CLICK</button>
        </div>
      </div>
    );
  }

  login (e) {
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
    let url = `${config.apiPath}/api.pl/auth`;
    if (data['username'] && data['password']) {
      fetch(url, {
        method: 'post',
        body: JSON.stringify(data)
      }) // Call the fetch function passing the url of the API as a parameter
        .then(function(response) {
          return response.json();
        })
        .then(function(json) {
          that.setState({jsonResponse: json});
          if(json.Token) {
            setToken(json.Token);
          }
        })
        .catch(function(error) {
          // This is where you run code if the server returns any errors
          console.log('ERROR: ' + error);
        });
    }
  }

  logout () {
    let url = `${config.apiPath}/api.pl/logout`;
    fetch(url, {
      method: 'post',
      body: JSON.stringify({token: getToken()})
    }) // Call the fetch function passing the url of the API as a parameter
      .then(function(response) {
        return response.json();
      })
      .then(function(json) {
        console.log('reset the coooooookie');
        deleteToken('token');
      })
      .catch(function(error) {
        // This is where you run code if the server returns any errors
        console.log('ERROR: ' + error);
      });
  }
}
