import React from 'react';
import {connect} from 'react-redux';
import { config } from '../../wanderbase.config';
import { deleteToken, setToken } from '../../actions';
import { fetchUrl} from '../Utils';
import { Link } from 'react-router-dom';

class ShowSingleEvent extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      jsonResponseEvents: {},
      jsonResponseComment: {},
      jsonResponseActComments: {},
      jsonResponse: {},
      commentModeActive: false,
      comment: '',
      commentPredecessor: undefined
    };
    let url = `${config.apiPath}/api.pl/events/${this.props.match.params.id}`;
    let fetchParams = {
      method: 'get',
      'headers': {
        'Content-Type': 'application/application/json',
        'Token': this.props.token,
        'mode': 'cors'
      }
    };
    fetchUrl(url, fetchParams, 'jsonResponseEvents', this);

    //comments for event_id
    url = `${config.apiPath}/api.pl/comments?event_id=${this.props.match.params.id}`;
    fetchParams = {
      method: 'get',
      'headers': {
        'Content-Type': 'application/application/json',
        'Token': this.props.token,
        'mode': 'cors'
      }
    };
    fetchUrl(url, fetchParams, 'jsonResponseActComments', this);
  }

  render() {
    let eventID = this.props.match.params.id,
      eventObj = this.state.jsonResponseEvents[eventID],
      actComments = this.state.jsonResponseActComments,
      token = this.props.token;
    return <div>
      <div>
        {
          <h3>Show Single <Link to={`/showsingleevent/${eventID}`}>Event {eventID}</Link> {token}</h3>
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
        //this._renderCommentBox()
      }

      {
        Object.keys(actComments)
          .sort((a, b) =>
            actComments[a].created < actComments[b].created
              ? 1 : -1
          )
          .filter((key) => actComments[key].predecessor_id === null)
          .map((key, idx) => 
            <div key={idx}>
              <hr/>
              <h3>({actComments[key].id})</h3>
              <h3>{actComments[key].username}, {actComments[key].created}</h3>
              <div style={{backgroundColor: 'orange', width: '200px'}}>
                {actComments[key].content}
              </div>
              <a href={`#${actComments[key].id}`} onClick={() => this.addComment(actComments[key].id)}>
                antworten auf {actComments[key].id}
              </a>
              {
                this._renderCommentBox(actComments[key].id)
              }
              {
                this._renderSuccessors(actComments[key].id, 0)
              }
            </div>
          )
      }
      
    </div>;
  }

  _renderSuccessors(id, level) {
    level++;
    let leftPx = '20px';
    let actComments = this.state.jsonResponseActComments;
    let filteredComments = Object.keys(actComments)
      .filter((key) => actComments[key].predecessor_id === id)
      .sort((a, b) =>
        actComments[a].created < actComments[b].created
          ? 1 : -1
      );
    return <div>
      {
        filteredComments.length
          ? <h3>Successors of Comment {id}</h3>
          : null
      }
      {
        filteredComments
          .map((key, idx) => 
            <div key={idx} style={{
              backgroundColor: '#' + (10-level) + (10-level) + (10-level),
              position: 'relative',
              left: leftPx,
              width: '300px'}}>
              <hr/>
              <h3>({actComments[key].id})</h3>
              <h3>{actComments[key].username}, {actComments[key].created} (L {level})</h3>
              <div style={{backgroundColor: 'orange', width: '200px'}}>
                {actComments[key].content}
              </div>
              <a href={`#${actComments[key].id}`} onClick={() => this.addComment(actComments[key].id)}>
                antworten auf {actComments[key].id}
              </a>
              {
                this._renderCommentBox(actComments[key].id)
              }
              {
                this._renderSuccessors(actComments[key].id, level)
              }
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

  addComment(id) {
    console.log('#######');
    this.setState({
      commentModeActive: true,
      commentPredecessor: id
    });
  }
  sendComment(eventID, predecessorId) {
    let url = `${config.apiPath}/api.pl/comments/new`;
    let data = {
      'event_id': eventID,
      'content': this.state.comment,
      'predecessor_id': predecessorId
    };
    let fetchParams = {
      method: 'post',
      'headers': {
        'Content-Type': 'application/application/json',
        'Token': this.props.token,
        'mode': 'cors'
      },
      body: JSON.stringify(data)
    };
    fetchUrl(url, fetchParams, 'jsonResponseComment', this);
    //only if successful =>
    this.setState({
      commentModeActive: false
    });
  }

  _renderCommentBox(actID) {
    let eventID = this.props.match.params.id,
      commentRespObj = this.state.jsonResponseComment;

    return ! this.state.commentPredecessor
      || (this.state.commentModeActive && actID === this.state.commentPredecessor)
      ? 
      <div>
        <h3>Neuer Commentaire
          {
            this.state.commentPredecessor
              ? ` (Antwort auf ${this.state.commentPredecessor})`
              : ''
          }
        </h3>
        <textarea onChange={e => this.updateComment(e)} cols="25" rows="5" name="comment" id="comment"></textarea>
        <button onClick={() => this.sendComment(eventID, this.state.commentPredecessor)}>Absenden</button>
        {
          Object.keys(commentRespObj).map((key, idx) =>
            <div  key={idx}>{`${key} => ${commentRespObj[key]}`}</div>
          )
        }
      </div>
      :
      <div>
        <a href="#" onClick={() => this.addComment()}>neuer Kommentar</a>
      </div>;
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
