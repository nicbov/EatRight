import mysql.connector
import os

# Establishing the MySQL connection
db_connection = mysql.connector.connect(
    host=os.environ.get('MYSQL_DATABASE_HOST', 'localhost'),
    port=int(os.environ.get('MYSQL_DATABASE_PORT', '3306')),
    user=os.environ.get('MYSQL_DATABASE_USER', 'root'),
    password=os.environ.get('MYSQL_DATABASE_PASSWORD', 'D&z%>C+R4=b5TCevL^8d*TyfgTy17kA(+(M?nE&<'),
    database=os.environ.get('MYSQL_DATABASE_DB', 'recipedb'),
)

cursor = db_connection.cursor()

# List of tables to clear
tables = ["instructions", "meals", "nutrition", "price", "taste"]

try:
    # Disable foreign key checks to avoid issues with dependent tables
    cursor.execute("SET FOREIGN_KEY_CHECKS = 0;")
    
    # Truncate each table
    for table in tables:
        print(f"Clearing table: {table}")
        cursor.execute(f"TRUNCATE TABLE {table};")
    
    # Re-enable foreign key checks
    cursor.execute("SET FOREIGN_KEY_CHECKS = 1;")
    
    db_connection.commit()
    print("All tables have been cleared successfully.")

except mysql.connector.Error as err:
    print(f"Error: {err}")

finally:
    cursor.close()
    db_connection.close()

