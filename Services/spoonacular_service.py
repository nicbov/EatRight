import requests
import pandas as pd
import os

class SpoonacularService:
    BASE_URL = os.environ.get('SPOON_BASE_URL', 'https://api.spoonacular.com/recipes')
    API_KEY = os.environ.get('SPOON_KEY')  # Replace with your actual Spoonacular API key
    
    def get_recipe(self, dish=None, cuisine=None, diet=None, intolerance=None):
        url = f'{self.BASE_URL}/complexSearch'
        headers = {'x-api-key': self.API_KEY}
        params = {}
        if dish is not None:  # Only add if not None
            params['query'] = dish
        if cuisine is not None:
            params['cuisine'] = cuisine
        if diet is not None:
            params['diet'] = diet
        if intolerance is not None:
            params['intolerances'] = intolerance
        r = requests.get(url, headers=headers, params=params)
        if r.status_code == 200:
            jstring = r.json()
            recipe_frame = pd.json_normalize(jstring['results'])
        else:
            print(f"Error: Unable to fetch recipes. Status code {r.status_code}")
            recipe_frame = pd.DataFrame()
        return recipe_frame

    def get_taste(self, recipe_id):
        url = f'{self.BASE_URL}/{recipe_id}/tasteWidget.json'
        headers = {'x-api-key': self.API_KEY}
        response = requests.get(url, headers=headers)
        if response.status_code == 200:
            return response.json()
        else:
            print(f"Error: Unable to fetch taste data for recipe {recipe_id}")
            return None

    def get_nutrition(self, recipe_id):
        url = f'{self.BASE_URL}/{recipe_id}/nutritionWidget.json'
        headers = {'x-api-key': self.API_KEY}
        response = requests.get(url, headers=headers)
        if response.status_code == 200:
            return response.json()
        else:
            print(f"Error: Unable to fetch nutrition data for recipe {recipe_id}")
            return None

    def get_price(self, recipe_id):
        url = f'{self.BASE_URL}/{recipe_id}/priceBreakdownWidget.json'
        headers = {'x-api-key': self.API_KEY}
        response = requests.get(url, headers=headers)
        if response.status_code == 200:
            return response.json()
        else:
            print(f"Error: Unable to fetch price data for recipe {recipe_id}")
            return None

    def get_instructions(self, recipe_id):
        url = f'{self.BASE_URL}/{recipe_id}/analyzedInstructions'
        headers = {'x-api-key': self.API_KEY}
        response = requests.get(url, headers=headers)
        if response.status_code == 200:
            return response.json()
        else:
            print(f"Error: Unable to fetch instructions for recipe {recipe_id}")
            return None
