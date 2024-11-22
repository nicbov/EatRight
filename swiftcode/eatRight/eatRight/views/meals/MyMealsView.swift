//
//  MyMealsView.swift
//  eatRight
//
//  Created by Nicolas Boving on 10/13/24.
//
import SwiftUI

struct MyMealsView: View {
	// Access meals data from the environment
	@EnvironmentObject var mealsData: MealsData
	
	// To store the selected meal for showing details in the sheet
	@State private var selectedMeal: MealWithDetails?
	
	var body: some View {
		VStack {
			Text("My Meals")
				.font(.system(size: 34, weight: .bold))
				.foregroundColor(Color.green) // Green color for the title
				.padding(.top, 20)
				.padding(.bottom, 10)
			
			// Display the meals list from mealsData
			List(mealsData.meals) { meal in
				Button(action: {
					// When a button is pressed, assign the selected meal
					selectedMeal = meal
				}) {
					HStack {
						Text(meal.title)  // Display the meal title
							.font(.title2)
							.foregroundColor(.black) // Black color for text
							.padding(.vertical, 10)
							.padding(.leading, 15)
						
						Spacer()
					}
					.background(Color.orange.opacity(0.1)) // Orange background for the list item
					.cornerRadius(10)
					.shadow(radius: 5) // Add a shadow effect to the list item
					.padding(.horizontal)
					.transition(.scale) // Add transition effect for better interaction
				}
				.buttonStyle(PlainButtonStyle())  // Avoid default button styling
			}
			.listStyle(PlainListStyle()) // Clean list style with no extra separators
		}
		.padding(.horizontal)
		.sheet(item: $selectedMeal) { meal in
			// Show MealDetailView with the selected meal
			MealDetailView(mealDetail: meal.mealDetail, mealTitle: meal.title)
		}
		.background(Color.white.edgesIgnoringSafeArea(.all)) // Background color for the whole view
	}
}

struct MyMealsView_Previews: PreviewProvider {
	static var previews: some View {
		MyMealsView()
			.environmentObject(MealsData()) // Provide environment object in preview
	}
}
