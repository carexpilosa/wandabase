/* global require */

import React from 'react';

const config = require ('../../wanderbase.config');

export default class ShowMembers extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      jsonResponse: {}
    };

    let that = this;
    let url = `${config.dbconnPath}/dbconn.pl/members/all`;
    
    fetch(url, {
      'method': 'get',
      'headers': {
        'Authorization': 'Bearer lnvIFqJUpr-6RLK3FKZlEyNHnhJrh2_P',
        'Content-Type': 'application/application/json',
        'mode': 'cors'
      }
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
        // This is where you run code if the server returns any errors
        console.log('ERROR: ' + error);
      });
  }

  render() {
    console.log(this.state.jsonResponse);
    return <div>
      <div>Show Users</div>
      {
        this.state.jsonResponse.hasOwnProperty('error')
          ? <span>ERROR =&gt; {this.state.jsonResponse.error}</span>
          : Object.keys(this.state.jsonResponse)
            .sort(sorter)
            .map((key, idx) => {
              return (
                <div key={idx}>
                  <table>
                    <tbody>
                      <tr>
                        <th>id</th>
                        <th>{this.state.jsonResponse[key].id}</ th>
                      </tr><tr>
                        <td>username</td>
                        <td>
                          <a href={`${config.indexPath}/showsinglemember/${key}`}>
                            {this.state.jsonResponse[key].username}
                          </a>
                        </td>
                      </tr><tr>
                        <td>password</td>
                        <td>{this.state.jsonResponse[key].password}</ td>
                      </tr><tr>
                        <td>gender</td>
                        <td>{this.state.jsonResponse[key].gender}</ td>
                      </tr><tr>
                        <td>date_of_membership</td>
                        <td>{this.state.jsonResponse[key].date_of_membership}</ td>
                      </tr><tr>
                        <td>is_admin</td>
                        <td>{this.state.jsonResponse[key].is_admin}</ td>
                      </tr><tr>
                        <td>motto</td>
                        <td>{this.state.jsonResponse[key].motto}</ td>
                      </tr><tr>
                        <td>token</td>
                        <td>{this.state.jsonResponse[key].token}</ td>
                      </tr>
                    </tbody>
                  </table>
                </div>
              );
            })
      }
    </div>;
    function sorter(a, b) {
      return a < b ? 1 : a > b ? -1 : 0;
    }
  }
}
