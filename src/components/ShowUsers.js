import React from 'react';
import ReactDOM from 'react-dom';

export default class ShowUsers extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      jsonResponse: 'xxx'
    }

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
      that.setState({
        jsonResponse: json
      });
      console.log(that.state);
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
          Object.keys(this.state.jsonResponse)
            .sort((a, b) => a < b)
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
  }
}
