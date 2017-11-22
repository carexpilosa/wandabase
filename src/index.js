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
      <Redirect from="/" to="/ca" />
      <Route path="/test" component={Test} />
      <Route path="/ca" component={CreateAccount} />
      <Route path="/menu" component={Menu} />
    </div>
  </Router>,
  document.getElementById('app')
);
