import React, { useState, useEffect } from 'react';
import axios from 'axios';
import { LineChart, Line, XAxis, YAxis, CartesianGrid, Tooltip, Legend } from 'recharts';
import './App.css';

function App() {
  const [data, setData] = useState([]);
  const [groupedData, setGroupedData] = useState({});
  const [alerts, setAlerts] = useState([]);

  // Lấy dữ liệu từ API
  const fetchData = async () => {
    try {
      const response = await axios.get('http://localhost:5000/api/data');
      const fetchedData = response.data;

      // Nhóm dữ liệu theo khu vực và đồ vật
      const grouped = {};
      fetchedData.forEach(item => {
        const key = `${item.area} - ${item.name}`;
        if (!grouped[key]) {
          grouped[key] = [];
        }
        grouped[key].push(item);
      });

      setData(fetchedData);
      setGroupedData(grouped);
    } catch (error) {
      console.error('Error fetching data:', error);
    }
  };

  // Cập nhật dữ liệu mỗi 5 giây
  useEffect(() => {
    fetchData();
    const interval = setInterval(fetchData, 5000);
    return () => clearInterval(interval);
  }, []);

  // Nhận thông báo thời gian thực qua Server-Sent Events
  useEffect(() => {
    const eventSource = new EventSource('http://localhost:5000/api/alerts');

    eventSource.onmessage = (event) => {
      const message = event.data;
      setAlerts(prevAlerts => [message, ...prevAlerts].slice(0, 5)); // Giữ tối đa 5 thông báo
    };

    eventSource.onerror = (error) => {
      console.error('SSE error:', error);
      eventSource.close();
    };

    return () => {
      eventSource.close();
    };
  }, []);

  return (
    <div className="App">
      <h1>Fire Warning System</h1>
      <div className="alerts-section">
        <h2>Alerts</h2>
        {alerts.length === 0 ? (
          <p>No alerts yet.</p>
        ) : (
          <ul>
            {alerts.map((alert, index) => (
              <li key={index} className="alert">
                {alert}
              </li>
            ))}
          </ul>
        )}
      </div>
      <div className="data-section">
        {Object.keys(groupedData).length === 0 ? (
          <p>Loading...</p>
        ) : (
          Object.keys(groupedData).map(key => {
            const items = groupedData[key];
            const latest = items[0]; // Dữ liệu mới nhất
            const status = latest.temperature > latest.safe_threshold ? 'Danger' : 'Normal';

            return (
              <div key={key} className="item-card">
                <h2>{key}</h2>
                <p>Temperature: {latest.temperature.toFixed(1)} °C</p>
                <p>Safe Threshold: {latest.safe_threshold.toFixed(1)} °C</p>
                <p>
                  Status: <span style={{ color: status === 'Danger' ? 'red' : 'green' }}>{status}</span>
                </p>
                <h3>Temperature Chart</h3>
                <LineChart width={500} height={200} data={items}>
                  <CartesianGrid strokeDasharray="3 3" />
                  <XAxis dataKey="timestamp" />
                  <YAxis />
                  <Tooltip />
                  <Legend />
                  <Line type="monotone" dataKey="temperature" stroke="#8884d8" />
                </LineChart>
              </div>
            );
          })
        )}
      </div>
    </div>
  );
}

export default App;