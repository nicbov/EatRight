import requests

class SpoonacularService:
    BASE_URL = 'https://api.spoonacular.com/recipes'
    API_KEY = 'your_api_key_here'  # Replace with your actual Spoonacular API key

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
