'use strict';
const http = require('http');

const srv = http.createServer((req, res) => {
  res.writeHead(200, { 'Content-Type': 'text/plain' });
  res.end('okay');
});

srv.listen(process.env.PORT || 8000, '0.0.0.0');
