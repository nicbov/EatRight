//
//  SearchView.swift
//  eatRight
//
//  Created by Max Boving on 9/30/24.
//


import SwiftUI

struct SearchView: View {
    @State private var searchText: String = ""
    @State private var recipes: [Recipe] = [] // Define your Recipe model

    var body: some View {
        VStack {
            TextField("Search for recipes...", text: $searchText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            Button(action: {
                // Call API to fetch recipes based on searchText
                fetchRecipes(query: searchText)
            }) {
                Text("Search")
            }
            .padding()

            List(recipes, id: \.recipe_id) { recipe in
                NavigationLink(destination: RecipeDetailView(recipe: recipe)) {
                    Text(recipe.title) // Assuming `Recipe` has a `title` property
                }
            }
        }
        .navigationTitle("Search Recipes")
    }

    func fetchRecipes(query: String) {
        // Implement the API call to fetch recipes based on the query
    }
}
