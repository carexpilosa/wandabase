import React from 'react';
import { Link } from 'react-router-dom';
export default class Menu extends React.Component {
  constructor(props) {
    super(props);
  }

  render() {
    return (
      <table>
        <tbody>
          <tr>
            <td width="100">
              <Link to="/ca">new user</Link>
              </td>
            <td width="100">
              <Link to="/test">test</Link>
            </td>
          </tr>
        </tbody>
      </table>
    );
  }
}
