import React from 'react';
import ReactDOM from 'react-dom';

export default class ShowUsers extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      jsonResponse: {}
    }

    let that = this;
    let url = 'http://localhost/wanda/perl/dbconn.pl/members/all';
    fetch(url, {
      method: 'get'
    }) // Call the fetch function passing the url of the API as a parameter
    .then(function(response) {
      return response.json();
    })
    .then(function(json) {
      console.log(json);
      that.setState({
        jsonResponse: json
      });
    })
    .catch(function(error) {
      // This is where you run code if the server returns any errors
      console.log('ERROR: ' + error);
    });
  }

  render() {
    return <div>
        <div>Show Users</div>
        {
          this.state.jsonResponse.hasOwnProperty('error')
            ? <span>ERROR => {this.state.jsonResponse.error}</span>
            : Object.keys(this.state.jsonResponse)
                .sort(sorter)
                .map((key, idx) => {
                  return <div key={idx}>{key}<br />
                    id                 => {this.state.jsonResponse[key].id}<br />
                    username           => {this.state.jsonResponse[key].username}<br />
                    password           => {this.state.jsonResponse[key].password}<br />
                    gender             => {this.state.jsonResponse[key].gender}<br />
                    date_of_membership => {this.state.jsonResponse[key].date_of_membership}<br />
                    is_admin           => {this.state.jsonResponse[key].is_admin}<br />
                    motto              => {this.state.jsonResponse[key].motto}<br /><br />
                  </div>;
                })
        }
      </div>;
    function sorter(a, b) {
      return a < b ? 1 : a > b ? -1 : 0
    }
  }
}
