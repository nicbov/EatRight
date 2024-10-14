//
//  HomeView.swift
//  eatRight
//
//  Created by Nicolas Boving on 10/3/24.
import SwiftUI

struct HomeView: View {
	@State private var protein: Double = 50
	@State private var carbs: Double = 50
	@State private var fats: Double = 50
	@State private var searchText: String = ""
	@Binding var showingProfile: Bool // Binding for profile popup
	@State private var showFilters: Bool = false // State for filter pop-up
	@State private var showingMyMeals: Bool = false // State for My Meals view
	var switchToFavorites: () -> Void // Callback to switch to Favorites

	var body: some View {
		GeometryReader { geometry in
			VStack {
				// Apply filters button
				Button(action: {
					showFilters.toggle() // Toggle filters
				}) {
					Text("Apply Filters")
						.font(.subheadline) // Smaller font size
						.padding(5) // Reduced padding
						.background(Color.green)
						.foregroundColor(.white)
						.cornerRadius(10)
				}
				.padding(.leading, 10) // Padding for left alignment

				// Search bar
				HStack {
					TextField("Search for recipes...", text: $searchText)
						.textFieldStyle(RoundedBorderTextFieldStyle())
						.padding(.horizontal)
						.frame(height: 50) // Increased height for the search bar
				}
				.padding(.top)

				// Filter Sliders (only show when filters are active)
				if showFilters {
					createFilterSlider(label: "Protein", value: $protein)
					createFilterSlider(label: "Carbs", value: $carbs)
					createFilterSlider(label: "Fats", value: $fats)
				}

				// My Meals view (conditional)
				if showingMyMeals {
					VStack {
						Text("My Meals")
							.font(.largeTitle)
							.padding()

						// Example array for meals
						let meals = ["Meal 1", "Meal 2", "Meal 3"] // Replace with actual meal data

						// Check if meals exist
						if !meals.isEmpty {
							ForEach(meals, id: \.self) { meal in
								NavigationLink(destination: MealDetailView(mealName: meal)) {
									Text(meal)
										.font(.subheadline) // Smaller font size for meal names
										.padding()
										.background(Color.white)
										.cornerRadius(10)
										.shadow(color: Color.gray.opacity(0.3), radius: 5, x: 0, y: 3)
								}
								.padding(.bottom)
							}
						} else {
							Text("No Selected Meals")
								.font(.headline)
								.foregroundColor(.gray)
						}
					}
					.padding()
					.frame(maxWidth: geometry.size.width * 0.25) // Limit width to left 1/4 of the screen
					.padding(.top, 10) // Space above My Meals section
				}

				Spacer() // Add space to push content up
			}
			.padding(.horizontal) // Add padding to the edges
		}
	}

	// Helper function to create tab buttons
	private func createTabButton(title: String, action: @escaping () -> Void) -> some View {
		Button(title) {
			action()
		}
		.font(.headline)
		.frame(maxWidth: .infinity)
		.padding()
		.foregroundColor(.green)
		.background(Color.white)
		.cornerRadius(5)
	}

	// Helper function to create filter sliders
	private func createFilterSlider(label: String, value: Binding<Double>) -> some View {
		VStack(alignment: .leading) {
			Text("\(label): \(Int(value.wrappedValue))g")
			Slider(value: value, in: 0...100, step: 1)
				.accentColor(.green)
		}
		.padding()
	}
}

// Preview for HomeView
struct HomeView_Previews: PreviewProvider {
	@State static var showingProfile: Bool = false // Static binding for preview

	static var previews: some View {
		HomeView(showingProfile: $showingProfile, switchToFavorites: {
			print("Switching to Favorites") // Preview action
		})
		.previewLayout(.sizeThatFits)
	}
}
