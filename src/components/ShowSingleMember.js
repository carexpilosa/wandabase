/* global require */

import React from 'react';

const config = require ('../../wanderbase.config');

export default class ShowSingleMember extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      jsonResponse: {}
    };

    let that = this;
    let url = `${config.dbconnPath}/dbconn.pl/members/${this.props.match.params.id}`;
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
    let memberID = this.props.match.params.id,
      memberObj = this.state.jsonResponse[memberID];
    
    return <div>
      <div>
        <h3>Show Single Member {memberID}</h3>
      </div>
      <table>
        <tbody>
          {
            memberObj
              ? ['id', 'username', 'password',
                'gender', 'date_of_membership',
                'is_admin', 'motto', 'token'].map((fieldname, idx) => {
                return <tr key={idx}>
                  <td key="1">{fieldname}</td>
                  <td key="2">{memberObj[fieldname]}</td>
                </tr>;
              })
              : null
          }
        </tbody>
      </table>
    </div>;
  }
}
