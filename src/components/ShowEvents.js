/* global require */

import React from 'react';
import { getCookie } from '../../lib/connection';

const config = require ('../../wanderbase.config');

export default class ShowEvents extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      jsonResponse: {}
    };

    let that = this;
    let url = `${config.dbconnPath}/dbconn.pl/events/all`;
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
          jsonResponse: json
        });
      })
      .catch(function(error) {
        return `{error = "${error}"}`;
      });
  }

  render() {
    return <div>
      <div>Show Events</div>
      {
        this.state.jsonResponse.hasOwnProperty('error')
          ? <span>ERROR =&gt; {this.state.jsonResponse.error}</span>
          : Object.keys(this.state.jsonResponse)
            .sort(sorter)
            .map((key, idx) => {
              return <div key={idx}>{key}<br />
                <table>
                  <tbody>
                    <tr>
                      <th>id</th><th>{this.state.jsonResponse[key].id}</ th>
                    </tr><tr>
                      <td>title</td>
                      <td>
                        <a href={`${config.indexPath}/showsingleevent/${key}`}>
                          {this.state.jsonResponse[key].title}
                        </a>
                      </td>
                    </tr><tr>
                      <td>description</td>
                      <td>{this.state.jsonResponse[key].description}</ td>
                    </tr><tr>
                      <td>created</td>
                      <td>{this.state.jsonResponse[key].created}</ td>
                    </tr><tr>
                      <td>starttime</td>
                      <td>{this.state.jsonResponse[key].starttime}</ td>
                    </tr><tr>
                      <td>startlocation</td>
                      <td>{this.state.jsonResponse[key].startlocation}</ td>
                    </tr>
                  </tbody>
                </table>
              </div>;
            })
      }
    </div>;
    function sorter(a, b) {
      let [intA, intB] = [parseInt(a, 10), parseInt(b, 10)];
      return intA < intB ? 1 : intA > intB ? -1 : 0;
    }
  }
}
