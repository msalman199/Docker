const express = require('express');
const _ = require('lodash');

const app = express();
const PORT = process.env.PORT || 3000;

app.get('/', (req, res) => {
  const data = _.shuffle([1, 2, 3, 4, 5]);
  res.json({
    message: 'Hello from BuildKit Demo!',
    shuffled: data,
    timestamp: new Date().toISOString()
  });
});

app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});
