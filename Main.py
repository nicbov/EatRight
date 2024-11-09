from flask import Flask, jsonify, request
from flaskext.mysql import MySQL

import flask_mysqldb
from werkzeug.security import generate_password_hash
from Services.reccomendation_model import RecommendationModel  # Add this line

from Services.spoonacular_service import SpoonacularService
from Models.recipe import Recipe

app = Flask(__name__)

# MySQL Configuration
app.config['MYSQL_DATABASE_HOST'] = 'localhost'
app.config['MYSQL_DATABASE_USER'] = 'root'
app.config['MYSQL_DATABASE_PASSWORD'] = 'D&z%>C+R4=b5TCevL^8d*TyfgTy17kA(+(M?nE&<'
app.config['MYSQL_DATABASE_DB'] = 'eatRight_db'

# Initialize MySQL
mysql = MySQL()
mysql.init_app(app)


# Register User
@app.route('/register', methods=['POST', 'GET'])
def register_user():
    conn = mysql.connect()
    cursor =conn.cursor()

    cursor.execute("SELECT * from users")
    data = cursor.fetchone()
    print(data)

    if mysql.connect:
        print("Connected to MySQL database")
    else:
    
        return jsonify({'error': 'MySQL connection not established'}), 500
    username = request.json.get('username')
    password = request.json.get('password')

    if not username or not password:
        return jsonify({'error': 'Username and password are required'}), 400

    hashed_password = generate_password_hash(password)  # Hash the password
    try:
        cur = mysql.connect.cursor()
        cur.execute("INSERT INTO users (username, password) VALUES (%s, %s)", (username, hashed_password))
        mysql.connect.commit()
        cur.close()
        return jsonify({'message': 'User registered successfully'}), 201
    except Exception as e:
        # Log the error to the console for debugging
        print(f"Registration error: {str(e)}")
        return jsonify({'error': 'An error occurred while registering the user'}), 500

# Search Recipes
@app.route('/search_recipes', methods=['GET'])
def search_recipes():
    # Get optional parameters from the request
    dish = request.args.get('dish')
    cuisine = request.args.get('cuisine')
    diet = request.args.get('diet')
    intolerance = request.args.get('intolerance')
    service = SpoonacularService()
    print(f'dish: {dish}, cuisine: {cuisine}, diet: {diet}, intolerance: {intolerance}')

    # Call the get_recipe function with the user's input
    recipes = service.get_recipe(dish=dish, cuisine=cuisine, diet=diet, intolerance=intolerance)
    # Call the get_recipe function with the user's input
    print(f'{recipes}')
    # If no recipes were found, return an error message
    if recipes.empty:
        return jsonify({'error': 'No recipes found'}), 404
    recipes_with_id = recipes[['id', 'title']]
    return jsonify(recipes_with_id.to_dict(orient='records')), 200

# Get Recipe Details
@app.route('/recipe/<int:recipe_id>', methods=['GET'])
def get_recipe_details(recipe_id):
    # Instantiate the Recipe class with the selected recipe ID
    recipe = Recipe(spoon_service=SpoonacularService(), recipe_id=recipe_id, title="")

    # Fetch recipe details using the methods defined in the Recipe class
    recipe.fetch_taste()
    recipe.fetch_nutrition()
    recipe.fetch_price()
    recipe.fetch_instructions()

    # Construct a response with all the available details
    details = {
        'taste_info': recipe.taste_info.to_dict(orient='records'),  # Return taste info
        'nutrition_info': recipe.nutrition_info.to_dict(orient='records'),  #[:4] Limit to first 4 nutrition items
        'price_info': recipe.price_info.to_dict(orient='records'),  # Return price info
        'instructions_info': recipe.instructions_info.to_dict(orient='records')  # Return all instructions
    }
    return jsonify(details), 200
@app.route('/recommend', methods=['POST'])
def recommend_recipes():
    recipe_ids = request.json.get('recipe_ids', [])
    model = RecommendationModel()
    recommendations = model.get_taste_info(recipe_ids)
    return jsonify(recommendations), 200


if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=3000)
