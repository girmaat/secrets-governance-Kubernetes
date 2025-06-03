from flask import Flask, jsonify
import os

app = Flask(__name__)

@app.route("/")
def read_secret():
    secret = os.environ.get("APP_SECRET", "Not set")
    return jsonify({"secret": secret})

@app.route("/health")
def health():
    return "OK", 200

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
