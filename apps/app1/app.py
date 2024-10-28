from flask import Flask, jsonify

app = Flask(__name__)

@app.route('/')
def helloworld():
    try:
        response = {
            "id": "1",
            "message": "Hello world"
        }
        return jsonify(response)
    except Exception as e:
        # Log the exception
        app.logger.error(f"Error in helloworld: {e}")
        return jsonify({"error": "Internal Server Error"}), 500

# Error handlers
@app.errorhandler(404)
def not_found(error):
    return jsonify({"error": "Not Found"}), 404

@app.errorhandler(500)
def internal_error(error):
    return jsonify({"error": "Internal Server Error"}), 500

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=6000)
