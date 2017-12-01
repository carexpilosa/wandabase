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
              <Link to="/">home</Link>
            </td>
            <td width="100">
              <Link to="/newmember">new user</Link>
            </td>
            <td width="100">
              <Link to="/showmembers">show all users</Link>
            </td>
            <td width="100">
              <Link to="/newevent">new Event</Link>
            </td>
            <td width="100">
              <Link to="/showevents">show all Events</Link>
            </td>
          </tr>
        </tbody>
      </table>
    );
  }
}
