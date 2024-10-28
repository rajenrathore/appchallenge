import requests
from flask import Flask, jsonify

app = Flask(__name__)

@app.route('/')
def reverse_message():
    try:
        response = requests.get('http://app1:6000/')
        
        # Check if the request was successful
        response.raise_for_status()  # Raises an HTTPError for bad responses.
        
        # Parse the JSON response
        original_data = response.json()
        
        # Reverse the message
        reversed_message = original_data['message'][::-1]
        
        # Prepare the reversed data
        reversed_data = {
            "id": original_data['id'],
            "message": reversed_message
        }
        
        return jsonify(reversed_data)
    
    except requests.exceptions.HTTPError as http_err:
        app.logger.error(f"HTTP error occurred: {http_err}")  # Log the HTTP error
        return jsonify({"error": "Error fetching data from app1 service", "details": str(http_err)}), 500
    except requests.exceptions.RequestException as req_err:
        app.logger.error(f"Request error occurred: {req_err}")  # Log other request-related errors
        return jsonify({"error": "Request to app1 service failed", "details": str(req_err)}), 500
    except ValueError as json_err:
        app.logger.error(f"JSON decoding error: {json_err}")  # Log JSON parsing errors
        return jsonify({"error": "Error decoding response from app1 service", "details": str(json_err)}), 500
    except Exception as e:
        app.logger.error(f"An unexpected error occurred: {e}")  # Log unexpected errors
        return jsonify({"error": "An unexpected error occurred", "details": str(e)}), 500

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=6001)
