import React from 'react';
import {connect} from 'react-redux';
import { config } from '../../wanderbase.config';
import { deleteToken, setToken } from '../../actions';

class Login extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      jsonResponse: {},
    };
  }

  render() {
    return (
      <div>
        <div>
          <h3>Login (Token={this.props.token})</h3>
          <label htmlFor="username">Username: </label>
          <input name="username" id="username" type="text" />
          <br />
          <label htmlFor="password">Password: </label>
          <input name="password" id="password" type="password" />
          <br />
          <button onClick={(e) => { this._login(e); } }>CLICK</button>
          <br />
          { this.state.jsonResponse
              && JSON.stringify(this.state.jsonResponse) !== '{}'
            ? JSON.stringify(this.state.jsonResponse)
            : null }
        </div>
        <div>
          <h3>Logout</h3>
          <button onClick={() => { this._logout(); } }>CLICK</button>
        </div>
      </div>
    );
  }

  _login (e) {
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
      })
        .then(function(response) {
          return response.json();
        })
        .then(function(json) {
          that.setState({jsonResponse: json});
          if(json.Token) {
            that.props.setToken(json.Token);
          }
        })
        .catch(function(error) {
          console.log('ERROR: ' + error);
        });
    }
  }

  _logout () {
    this.props.deleteToken('token');
    let url = `${config.apiPath}/api.pl/logout`;
    fetch(url, {
      method: 'post',
      body: JSON.stringify({token: this.props.token})
    })
      .then(function(response) {
        return response.json();
      })
      .then(function(json) {
        //this.props.deleteToken('token');
        //this.render();
      })
      .catch(function(error) {
        //this.render();
        console.log('ERROR: ' + error);
      });
  }
}

function mapStateToProps(state) {
  return {
    token: state.token
  };
}

function mapDispatchToProps(dispatch) {
  return {
    setToken: (token) => dispatch(setToken(token)),
    deleteToken: () => dispatch(deleteToken())
  };
}

export default connect(mapStateToProps, mapDispatchToProps)(Login);