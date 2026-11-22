#!/usr/bin/env python3
"""静态服务：强制 no-store，手机打开永远拿最新版（替代 python -m http.server）"""
import http.server, socketserver, os, sys

PORT = int(sys.argv[1]) if len(sys.argv) > 1 else 3000
ROOT = sys.argv[2] if len(sys.argv) > 2 else '/workspace'

class Handler(http.server.SimpleHTTPRequestHandler):
    def __init__(self, *a, **kw):
        super().__init__(*a, directory=ROOT, **kw)

    def end_headers(self):
        # 关键：禁止任何缓存层（浏览器/webview/CDN）存 HTML
        self.send_header('Cache-Control', 'no-store, no-cache, must-revalidate, max-age=0')
        self.send_header('Pragma', 'no-cache')
        self.send_header('Expires', '0')
        self.send_header('Access-Control-Allow-Origin', '*')
        super().end_headers()

    def log_message(self, fmt, *args):
        pass  # 静音，避免日志刷屏

class Server(socketserver.ThreadingTCPServer):
    allow_reuse_address = True
    daemon_threads = True

if __name__ == '__main__':
    with Server(('0.0.0.0', PORT), Handler) as httpd:
        print(f'serving {ROOT} on :{PORT} with no-store', flush=True)
        httpd.serve_forever()
