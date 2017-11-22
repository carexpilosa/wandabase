import React from 'react';
export default class CreateAccount extends React.Component {
  constructor(props) {
    super(props);
  }

  render() {
    return (
      <div>
        Neuer Account
        <form action="http://localhost/wanda/test.pl" method="post">
          <label htmlFor="username">Username: </label>
          <input name="username" type="text" />
          <br />
          <label htmlFor="password">Password: </label>
          <input name="password" type="password" />
          <br />
          <label htmlFor="gender">Gender: </label>
          <select name="gender" type="select">
            <option>m</option>
            <option>w</option>
          </select>
          <br />
          <label htmlFor="isadmin">Is Admin</label>
          <input type="checkbox" name="is_admin" />
          <br />
          <label htmlFor="motto">Motto</label>
          <textarea name="motto" rows="4" cols="50"></textarea>
          <br />
          <input type="submit" />
        </form>
      </div>
    );
  }
}
