from flask import Flask, jsonify

app = Flask(__name__)

@app.route('/')
def helloworld():
    response = {
        "id": "1",
        "message": "Hello world"
    }
    return jsonify(response)

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=6000)