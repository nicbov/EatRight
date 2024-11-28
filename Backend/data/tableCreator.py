import mysql.connector
import os

# Establishing the MySQL connection
db = mysql.connector.connect(
    host=os.environ.get('MYSQL_DATABASE_HOST', 'localhost'),
    port=int(os.environ.get('MYSQL_DATABASE_PORT', '3306')),
    user=os.environ.get('MYSQL_DATABASE_USER', 'root'),
    password=os.environ.get('MYSQL_DATABASE_PASSWORD', 'D&z%>C+R4=b5TCevL^8d*TyfgTy17kA(+(M?nE&<'),
    database=os.environ.get('MYSQL_DATABASE_DB', 'recipedb'),
)

cursor = db.cursor()

# SQL Statements to create tables
tables = {
    "meals": """
        CREATE TABLE IF NOT EXISTS meals (
            id INT AUTO_INCREMENT PRIMARY KEY,
            title VARCHAR(255) NOT NULL,
            totalCost DOUBLE DEFAULT NULL,
            totalCostPerServing DOUBLE DEFAULT NULL,
            cuisine VARCHAR(50) DEFAULT NULL
        );
    """,
    "nutrition": """
        CREATE TABLE IF NOT EXISTS nutrition (
            id INT AUTO_INCREMENT PRIMARY KEY,
            meal_id INT NOT NULL,
            name VARCHAR(255) NOT NULL,
            amount DOUBLE DEFAULT NULL,
            unit VARCHAR(50) DEFAULT NULL,
            percentOfDailyNeeds DOUBLE DEFAULT NULL,
            FOREIGN KEY (meal_id) REFERENCES meals(id)
        );
    """,
    "price": """
        CREATE TABLE IF NOT EXISTS price (
            id INT AUTO_INCREMENT PRIMARY KEY,
            meal_id INT NOT NULL,
            name VARCHAR(255) NOT NULL,
            amount VARCHAR(255) DEFAULT NULL,
            price DOUBLE NOT NULL,
            FOREIGN KEY (meal_id) REFERENCES meals(id)
        );
    """,
    "taste": """
        CREATE TABLE IF NOT EXISTS taste (
            id INT AUTO_INCREMENT PRIMARY KEY,
            meal_id INT NOT NULL,
            sweetness DOUBLE DEFAULT NULL,
            saltiness DOUBLE DEFAULT NULL,
            sourness DOUBLE DEFAULT NULL,
            bitterness DOUBLE DEFAULT NULL,
            savoriness DOUBLE DEFAULT NULL,
            fattiness DOUBLE DEFAULT NULL,
            spiciness DOUBLE DEFAULT NULL,
            FOREIGN KEY (meal_id) REFERENCES meals(id)
        );
    """,
    "instructions": """
        CREATE TABLE IF NOT EXISTS instructions (
            id INT AUTO_INCREMENT PRIMARY KEY,
            meal_id INT NOT NULL,
            step INT NOT NULL,
            instruction TEXT NOT NULL,
            FOREIGN KEY (meal_id) REFERENCES meals(id)
        );
    """
}

# Execute SQL statements
for table_name, create_statement in tables.items():
    try:
        cursor.execute(create_statement)
        print(f"Table `{table_name}` created successfully.")
    except mysql.connector.Error as err:
        print(f"Error creating table `{table_name}`: {err}")

# Close the connection
cursor.close()
db.close()

