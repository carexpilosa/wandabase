import React from 'react';
export default class CreateMember extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      jsonResponse: {}
    };
  }

  render() {
    return (
      <div>
        <h3>Neues Event</h3>
        <label htmlFor="headline">Titel: </label>
        <input name="headline" id="headline" type="text" />
        <br />
        <label htmlFor="description">Beschreibung: </label>
        <textarea name="description" id="description" rows="4" cols="50"></textarea>
        <br />
        <label htmlFor="starttime">starttime: </label>
        <input name="starttime" id="starttime" type="text" defaultValue="2017-12-24 18:00:00" />
        <br />
        <label htmlFor="startlocation">startlocation: </label>
        <input name="startlocation" id="startlocation" type="text" size="50"/>
        <br />
        <button onClick={(e) => { this._do(e); } }>CLICK</button>

        {
          Object.keys(this.state.jsonResponse).map((key, idx) => {
            return <div key={idx}>{key} =&gt; {this.state.jsonResponse[key]}</div>;
          })
        }
      </div>
    );
  }

  _do (e) {
    let data = {};
    for(let i=0; i < e.target.parentElement.children.length; i++) {
      let child = e.target.parentElement.children[i];
      if(child.id === 'headline') {
        data['headline'] = child.value;
      } else if(child.id === 'description') {
        data['description'] = child.value;
      } else if(child.id === 'starttime') {
        data['starttime'] = child.value;
      } else if(child.id === 'startlocation') {
        data['startlocation'] = child.value;
      }
    }
    let that = this;
    let url = 'http://localhost/wanda/perl/dbconn.pl/events/new';
    fetch(url, {
      method: 'post',
      body: JSON.stringify(data)
    }) // Call the fetch function passing the url of the API as a parameter
      .then(function(response) {
        return response.json();
      })
      .then(function(json) {
        that.setState({jsonResponse: json});
      })
      .catch(function(error) {
        // This is where you run code if the server returns any errors
        console.log('ERROR: ' + error);
      });
  }
}
