import React from 'react';
import { getToken } from '../../actions';
import { config } from '../../wanderbase.config';
import { fetchUrl} from '../Utils';

export default class ShowSingleMember extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      jsonResponse: {}
    };

    let url = `${config.apiPath}/api.pl/members/${this.props.match.params.id}`;
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
