import mysql.connector
import csv
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

# Helper function to insert data into the database
def insert_data_from_csv(file_path, table_name, columns):
    with open(file_path, mode='r') as file:
        csv_reader = csv.DictReader(file)
        
        for row in csv_reader:
            # Prepare the SQL query
            column_names = ", ".join(columns)
            placeholders = ", ".join(["%s"] * len(columns))
            sql = f"INSERT INTO {table_name} ({column_names}) VALUES ({placeholders})"
            
            # Prepare the data tuple to insert
            data = tuple(row[col] for col in columns)
            
            # Execute the query
            cursor.execute(sql, data)
        
        # Commit the changes
        db_connection.commit()
# Inserting data from the updated Recipes.csv
insert_data_from_csv(os.path.join('Recipes.csv'), 'meals', ['id', 'title', 'totalCost', 'totalCostPerServing', 'cuisine'])

# Inserting data from the Instructions.csv (no changes needed here)
insert_data_from_csv(os.path.join('Instructions.csv'), 'instructions', ['id', 'meal_id', 'step', 'instruction'])

insert_data_from_csv(os.path.join("Nutrition.csv"), "nutrition", ["id", "meal_id", "name", "amount", "unit", "percentOfDailyNeeds"])

insert_data_from_csv(os.path.join("Price.csv"), "price", ["id", "meal_id", "name", "amount", "price"])

insert_data_from_csv(os.path.join("Taste.csv"), "taste", ["id", "meal_id", "sweetness", "saltiness", "sourness", "bitterness", "savoriness", "fattiness", "spiciness"])
cursor.close()
db_connection.close()

print("CSV data inserted successfully into the database!")

