import React from 'react';
import { Link } from 'react-router-dom';
import { config } from '../../wanderbase.config';
import { getToken } from '../../actions';
import { fetchUrl } from '../Utils';

export default class ShowEvents extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      jsonResponse: {}
    };

    let url = `${config.apiPath}/api.pl/events/all`;
    let fetchParams = {
      method: 'get',
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
      <div className="divStyle">Show Events</div>
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
                        <Link to={`/showsingleevent/${key}`}>
                          {this.state.jsonResponse[key].title}
                        </Link>
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
