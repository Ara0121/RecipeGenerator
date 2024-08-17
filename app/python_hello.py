from flask import Flask, jsonify

app = Flask(__name__)

@app.route('/hello', methods=['GET'])
def say_hello():
    print("Hello from Python!")  # Print in the Python backend
    return '', 204 

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=5000)