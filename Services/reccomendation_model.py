import pandas as pd
from Services.spoonacular_service import SpoonacularService

class RecommendationModel:
    def __init__(self):
        self.spoon_service = SpoonacularService()

    def get_taste_info(self, recipe_ids):
        """Fetches taste information for a list of recipe IDs and makes recommendations."""
        taste_info_list = []

        for recipe_id in recipe_ids:
            taste_data = self.spoon_service.get_taste(recipe_id)
            if taste_data:
                taste_info_list.append(taste_data)

        # Combine the taste metrics and average them or make recommendations based on them
        combined_tastes = self.combine_taste_info(taste_info_list)
        print(f'{combined_tastes}')
        return combined_tastes

    def combine_taste_info(self, taste_info_list):
        """Combines and averages the taste metrics."""
        # Initialize a dictionary to hold aggregated values
        aggregated_tastes = {}

        for taste_info in taste_info_list:
            for metric, value in taste_info.items():
                if metric in aggregated_tastes:
                    aggregated_tastes[metric].append(value)
                else:
                    aggregated_tastes[metric] = [value]
