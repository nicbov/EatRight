from flask import Flask, jsonify, request, send_file
from flaskext.mysql import MySQL
from werkzeug.security import generate_password_hash
from io import BytesIO
from Charts import makeChart

app = Flask(__name__)

# MySQL Configuration
app.config['MYSQL_DATABASE_HOST'] = 'localhost'
app.config['MYSQL_DATABASE_USER'] = 'root'
app.config['MYSQL_DATABASE_PASSWORD'] = 'D&z%>C+R4=b5TCevL^8d*TyfgTy17kA(+(M?nE&<'
app.config['MYSQL_DATABASE_DB'] = 'recipedb'

# Initialize MySQL
mysql = MySQL()
mysql.init_app(app)

# Register User
@app.route('/register', methods=['POST'])
def register_user():
    conn = mysql.connect()
    cursor = conn.cursor()

    username = request.json.get('username')
    password = request.json.get('password')

    if not username or not password:
        return jsonify({'error': 'Username and password are required'}), 400

    hashed_password = generate_password_hash(password)
    try:
        cursor.execute("INSERT INTO users (username, password) VALUES (%s, %s)", (username, hashed_password))
        conn.commit()
        return jsonify({'message': 'User registered successfully'}), 201
    except Exception as e:
        print(f"Registration error: {str(e)}")
        return jsonify({'error': 'An error occurred while registering the user'}), 500
    finally:
        cursor.close()
        conn.close()

@app.route('/search_recipes', methods=['GET'])
def search_recipes():
    dish = request.args.get('dish', '').strip()  # Default to an empty string if not provided
    cuisine = request.args.get('cuisine', '').strip()  # Default to an empty string if not provided
    print(f"Received parameters - dish: {dish}, cuisine: {cuisine}")

    query = "SELECT id, title FROM meals WHERE 1=1"
    params = []

    if dish:
        query += " AND title LIKE %s"
        params.append(f"%{dish}%")  # Ensure this is correctly formatted for MySQL
    if cuisine:
        query += " AND cuisine = %s"
        params.append(cuisine)

    try:
        # Log query for debugging purposes
        print(f"Executing query: {query} with params: {params}")

        with mysql.connect() as conn:
            with conn.cursor() as cursor:
                cursor.execute(query, params)
                recipes = cursor.fetchall()
                recipe_list = [{"id": row[0], "title": row[1]} for row in recipes]

                if not recipe_list:
                    return jsonify({"error": "No recipes found matching the criteria."}), 404

                return jsonify(recipe_list), 200
    except Exception as e:
        logging.error(f"Database error: {e}")
        return jsonify({"error": "Failed to fetch recipes from database"}), 500

@app.route('/recipe/<int:recipe_id>', methods=['GET'])
def get_recipe_details(recipe_id):
    conn = mysql.connect()
    try:
        cursor = conn.cursor()

        # Fetch taste info
        cursor.execute("SELECT * FROM taste WHERE meal_id = %s", (recipe_id,))
        taste_info = cursor.fetchall()

        # Fetch price info
        cursor.execute("SELECT * FROM price WHERE meal_id = %s", (recipe_id,))
        price_info = cursor.fetchall()

        # Fetch instructions info
        cursor.execute("SELECT * FROM instructions WHERE meal_id = %s", (recipe_id,))
        instructions_info = cursor.fetchall()
        
        #fetch nutrition info
        cursor.execute("SELECT * FROM nutrition WHERE meal_id = %s", (recipe_id,))
        nutrition_info = cursor.fetchall()
        taste_info_list = []
        for row in taste_info:
            taste_info_list.append([
                {'Taste Metric': 'Sweetness', 'Value': row[2]},
                {'Taste Metric': 'Saltiness', 'Value': row[3]},
                {'Taste Metric': 'Sourness', 'Value': row[4]},
                {'Taste Metric': 'Bitterness', 'Value': row[5]},
                {'Taste Metric': 'Savoriness', 'Value': row[6]},
                {'Taste Metric': 'Fattiness', 'Value': row[7]},
                {'Taste Metric': 'Spiciness', 'Value': row[8]}
            ])
        taste_info_flat = [item for sublist in taste_info_list for item in sublist]

        # Build details dictionary
        details = {
    'taste_info': taste_info_flat,
    'price_info': [{'Ingredient': row[2], 'Price': row[4], 'Amount': row[3]} for row in price_info],
    'nutrition_info': [
        {
            'Name': row[2],  # 'Calories' (column 2)
            'Amount': float(row[3]),  # 450 (convert to float)
            'Unit': row[4],  # 'kcal'
            'PercentOfDailyNeeds': float(row[5])  # 22% -> 22.0
        } for row in nutrition_info
    ],
    'instructions_info': [{'Step': row[2], 'Description': row[3]} for row in instructions_info]  # Adjust column indices for instructions_info
}

        return jsonify(details), 200
    except Exception as e:
        print(f"Database error: {e}")
        return jsonify({'error': 'Failed to fetch recipe details from database'}), 500
    finally:
        cursor.close()
        conn.close()

# Recommend Recipes
@app.route('/recommend', methods=['POST'])
def recommend_recipes():
    recipe_ids = request.json.get('recipe_ids', [])
    conn = mysql.connect()
    cursor = conn.cursor()

    try:
        query = """
        SELECT id, title 
        FROM meals 
        WHERE id NOT IN (%s) 
        ORDER BY RAND() 
        LIMIT 5
        """ % ','.join(['%s'] * len(recipe_ids))

        cursor.execute(query, recipe_ids)
        recommendations = cursor.fetchall()
        recommendation_list = [{"id": row[0], "title": row[1]} for row in recommendations]
        return jsonify(recommendation_list), 200
    except Exception as e:
        print(f"Database error: {e}")
        return jsonify({'error': 'Failed to fetch recommendations from database'}), 500
    finally:
        cursor.close()
        conn.close()

# Taste Chart
@app.route('/taste_chart', methods=['POST'])
def taste_chart():
    data = request.get_json()
    taste_info = data.get("taste_info", [])
    labels = [item["Taste Metric"] for item in taste_info]
    values = [item["Value"] for item in taste_info]

    img_bytes = makeChart(labels, values)
    return send_file(img_bytes, mimetype='image/svg+xml')

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=4000)

