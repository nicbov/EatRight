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

	var body: some View {
		GeometryReader { geometry in
			VStack {
				// Full-width logo with green outline and rounded corners
				Image("Image")
					.resizable()
					.scaledToFit()
					.frame(width: geometry.size.width * 0.8, height: geometry.size.height * 0.08)
					.overlay(RoundedRectangle(cornerRadius: 10)
						.stroke(Color.green, lineWidth: 2))
					.padding(.top, 10)

				// Tabs HStack including Profile in one long box, with vertical separators
				HStack(spacing: 0) {
					Group {
						// Tab: Home
						Button("Home") {
							// Action for home tab
						}
						.font(.headline)
						.frame(maxWidth: .infinity)
						.padding()
						.foregroundColor(.green)

						// Vertical separator
						Divider()
							.frame(height: 40)
							.background(Color.gray)

						// Tab: Favorites
						Button("Favorites") {
							// Action for favorites tab
						}
						.font(.headline)
						.frame(maxWidth: .infinity)
						.padding()
						.foregroundColor(.green)

						// Vertical separator
						Divider()
							.frame(height: 40)
							.background(Color.gray)

						// Tab: Top Ten
						Button("Top Ten") {
							// Action for top ten tab
						}
						.font(.headline)
						.frame(maxWidth: .infinity)
						.padding()
						.foregroundColor(.green)
					}

					// Vertical separator for Profile button
					Divider()
						.frame(height: 40)
						.background(Color.gray)

					// Profile button with adjusted size and positioning
					Button(action: {
						showingProfile.toggle()
					}) {
						Image(systemName: "person.circle.fill")
							.resizable()
							.frame(width: 40, height: 40) // Slightly smaller size
							.foregroundColor(.green)
					}
					.padding(.leading, 10) // Adjusted padding to center
					.sheet(isPresented: $showingProfile) {
						ProfileView(showingProfile: $showingProfile) // Pass binding to ProfileView
					}
				}
				.frame(maxHeight: 40) // Make the long box match the vertical lines height
				.background(Color.white)
				.cornerRadius(10)
				.shadow(radius: 5)

				Divider()

				// HStack with "Show Filters" button on the left and search bar on the right
				HStack {
					// Show Filters button
					Button(action: {
						showFilters.toggle()
					}) {
						Text("Show Filters")
							.foregroundColor(.green)
							.padding()
							.background(RoundedRectangle(cornerRadius: 10).fill(Color.green.opacity(0.2)))
					}
					.padding(.leading)

					Spacer()

					// Search bar
					TextField("Search Recipes", text: $searchText)
						.textFieldStyle(RoundedBorderTextFieldStyle())
						.padding(.trailing)
				}
				.padding(.vertical, 10)

				HStack {
					if showFilters {
						VStack {
							Text("Filters")
								.font(.headline)
								.foregroundColor(.green)

							// Protein Slider
							VStack {
								Text("Protein: \(Int(protein))g")
									.foregroundColor(.green)
								Slider(value: $protein, in: 0...200)
									.accentColor(.green)
							}
							.padding(.vertical, 10)

							// Carbs Slider
							VStack {
								Text("Carbs: \(Int(carbs))g")
									.foregroundColor(.green)
								Slider(value: $carbs, in: 0...200)
									.accentColor(.green)
							}
							.padding(.vertical, 10)

							// Fats Slider
							VStack {
								Text("Fats: \(Int(fats))g")
									.foregroundColor(.green)
								Slider(value: $fats, in: 0...200)
									.accentColor(.green)
							}
							.padding(.vertical, 10)
						}
						.frame(width: geometry.size.width * 0.25)
						.padding()
						.background(Color.green.opacity(0.1))
						.cornerRadius(10)
					}

					Spacer()

					// Recipe list placeholder
					List {
						Text("No recipes to show")
							.foregroundColor(.gray)
					}
					.listStyle(PlainListStyle())
					.padding(.horizontal)
				}
			}
		}
	}
}

struct HomeView_Previews: PreviewProvider {
	static var previews: some View {
		HomeView(showingProfile: .constant(false)) // Use constant binding for preview
	}
}
