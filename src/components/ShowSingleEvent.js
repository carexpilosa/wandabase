/* global require */

import React from 'react';

const config = require ('../../wanderbase.config');

export default class ShowSingleEvent extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      jsonResponse: {},
      addCommentMode: false
    };

    let that = this;
    let url = `${config.dbconnPath}/dbconn.pl/events/${this.props.match.params.id}`;
    fetch(url, {
      method: 'get'
    }) // Call the fetch function passing the url of the API as a parameter
      .then(function(response) {
        return response.json();
      })
      .then(function(json) {
        that.setState({
          jsonResponse: json
        });
      })
      .catch(function(error) {
        return `{error = "${error}"}`;
      });
  }

  render() {
    let eventID = this.props.match.params.id,
      eventObj = this.state.jsonResponse[eventID];
    let token = this.getCookie('token');
    console.log(`token => ${token}`);

    
    return <div>
      <div>
        <h3>Show Single Event {eventID}</h3>
      </div>
      <table>
        <tbody>
          {
            eventObj
              ? ['id', 'title', 'starttime',
                'startlocation', 'description',
                'created'].map((fieldname, idx) => {
                return <tr key={idx}>
                  <td key="1">{fieldname}</td>
                  <td key="2">{eventObj[fieldname]}</td>
                </tr>;
              })
              : null
          }
        </tbody>
      </table>
      {
        this.state.addCommentMode ? 
          <div>
            <h3>Neuer Commentaire</h3>
            <textarea cols="25" rows="5" name="comment"></textarea>
            <token></token>
            <button>Absenden</button>
          </div>
          :
          <a href="#" onClick={e => this.addComment(e)}>neuer Kommentar</a>
      }
      
    </div>;
  }
  addComment(e) {
    console.log('addiere Commentaire');
    this.setState({
      addCommentMode: true
    });
  }
  getCookie(name) {
    let cookieEntries = document.cookie.split(/;/),
        cookieObj = {};
    cookieEntries.map(entry => {
      let [key, value] = entry.split(/=/);
      key = key.replace(/^\s+|\s+$/g,'');
      cookieObj[key] = value;
    });
    //console.log(cookieObj);
    return cookieObj[name];
  }
}
