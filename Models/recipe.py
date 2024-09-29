#recipe.py
from services.spoonacular_service import SpoonacularService
import pandas as pd

class Recipe:
    def __init__(self, recipe_id, title):
        self.recipe_id = recipe_id
        self.title = title
        self.taste_info = None
        self.nutrition_info = None
        self.price_info = None
        self.instructions_info = None

    def fetch_taste(self):
        spoon_service = SpoonacularService()
        taste_data = spoon_service.get_taste(self.recipe_id)
        if taste_data:
            self.taste_info = pd.DataFrame(taste_data.items(), columns=['Taste Metric', 'Value'])
        else:
            self.taste_info = pd.DataFrame()
        return self.taste_info

    def fetch_nutrition(self):
        spoon_service = SpoonacularService()
        nutrition_data = spoon_service.get_nutrition(self.recipe_id)
        if nutrition_data:
            self.nutrition_info = pd.DataFrame(nutrition_data.items(), columns=['Nutrition Metric', 'Value'])
        else:
            self.nutrition_info = pd.DataFrame()
        return self.nutrition_info

    def fetch_price(self):
        spoon_service = SpoonacularService()
        price_data = spoon_service.get_price(self.recipe_id)
        if price_data:
            price_info = [{'Name': ing['name'], 'Amount': ing['amount']['us']['value'], 'Price': ing['price']} for ing in price_data['ingredients']]
            self.price_info = pd.DataFrame(price_info)
        else:
            self.price_info = pd.DataFrame()
        return self.price_info

    def fetch_instructions(self):
        spoon_service = SpoonacularService()
        instructions_data = spoon_service.get_instructions(self.recipe_id)
        if instructions_data:
            instructions_info = []
            for instruction in instructions_data:
                for step in instruction['steps']:
                    instructions_info.append({'Step': step['number'], 'Instruction': step['step']})
            self.instructions_info = pd.DataFrame(instructions_info)
        else:
            self.instructions_info = pd.DataFrame()
        return self.instructions_info