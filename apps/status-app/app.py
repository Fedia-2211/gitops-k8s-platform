import os, socket
from flask import Flask, jsonify

app = Flask(__name__)

@app.route("/")
def status():
    return jsonify({
        "status": "ok",
        "pod": socket.gethostname(),
        "version": os.environ.get("APP_VERSION", "dev")
    })

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
# trigger