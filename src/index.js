import React from 'react';
import ReactDOM from 'react-dom';
import { Router, Route, hashHistory, Redirect } from 'react-router';
import createHistory from 'history/createBrowserHistory';
import Menu from "./components/Menu";
import ShowUsers from "./components/ShowUsers";
import CreateAccount from "./components/CreateAccount";

const history = createHistory();

ReactDOM.render(
  <Router history={history}>
    <div>
      <Menu />
      <Route path="/newuser" component={CreateAccount} />
      <Route path="/showusers" component={ShowUsers} />
    </div>
  </Router>,
  document.getElementById('app')
);
