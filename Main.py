from flask import Flask, jsonify, request
from flask_mysqldb import MySQL  # Use PyMySQL for Flask-PyMySQL

app = Flask(__name__)

# MySQL Configuration
app.config['MYSQL_HOST'] = 'localhost'
app.config['MYSQL_USER'] = 'root'  
app.config['MYSQL_PASSWORD'] = 'D&z%>C+R4=b5TCevL^8d*TyfgTy17kA(+(M?nE&<'
app.config['MYSQL_DB'] = 'eatRight_db'  

# Initialize MySQL
mysql = MySQL(app)
def register_user():
    username = request.json.get('username')
    password = request.json.get('password')  # Remember to hash the password in a real app

    cur = mysql.connection.cursor()
    cur.execute("INSERT INTO users (username, password) VALUES (%s, %s)", (username, password))
    mysql.connection.commit()
    cur.close()
    
    return jsonify({'message': 'User registered successfully!'}), 201

if __name__ == '__main__':
    app.run(debug=True)

