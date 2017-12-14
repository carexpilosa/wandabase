import React from 'react';
import { getCookie } from '../../lib/connection';
import { config } from '../../wanderbase.config';

export default class ShowSingleEvent extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      jsonResponseEvents: {},
      jsonResponseComment: {},
      jsonResponseActComments: {},
      jsonResponse: {},
      commentModeActive: false,
      comment: ''
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

    //comments for event_id
    url = `${config.apiPath}/api.pl/comments?event_id=${this.props.match.params.id}`;
    console.log(url);
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
          jsonResponseActComments: json
        });
      })
      .catch(function(error) {
        return `{error = "${error}"}`;
      });
  }

  render() {
    let eventID = this.props.match.params.id,
      eventObj = this.state.jsonResponseEvents[eventID],
      commentRespObj = this.state.jsonResponseComment,
      jsonResponseActComments = this.state.jsonResponseActComments;
    //let token = getCookie('token');
    console.log(this.state.jsonResponseActComments);

    console.log(this.state.jsonResponseComment);
    
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
            <textarea onChange={e => this.updateComment(e)} cols="25" rows="5" name="comment" id="comment"></textarea>
            <button onClick={() => this.sendComment(eventID)}>Absenden</button>
            {
              Object.keys(commentRespObj).map((key, idx) => {
                return <div  key={idx}>{`${key} => ${commentRespObj[key]}`}</div>;
              })
            }
          </div>
          :
          <a href="#" onClick={() => this.addComment()}>neuer Kommentar</a>
      }

      {
        Object.keys(jsonResponseActComments).map((key, idx) => {
          return <div key={idx}>
            <h3>{jsonResponseActComments[key].username}</h3>
            {jsonResponseActComments[key].content}
          </div>;
        })
      }
      
    </div>;
  }

  updateComment(e) {
    console.log(e.target.value);
    this.setState({
      comment: e.target.value
    });
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
        'event_id': eventID,
        'content': this.state.comment
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
