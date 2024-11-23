//
//  HomeView.swift
//
//  Created by Nicolas Boving on 10/3/24.
import SwiftUI

struct HomeView: View {
	@State private var protein: Double = 100
	@State private var carbs: Double = 100
	@State private var fats: Double = 100
	@State private var searchText: String = ""
	@Binding var showingProfile: Bool
	@State private var showFilters: Bool = false
	@State private var recipes: [Recipe] = []
	@State private var isLoading: Bool = false
	@State private var errorMessage: String?
	@State private var selectedRecipeDetail: MealDetail? = nil
	@EnvironmentObject var mealsData: MealsData
	@State private var selectedRecipeTitle: String = ""

	var switchToFavorites: () -> Void
	private let recipeService = RecipeService()

	var body: some View {
		VStack {
			// Adjusted padding for better spacing around content
			TextField("Search for recipes...", text: $searchText)
				.textFieldStyle(RoundedBorderTextFieldStyle())
				.padding(.horizontal)

			Button(action: fetchRecipes) {
				Text("Fetch Recipes")
					.fontWeight(.bold)
					.padding()
					.frame(maxWidth: .infinity)
					.background(Color.orange)
					.foregroundColor(.white)
					.cornerRadius(10)
			}
			.padding(.horizontal)

			Button(action: { showFilters.toggle() }) {
				Text("Filters")
					.fontWeight(.bold)
					.padding()
					.frame(maxWidth: .infinity)
					.background(Color.white)
					.foregroundColor(.orange)
					.cornerRadius(10)
					.overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.orange, lineWidth: 2))
			}
			.padding(.horizontal)

			if showFilters {
				VStack(spacing: 10) {
					createFilterSlider(label: "Protein", value: $protein)
					createFilterSlider(label: "Carbs", value: $carbs)
					createFilterSlider(label: "Fats", value: $fats)
				}
				.padding()
			}

			if isLoading {
				ProgressView("Loading recipes...")
			} else if let errorMessage = errorMessage {
				Text("Error: \(errorMessage)")
					.foregroundColor(.red)
			} else if recipes.isEmpty {
				Text("No recipes found.")
					.foregroundColor(.gray)
			} else {
				List(recipes, id: \.id) { recipe in
					NavigationLink(destination: MealDetailView(mealDetail: selectedRecipeDetail, mealTitle: selectedRecipeTitle)
						.onAppear {
							fetchRecipeDetails(recipeId: recipe.id) { detail in
								selectedRecipeDetail = detail
								selectedRecipeTitle = recipe.title
							}
						}
						.environmentObject(mealsData)) {
						Text(recipe.title)
					}
				}
			}
		}
		.padding(.top, 0) // Remove extra top padding or reduce if needed
	}

	private func fetchRecipes() {
		isLoading = true
		recipeService.fetchRecipes(dish: searchText, cuisine: nil, diet: nil, intolerance: nil) { result in
			DispatchQueue.main.async {
				isLoading = false
				switch result {
				case .success(let fetchedRecipes):
					recipes = fetchedRecipes
					errorMessage = nil
				case .failure(let error):
					errorMessage = error.localizedDescription
				}
			}
		}
	}

	private func fetchRecipeDetails(recipeId: Int, completion: @escaping (MealDetail) -> Void) {
		recipeService.fetchRecipeDetails(recipeId: recipeId) { result in
			switch result {
			case .success(let detail):
				completion(detail)
			case .failure(let error):
				print("Failed to fetch recipe details: \(error.localizedDescription)")
			}
		}
	}

	private func createFilterSlider(label: String, value: Binding<Double>) -> some View {
		HStack {
			Text(label)
			Slider(value: value, in: 0...500, step: 1)
			Text("\(Int(value.wrappedValue))")
		}
		.padding()
	}
}
