import React from 'react';

export default class ShowMembers extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      jsonResponse: {}
    };

    let that = this;
    let url = 'http://localhost/wanda/perl/dbconn.pl/events/all';
    fetch(url, {
      method: 'get'
    }) // Call the fetch function passing the url of the API as a parameter
      .then(function(response) {
        return response.json();
      })
      .then(function(json) {
        that.setState({
          jsonResponse: json
        });
      })
      .catch(function(error) {
        return `{error = "${error}"}`;
      });
  }

  render() {
    return <div>
      <div>Show Users</div>
      {
        this.state.jsonResponse.hasOwnProperty('error')
          ? <span>ERROR =&gt; {this.state.jsonResponse.error}</span>
          : Object.keys(this.state.jsonResponse)
            .sort(sorter)
            .map((key, idx) => {
              return <div key={idx}>{key}<br />
                id            =&gt; {this.state.jsonResponse[key].id}<br />
                headline      =&gt; {this.state.jsonResponse[key].headline}<br />
                description   =&gt; {this.state.jsonResponse[key].description}<br />
                created       =&gt; {this.state.jsonResponse[key].created}<br />
                starttime     =&gt; {this.state.jsonResponse[key].starttime}<br />
                startlocation =&gt; {this.state.jsonResponse[key].startlocation}<br />
              </div>;
            })
      }
    </div>;
    function sorter(a, b) {
      let [intA, intB] = [parseInt(a, 10), parseInt(b, 10)];
      return intA < intB ? 1 : intA > intB ? -1 : 0;
    }
  }
}
