import openai
import csv
import time  # Import time module

# Set your OpenAI API key here
openai.api_key = "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"

# Broad context for the chef
context = """
The meals should be balanced and promote energy for a busy college lifestyle.
"""

# Function to generate recipe data for each table
def generate_recipe_data():
    # Prompt for Recipes.csv data
    recipes_prompt = """
    Please generate a list of recipes with the following columns:
    id, title, totalCost, totalCostPerServing, cuisine.
    The recipes should be healthy, easy to prepare, and affordable for college students.
    Example format:
    id, title, totalCost, totalCostPerServing, cuisine
    1, Spaghetti Carbonara, 15.50, 3.10, Italian
    """
    recipes_data = openai.ChatCompletion.create(  # Correct method for the latest API version
        model="gpt-3.5-turbo",
        messages=[{"role": "system", "content": context},
                  {"role": "user", "content": recipes_prompt}],
        max_tokens=500,
        temperature=0.7
    )

    # Extract the recipes data from the OpenAI response
    recipes = recipes_data['choices'][0]['message']['content'].strip().split("\n")

    # Write to Recipes.csv
    with open("Recipes.csv", mode="w", newline="") as file:
        writer = csv.writer(file)
        writer.writerow(["id", "title", "totalCost", "totalCostPerServing", "cuisine"])
        for recipe in recipes:
            writer.writerow(recipe.split(","))

    # Wait for 20 seconds before the next request
    time.sleep(20)

    # Prompt for Instructions.csv data
    instructions_prompt = """
    Please generate instructions with the following columns:
    id, meal_id, step, instruction.
    These should be simple, clear steps suitable for young, active college students.
    Example format:
    id, meal_id, step, instruction
    1, 1, 1, Boil spaghetti according to package instructions.
    """
    instructions_data = openai.ChatCompletion.create(  # Correct method for the latest API version
        model="gpt-3.5-turbo",
        messages=[{"role": "system", "content": context},
                  {"role": "user", "content": instructions_prompt}],
        max_tokens=500,
        temperature=0.7
    )

    # Extract instructions data
    instructions = instructions_data['choices'][0]['message']['content'].strip().split("\n")

    # Write to Instructions.csv
    with open("Instructions.csv", mode="w", newline="") as file:
        writer = csv.writer(file)
        writer.writerow(["id", "meal_id", "step", "instruction"])
        for instruction in instructions:
            writer.writerow(instruction.split(","))

    # Wait for 20 seconds before the next request
    time.sleep(20)

    # Prompt for Nutrition.csv data
    nutrition_prompt = """
    Please generate nutritional information with the following columns:
    id, meal_id, name, amount, unit, percentOfDailyNeeds.
    The nutritional info should be tailored to young college students who need balanced, energizing meals.
    Example format:
    id, meal_id, name, amount, unit, percentOfDailyNeeds
    1, 1, Calories, 600, kcal, 30
    """
    nutrition_data = openai.ChatCompletion.create(  # Correct method for the latest API version
        model="gpt-3.5-turbo",
        messages=[{"role": "system", "content": context},
                  {"role": "user", "content": nutrition_prompt}],
        max_tokens=500,
        temperature=0.7
    )

    # Extract nutritional information
    nutrition = nutrition_data['choices'][0]['message']['content'].strip().split("\n")

    # Write to Nutrition.csv
    with open("Nutrition.csv", mode="w", newline="") as file:
        writer = csv.writer(file)
        writer.writerow(["id", "meal_id", "name", "amount", "unit", "percentOfDailyNeeds"])
        for nutrient in nutrition:
            writer.writerow(nutrient.split(","))

    # Wait for 20 seconds before the next request
    time.sleep(20)

    # Prompt for Taste.csv data
    taste_prompt = """
    Please generate taste information with the following columns:
    id, meal_id, sweetness, saltiness, sourness, bitterness, savoriness, fattiness, spiciness.
    The taste data should reflect flavors young college students would enjoy in healthy meals.
    Example format:
    id, meal_id, sweetness, saltiness, sourness, bitterness, savoriness, fattiness, spiciness
    1, 1, 28.79, 26.74, 6.22, 12.38, 11.80, 100, 0
    """
    taste_data = openai.ChatCompletion.create(  # Correct method for the latest API version
        model="gpt-3.5-turbo",
        messages=[{"role": "system", "content": context},
                  {"role": "user", "content": taste_prompt}],
        max_tokens=500,
        temperature=0.7
    )

    # Extract taste data
    taste = taste_data['choices'][0]['message']['content'].strip().split("\n")

    # Write to Taste.csv
    with open("Taste.csv", mode="w", newline="") as file:
        writer = csv.writer(file)
        writer.writerow(["id", "meal_id", "sweetness", "saltiness", "sourness", "bitterness", "savoriness", "fattiness", "spiciness"])
        for taste_row in taste:
            writer.writerow(taste_row.split(","))

    # Wait for 20 seconds before the next request
    time.sleep(20)

# Running the function
if __name__ == "__main__":
    generate_recipe_data()

