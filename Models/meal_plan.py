class MealPlan:
    def __init__(self):
        # Initialize the meal plan with empty lists for each day
        self.plan = {
            'Monday': [],
            'Tuesday': [],
            'Wednesday': [],
            'Thursday': [],
            'Friday': [],
            'Saturday': [],
            'Sunday': [],
        }

    def add_recipe(self, day, recipe):
        """Add a recipe to the specified day."""
        if day in self.plan:
            self.plan[day].append(recipe)
        else:
            print(f"Error: {day} is not a valid day.")

    def remove_recipe(self, day, recipe):
        """Remove a recipe from the specified day."""
        if day in self.plan and recipe in self.plan[day]:
            self.plan[day].remove(recipe)

    def get_recipes_for_day(self, day):
        """Return all recipes for a specific day."""
        return self.plan.get(day, [])

    def clear_day(self, day):
        """Clear all recipes for a specific day."""
        if day in self.plan:
            self.plan[day] = []

    def clear_all_days(self):
        """Clear all recipes from all days."""
        for day in self.plan:
            self.plan[day] = []
