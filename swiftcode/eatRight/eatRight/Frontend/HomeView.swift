//
//  HomeView.swift
//  eatRight
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
	@State private var isDetailPresented: Bool = false
	@State private var selectedRecipeTitle: String = ""

	var switchToFavorites: () -> Void
	private let recipeService = RecipeService()

	var body: some View {
		NavigationView {
			ZStack {
				LinearGradient(gradient: Gradient(colors: [Color.green.opacity(0.6), Color.blue.opacity(0.3)]),
							   startPoint: .topLeading, endPoint: .bottomTrailing)
					.ignoresSafeArea()

				GeometryReader { geometry in
					VStack {
						HStack {
							TextField("Search for recipes...", text: $searchText)
								.textFieldStyle(RoundedBorderTextFieldStyle())
								.frame(height: 50)
								.padding(8)
								.background(Color.white.opacity(0.9))
								.cornerRadius(10)
								.overlay(RoundedRectangle(cornerRadius: 10)
											.stroke(Color.orange, lineWidth: 2))
						}
						.padding(.horizontal)

						Button(action: {
							fetchRecipes()
						}) {
							Text("Fetch Recipes")
								.fontWeight(.bold)
								.padding()
								.frame(maxWidth: .infinity)
								.background(Color.orange)
								.foregroundColor(.white)
								.cornerRadius(10)
								.shadow(color: Color.gray.opacity(0.5), radius: 5, x: 0, y: 3)
						}
						.padding(.horizontal)
						.padding(.bottom, 10)

						Button(action: {
							showFilters.toggle()
						}) {
							Text("Filters")
								.fontWeight(.bold)
								.padding()
								.frame(maxWidth: .infinity)
								.background(Color.white)
								.foregroundColor(.orange)
								.cornerRadius(10)
								.overlay(RoundedRectangle(cornerRadius: 10)
											.stroke(Color.orange, lineWidth: 2))
								.shadow(color: Color.gray.opacity(0.5), radius: 5, x: 0, y: 3)
						}
						.padding(.horizontal)
						.padding(.bottom, 10)

						if showFilters {
							VStack(spacing: 10) {
								createFilterSlider(label: "Protein", value: $protein)
								createFilterSlider(label: "Carbs", value: $carbs)
								createFilterSlider(label: "Fats", value: $fats)
							}
							.background(Color.white.opacity(0.9))
							.cornerRadius(10)
							.overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.orange, lineWidth: 2))
							.padding(.bottom, 10)
						}

						if isLoading {
							ProgressView("Loading recipes...")
								.padding()
								.foregroundColor(.orange)
						} else if let errorMessage = errorMessage {
							Text("Error: \(errorMessage)")
								.foregroundColor(.red)
								.padding()
						} else {
							VStack {
								if !recipes.isEmpty {
									ForEach(recipes) { recipe in
										Button(action: {
											fetchRecipeDetails(recipeId: recipe.id) { detail in
												selectedRecipeDetail = detail
												selectedRecipeTitle = recipe.title
												print("Selected Recipe: \(selectedRecipeTitle)") // Debugging
												isDetailPresented = true
											}
										}) {
											Text(recipe.title)
												.fontWeight(.bold)
												.padding()
												.frame(maxWidth: .infinity)
												.background(Color.white)
												.foregroundColor(.orange)
												.cornerRadius(10)
												.overlay(RoundedRectangle(cornerRadius: 10)
															.stroke(Color.orange, lineWidth: 2))
												.shadow(color: Color.gray.opacity(0.5), radius: 5, x: 0, y: 3)
										}
										.padding(.horizontal)
									}
								} else {
									Text("No recipes found.")
										.padding()
										.foregroundColor(.gray)
								}
							}
						}
					}
					.padding(.top, 10)
				}
			}
		}
		.background(NavigationLink(destination: MealDetailView(mealDetail: selectedRecipeDetail, mealTitle: selectedRecipeTitle), isActive: $isDetailPresented) { EmptyView() })
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
		.background(Color.white.opacity(0.8))
		.cornerRadius(10)
		.overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.orange, lineWidth: 2))
	}
}

// Preview for HomeView
struct HomeView_Previews: PreviewProvider {
	@State static var showingProfile = false

	static var previews: some View {
		HomeView(showingProfile: $showingProfile, switchToFavorites: {})
			.preferredColorScheme(.light)
	}
}
