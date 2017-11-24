import React from 'react';
import ReactDOM from 'react-dom';
import { Router, Route, hashHistory, Redirect } from 'react-router';
import createHistory from 'history/createBrowserHistory';
import Menu from "./components/Menu";
import Test from "./components/Test";
import CreateAccount from "./components/CreateAccount";

const history = createHistory();

ReactDOM.render(
  <Router history={history}>
    <div>
      <Menu />
      <Route path="/ca" component={CreateAccount} />
      <Route path="/test" component={Test} />
    </div>
  </Router>,
  document.getElementById('app')
);
