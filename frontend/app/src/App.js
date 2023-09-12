import React, { useState } from 'react';
import logo from './logo.svg';
import './App.css';

function App() {
  const [flaskResponse, setFlaskResponse] = useState('');
  const [ginResponse, setGinResponse] = useState('');
  const [springResponse, setSpringResponse] = useState('');

  const fetchFlaskData = async () => {
    try {
      const response = await fetch('http://my-flask-python-app:8082/ping');
      const data = await response.json();
      // {'some': 2, 'text': 2, 'repeats': 2, 'more': 1, 'and': 1, 'less': 1}
      setFlaskResponse(data.message);
    } catch (error) {
      console.error(error);
    }
  };

  const fetchGinData = async () => {
    try {
      const response = await fetch('http://my-gin-golang-app:8081/ping');
      const data = await response.json();
      setGinResponse(data.message);
    } catch (error) {
      console.error(error);
    }
  };

  const mapWordsToList = async () => {
    return <ul>
      object.entries 
      <li>key: value</li>
    </ul>
  };

  const fetchSpringData = async () => {
    try {
      const response = await fetch('http://my-spring-boot-app:8080/ping');
      const data = await response.json();
      setSpringResponse(data.message);
    } catch (error) {
      console.error(error);
    }
  };
  return (
    <div className="App">
      <header className="App-header">
        <img src={logo} className="App-logo" alt="logo" />
        <p>Edit <code>src/App.js</code> and save to reload.</p>
        <a className="App-link" href="https://reactjs.org" target="_blank" rel="noopener noreferrer">Learn React</a>
        <button onClick={fetchFlaskData}>Fetch Flask Data</button>
        <> {mapWordsToList()} </>
        <p>Flask Response: {flaskResponse}</p>
        <button onClick={fetchGinData}>Fetch GIN Data</button>
        <p>GIN Response: {ginResponse}</p>
        <button onClick={fetchSpringData}>Fetch Spring Data</button>
        <p>Spring Response: {springResponse}</p>
      </header>
    </div>
  );
}

export default App;
