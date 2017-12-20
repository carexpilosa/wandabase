import React from 'react';
import {connect} from 'react-redux';
import { setToken, deleteToken } from '../../actions';
import { config } from '../../wanderbase.config';
import { fetchUrl } from '../Utils';

class CreateMember extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      jsonResponse: {}
    };
  }

  render() {
    return (
      <div>
        <h3>Neuen Teilnehmer anlegen</h3>
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
        <button onClick={(e) => { this._do(e); } }>CLICK</button>
        {
          Object.keys(this.state.jsonResponse).map((key, idx) => {
            return <div key={idx}>{key} =&gt; {this.state.jsonResponse[key]}</div>;
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

    let url = `${config.apiPath}/api.pl/members/new`;
    let fetchParams = {
      method: 'post',
      'headers': {
        'Content-Type': 'application/application/json',
        'Token': this.props.token,
        'mode': 'cors'
      },
      body: JSON.stringify(data)
    };
    fetchUrl(url, fetchParams, 'jsonResponse', this);
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

export default connect(mapStateToProps, mapDispatchToProps)(CreateMember);