import logo from './logo.svg';
import './App.css';
import {useEffect, useState} from "react";

function App() {
  let [editions, setEditions] = useState([]);
  const fetchEditions = () => fetch('http://localhost:4000/api/editions', {mode: 'cors'})
      .then(resp => resp.json())
      .then(json => {
          console.log('fetched: ', json);
          setEditions(json);
      });

  useEffect(() => {
    console.log('fetching')
      fetchEditions().then(() => {
          fetch('http://localhost:4000/api/editions/2017', {
              method: 'POST',
              body: JSON.stringify(["Witte Wieven", "Kabouters"]),
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
                <div>{edition.year}
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
