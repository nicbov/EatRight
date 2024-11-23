#recipe.py
from Services.spoonacular_service import SpoonacularService
import pandas as pd

class Recipe:
    def __init__(self, spoon_service, recipe_id, title):
        self.recipe_id = recipe_id
        self.title = title
        self.taste_info = None
        self.nutrition_info = None
        self.price_info = None
        self.instructions_info = None
        self.spoon_service = spoon_service
# Recipe(SpoonacularService(), id, title)
    def fetch_taste(self):
        taste_data = self.spoon_service.get_taste(self.recipe_id)
        if taste_data:
            self.taste_info = pd.DataFrame(taste_data.items(), columns=['Taste Metric', 'Value'])
        else:
            self.taste_info = pd.DataFrame()

    def fetch_nutrition(self):
        nutrition_data = self.spoon_service.get_nutrition(self.recipe_id)
        if nutrition_data and "nutrients" in nutrition_data:
            nutrients = nutrition_data["nutrients"]
        
            self.nutrition_info = pd.DataFrame(nutrients)
        else:
            self.nutrition_info = pd.DataFrame()


    def fetch_price(self):
        price_data = self.spoon_service.get_price(self.recipe_id)
        if price_data:
            price_info = [{'Name': ing['name'], 'Amount': ing['amount']['us']['value'], 'Price': ing['price']} for ing in price_data['ingredients']]
            self.price_info = pd.DataFrame(price_info)
            total_cost = price_data.get('totalCost', 0)
            total_cost_per_serving = price_data.get('totalCostPerServing', 0)

            self.price_info = pd.concat([
            self.price_info,
            pd.DataFrame([{'Name': 'Total Cost', 'Amount': 1.0, 'Price': total_cost}]),
            pd.DataFrame([{'Name': 'Cost per Serving', 'Amount': 1.0, 'Price': total_cost_per_serving}])
            ], ignore_index=True)
        else:
            self.price_info = pd.DataFrame()
        

    def fetch_instructions(self):
        instructions_data = self.spoon_service.get_instructions(self.recipe_id)
        if instructions_data:
            instructions_info = []
            for instruction in instructions_data:
                for step in instruction['steps']:
                    instructions_info.append({'Step': step['number'], 'Instruction': step['step']})
            self.instructions_info = pd.DataFrame(instructions_info)
        else:
            self.instructions_info = pd.DataFrame()
