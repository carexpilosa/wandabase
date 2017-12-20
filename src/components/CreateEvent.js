import React from 'react';
import { getToken } from '../../actions';
import { config } from '../../wanderbase.config';
import { fetchUrl } from '../Utils';

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
        <h3>Neues Event</h3>
        <label htmlFor="title">Titel: </label>
        <input name="title" id="title" type="text" />
        <br />
        <label htmlFor="description">Beschreibung: </label>
        <textarea name="description" id="description" rows="4" cols="50"></textarea>
        <br />
        <label htmlFor="starttime">starttime: </label>
        <input name="starttime" id="starttime" type="text" defaultValue="2017-12-24 18:00:00" />
        <br />
        <label htmlFor="startlocation">startlocation: </label>
        <input name="startlocation" id="startlocation" type="text" size="50"/>
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
      if(child.id === 'title') {
        data['title'] = child.value;
      } else if(child.id === 'description') {
        data['description'] = child.value;
      } else if(child.id === 'starttime') {
        data['starttime'] = child.value;
      } else if(child.id === 'startlocation') {
        data['startlocation'] = child.value;
      }
    }
    let url = `${config.apiPath}/api.pl/events/new`;
    let fetchParams = {
      method: 'post',
      'headers': {
        'Content-Type': 'application/application/json',
        'Token': getToken(),
        'mode': 'cors'
      },
      body: JSON.stringify(data)
    };
    fetchUrl(url, fetchParams, 'jsonResponse', this);
  }
}
