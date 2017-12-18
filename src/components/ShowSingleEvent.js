import React from 'react';
import {connect} from 'react-redux';
import { config } from '../../wanderbase.config';
import { deleteToken, setToken } from '../../actions';
import { store } from '../../reducers';

class ShowSingleEvent extends React.Component {
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
        'Token': this.props.token,
        'mode': 'cors'
      }
    })
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
    fetch(url, {
      method: 'get',
      'headers': {
        'Content-Type': 'application/application/json',
        'Token': this.props.token,
        'mode': 'cors'
      }
    })
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
      actComments = this.state.jsonResponseActComments,
      token = this.props.token;
    return <div>
      <div>
        {
          <h3>Show Single Event {eventID} {token}</h3>
        }
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
              Object.keys(commentRespObj).map((key, idx) =>
                <div  key={idx}>{`${key} => ${commentRespObj[key]}`}</div>
              )
            }
          </div>
          :
          <div>
            <a href="#" onClick={() => this.addComment()}>neuer Kommentar</a>
          </div>
      }

      {
        Object.keys(actComments)
          .sort((a, b) =>
            actComments[a].created < actComments[b].created
              ? 1 : -1
          )
          .map((key, idx) => 
            <div key={idx}>
              <h3>{actComments[key].username}, {actComments[key].created}</h3>
              {actComments[key].content}
            </div>
          )
      }
      
    </div>;
  }

  updateComment(e) {
    this.setState({
      comment: e.target.value
    });
  }

  addComment() {
    this.setState({
      commentModeActive: true
    });
  }
  sendComment(eventID) {
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
        'Token': this.props.token,
        'mode': 'cors'
      },
      body: JSON.stringify(data)
    })
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

export default connect(mapStateToProps, mapDispatchToProps)(ShowSingleEvent);
