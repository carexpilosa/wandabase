import React from 'react';
import { getCookie } from '../../lib/connection';
import { config } from '../../wanderbase.config';

export default class ShowSingleEvent extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      jsonResponseEvents: {},
      jsonResponseComment: {},
      jsonResponse: {},
      commentModeActive: false
    };

    let that = this;
    let url = `${config.apiPath}/api.pl/events/${this.props.match.params.id}`;
    fetch(url, {
      method: 'get',
      'headers': {
        'Content-Type': 'application/application/json',
        'Token': getCookie('token'),
        'mode': 'cors'
      }
    }) // Call the fetch function passing the url of the API as a parameter
      .then(function(response) {
        return response.json();
      })
      .then(function(json) {
        that.setState({
          jsonResponseEvents: json
        });
      })
      .catch(function(error) {
        return `{error = "${error}"}`;
      });
  }

  render() {
    let eventID = this.props.match.params.id,
      eventObj = this.state.jsonResponseEvents[eventID];
    //let token = getCookie('token');
    //console.log(document.cookie);

    //console.log(eventObj);
    
    return <div>
      <div>
        <h3>Show Single Event {eventID} {document.cookie}</h3>
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
        this.state.commentModeActive
          ? 
          <div>
            <h3>Neuer Commentaire</h3>
            <textarea cols="25" rows="5" name="comment" id="comment"></textarea>
            <button onClick={() => this.sendComment(eventID)}>Absenden</button>
          </div>
          :
          <a href="#" onClick={() => this.addComment()}>neuer Kommentar</a>
      }
      
    </div>;
  }
  addComment() {
    console.log('addiere Commentaire');
    this.setState({
      commentModeActive: true
    });
  }
  sendComment(eventID) {
    console.log('verschicke --- Commentaire mit Token ' + getCookie('token'));
    let url = `${config.apiPath}/api.pl/comments/new`,
      data = {
        'member_id': 123,
        'event_id': eventID,
        'content': 'content'
      },
      that = this;

    fetch(url, {
      method: 'post',
      'headers': {
        'Content-Type': 'application/application/json',
        'Token': getCookie('token'),
        'mode': 'cors'
      },
      body: JSON.stringify(data)
    }) // Call the fetch function passing the url of the API as a parameter
      .then(function(response) {
        return response.json();
      })
      .then(function(json) {
        that.setState({
          jsonResponseComment: json
        });
      })
      .catch(function(error) {
        return `{error = "${error}"}`;
      });
  }
}
