import cleverbotfree
from urllib.parse import urlparse, parse_qs
from http.server import HTTPServer, BaseHTTPRequestHandler

cleverbot = None

class AmogusServer(BaseHTTPRequestHandler):
	def _set_headers(self):
		self.send_response(200)
		self.send_header("Content-type", "text/plain")
		self.end_headers()

	def do_GET(self):
		self._set_headers()
		query_components = parse_qs(urlparse(self.path).query)
		self.wfile.write(cleverbot.single_exchange(query_components["message"][0]).encode("utf8"))

def main():
	global cleverbot

	with cleverbotfree.sync_playwright() as cleverbot_pw:
		cleverbot = cleverbotfree.Cleverbot(cleverbot_pw)

		httpd = HTTPServer(("localhost", 6969), AmogusServer)

		try:
			httpd.serve_forever()
		except KeyboardInterrupt:
			pass
		finally:
			cleverbot.close()

if __name__ == "__main__":
	main()
