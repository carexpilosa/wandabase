import React from 'react';
export default class CreateAccount extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      jsonResponse: {}
    }
  }

  render() {
    console.log(this.state.jsonResponse);
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

          {
            Object.keys(this.state.jsonResponse).map((key, idx) => {
              return <div key={idx}>{key} => {this.state.jsonResponse[key]}</div>;
            })
          }
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
      } else if(child.id === 'gender') {
        data['gender'] = child.value;
      } else if(child.id === 'is_admin') {
        data['is_admin'] = child.checked ? 'on' : '';
      } else if(child.id === 'motto') {
        data['motto'] = child.value;
      }
    }
    let that = this;
    let url = 'http://localhost/wanda/dbconn.pl';
    fetch(url, {
      method: 'post',
      body: JSON.stringify(data)
    }) // Call the fetch function passing the url of the API as a parameter
    .then(function(response) {
      console.log(url);
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
