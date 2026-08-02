#!/usr/bin/env python3
import http.server
import socketserver
import os
from datetime import datetime

class CustomHandler(http.server.SimpleHTTPRequestHandler):
    def do_GET(self):
        if self.path == '/':
            self.path = '/index.html'
        elif self.path == '/health':
            self.send_response(200)
            self.send_header('Content-type', 'application/json')
            self.end_headers()
            response = f'{{"status": "healthy", "timestamp": "{datetime.now().isoformat()}", "hostname": "{os.uname().nodename}"}}'
            self.wfile.write(response.encode())
            return
        return http.server.SimpleHTTPRequestHandler.do_GET(self)

PORT = int(os.environ.get('PORT', 8080))
Handler = CustomHandler

with socketserver.TCPServer(("", PORT), Handler) as httpd:
    print(f"Server running at http://localhost:{PORT}")
    print(f"Health check available at http://localhost:{PORT}/health")
    httpd.serve_forever()
