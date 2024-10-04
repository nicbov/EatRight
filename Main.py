from flask import Flask, jsonify, request

app = Flask(__name__)

# In mem storage -> maybe switch to db later?

users = []

@app.route('/api/register', methods=['POST'])
def register():
    data = request.get_json()  # Expecting JSON data
    username = data.get('username')
    password = data.get('password')
    
    # Here you should add validation and password hashing in a real app
    if username and password:
        users.append({'username': username, 'password': password})  # Simple in-memory storage
        return jsonify({"message": "User registered successfully!"}), 201
    else:
        return jsonify({"error": "Username and password required!"}), 400

@app.route('/api/login', methods=['POST'])
def login():
    data = request.get_json()
    username = data.get('username')
    password = data.get('password')
    
    # Simple login check
    user = next((u for u in users if u['username'] == username and u['password'] == password), None)
    
    if user:
        return jsonify({"message": "Login successful!"}), 200
    else:
        return jsonify({"error": "Invalid credentials!"}), 401



if __name__ == '__main__':
    app.run(debug=True)
