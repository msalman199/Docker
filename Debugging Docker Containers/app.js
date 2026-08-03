const express = require('express');
const mysql = require('mysql2');
const app = express();

const db = mysql.createConnection({
  host: 'debug-db',
  user: 'testuser',
  password: 'testpass',
  database: 'testdb'
});

app.get('/', (req, res) => {
  console.log('Received request to /');
  res.json({status: 'ok', message: 'App is running'});
});

app.get('/db-test', (req, res) => {
  console.log('Testing database connection...');
  db.query('SELECT 1 as test', (err, results) => {
    if (err) {
      console.error('Database error:', err);
      res.status(500).json({error: 'Database connection failed'});
    } else {
      console.log('Database connection successful');
      res.json({status: 'ok', data: results});
    }
  });
});

const port = 3000;
app.listen(port, '0.0.0.0', () => {
  console.log(\`Server running on port \${port}\`);
});
