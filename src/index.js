import React from 'react';
import ReactDOM from 'react-dom';
import { Router, Route } from 'react-router';
import createHistory from 'history/createBrowserHistory';
import Menu from './components/Menu';
import CreateMember from './components/CreateMember';
import ShowMembers from './components/ShowMembers';
import CreateEvent from './components/CreateEvent';
import ShowEvents from './components/ShowEvents';
import ShowSingleEvent from './components/ShowSingleEvent';
import ShowSingleMember from './components/ShowSingleMember';
import Login from './components/Login';

const history = createHistory();

ReactDOM.render(
  <Router history={history}>
    <div>
      <Route path = "/" component={Menu} />
      <div>
        <Route path="/login" component={Login} />
        <Route path="/newmember" component={CreateMember} />
        <Route path="/showmembers" component={ShowMembers} />
        <Route path="/newevent" component={CreateEvent} />
        <Route path="/showevents" component={ShowEvents} />
        <Route path="/showsingleevent/:id" component={ShowSingleEvent} />
        <Route path="/showsinglemember/:id" component={ShowSingleMember} />
      </div>
    </div>
  </Router>,
  document.getElementById('app')
);
