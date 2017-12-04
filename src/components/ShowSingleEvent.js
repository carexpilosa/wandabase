/* global require */

import React from 'react';

const config = require ('../../wanderbase.config');

export default class ShowSingleEvent extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      jsonResponse: {}
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
    </div>;
  }
}
