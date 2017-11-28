import React from 'react';
import ReactDOM from 'react-dom';

export default class ShowUsers extends React.Component {
  constructor(props) {
    super(props);

    console.log('-------');
    let that = this;
    let url = 'http://localhost/wanda/dbconn.pl/members/all';
    fetch(url, {
      method: 'get'
    }) // Call the fetch function passing the url of the API as a parameter
    .then(function(response) {
      console.log(url);
      return response.json();
    })
    .then(function(json) {
      console.log({jsonResponse: json});
    })
    .catch(function(error) {
      // This is where you run code if the server returns any errors
      console.log('ERROR: ' + error);
    });
  }

  render() {
    return <div>Show Users</div>;
  }
}
