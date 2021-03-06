import React from 'react';
import { Link } from 'react-router-dom';

import { getToken } from '../../actions';
import { config } from '../../wanderbase.config';
import { fetchUrl} from '../Utils';

export default class ShowMembers extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      jsonResponse: {}
    };

    let url = `${config.apiPath}/api.pl/members/all`;
    let fetchParams = {
      'method': 'get',
      'headers': {
        'Content-Type': 'application/application/json',
        'Token': getToken(),
        'mode': 'cors'
      }
    };
    fetchUrl(url, fetchParams, 'jsonResponse', this);
  }

  render() {
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
                          <Link to={`/showsinglemember/${key}`}>
                            {this.state.jsonResponse[key].username}
                          </Link>
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
                      </tr><tr>
                        <td>token_created</td>
                        <td>{this.state.jsonResponse[key].token_created}</ td>
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
