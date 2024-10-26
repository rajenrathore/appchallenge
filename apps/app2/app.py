import requests
from flask import Flask, jsonify

app = Flask(__name__)

@app.route('/')
def reverse_message():
    response = requests.get('http://app1:6000/')
    
    if response.status_code == 200:
        original_data = response.json()
        reversed_message = original_data['message'][::-1]
        reversed_data = {
            "id": original_data['id'],
            "message": reversed_message
        }
        return jsonify(reversed_data)
    else:
        return jsonify({"error": "Unable to fetch data from the app1 service"}), 500

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=6001)
