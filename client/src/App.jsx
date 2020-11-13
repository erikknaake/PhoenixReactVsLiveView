import './App.css';
import {useEffect, useState} from "react";
import socket from './socket';
import {API_BASE_URL} from "./constants";

function App() {
  let [editions, setEditions] = useState([]);

  const fetchEditions = () => fetch(API_BASE_URL + '/api/editions', {mode: 'cors'})
      .then(resp => resp.json())
      .then(json => {
          console.log('fetched: ', json);
          setEditions(json);
      });

  useEffect(() => {
      console.log('joining channel');
      let channel = socket.channel("edition", {});
      channel.on("team_joined", ({editions}) => {
          console.log('received team_joined with event: ', editions);
          setEditions(editions);
      });
      channel.join()
          .receive("ok", resp => {
              console.log("Joined successfully, ", resp);
              console.log('fetching')
              fetchEditions().then(() => {
                  fetch(API_BASE_URL + '/api/editions/2017-10-05', {
                      method: 'POST',
                      body: JSON.stringify("Kabouters"),
                      headers: {
                          'Content-Type': 'application/json'
                      },
                      mode: 'cors'
                  });
              });
          })
          .receive("error", resp => {
              console.log('Unable to join, response: ', resp);
          });
      console.log('finished join use effect');
  }, [1]);

  return (
    <div className="App">

      <div>
        <ul>
          {editions.map(edition =>
              <li>
                <div>{edition.date}
                <ul>
                    {edition.teams.map(team => <li>{team}</li>)}
                    </ul>
                </div>
                  </li>
              )}
        </ul>
      </div>
    </div>
  );
}

export default App;
