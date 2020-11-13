import logo from './logo.svg';
import './App.css';
import {useEffect, useState} from "react";

const API_BASE_URL = process.env.REACT_APP_API_BASE_URL || 'http://localhost:4000'

function App() {
  let [editions, setEditions] = useState([]);
  const fetchEditions = () => fetch(API_BASE_URL + '/api/editions', {mode: 'cors'})
      .then(resp => resp.json())
      .then(json => {
          console.log('fetched: ', json);
          setEditions(json);
      });

  useEffect(() => {
    console.log('fetching')
      fetchEditions().then(() => {
          fetch(API_BASE_URL + '/api/editions/2017-10-05', {
              method: 'POST',
              body: JSON.stringify("Kabouters"),
              headers: {
                  'Content-Type': 'application/json'
              },
              mode: 'cors'
          })
              .then(resp => {
                  console.log('done with post')
                  fetchEditions();
              });
      });
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
