// Enruta cada solicitud al slot indicado por active-slot.txt.
const http = require('node:http');
const fs = require('node:fs');
const path = require('node:path');
const activeFile = path.join(__dirname, 'runtime', 'active-slot.txt');
const ports = { blue: 8081, green: 8082 };

http.createServer((request, response) => {
  const slot = fs.readFileSync(activeFile, 'utf8').trim();
  const upstream = http.request({ hostname: '127.0.0.1', port: ports[slot],
    path: request.url, method: request.method, headers: request.headers }, upstreamResponse => {
    response.writeHead(upstreamResponse.statusCode, upstreamResponse.headers);
    upstreamResponse.pipe(response);
  });
  upstream.on('error', () => { response.writeHead(502); response.end('Backend no disponible'); });
  request.pipe(upstream);
}).listen(8080, '127.0.0.1', () => console.log('Router en puerto 8080'));
