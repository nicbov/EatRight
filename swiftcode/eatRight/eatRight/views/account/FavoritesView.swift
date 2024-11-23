//
//  FavoritesView.swift
//  eatRight
//
//  Created by Nicolas Boving on 10/3/24.
//
import SwiftUI

struct FavoritesView: View {
	@Binding var showingProfile: Bool // Binding to manage profile view visibility

	var body: some View {
		GeometryReader { geometry in
			VStack {
				Text("My Favorites")
					.font(.largeTitle)
					.fontWeight(.bold)
					.padding(.top)
					.foregroundColor(.green) // Make the title text green

				List {
					ForEach(1...10, id: \.self) { index in
						HStack {
							Image(systemName: "star.fill") // Solid favorite star
								.foregroundColor(.yellow) // Set the favorite star to green

							Text("Favorite Recipe \(index)") // Dynamic recipe name
								.font(.headline)
								.padding(5) // Padding around the text
								.foregroundColor(.green) // Make the recipe text green

							Spacer() // Push text to the left
						}
						.padding(5) // Padding around the row
						.background(Color.white.opacity(0.8)) // Background for list item
						.cornerRadius(8)
						.overlay(
							RoundedRectangle(cornerRadius: 8)
								.stroke(Color.orange, lineWidth: 2) // Orange outline
						)
						.shadow(color: Color.gray.opacity(0.3), radius: 5, x: 0, y: 3) // Shadow effect
					}
				}
				.listStyle(PlainListStyle())
				.padding(.bottom, 50) // Padding at the bottom to ensure full view

				Spacer() // Push content upward
			}
		}
	}
}

// Preview for FavoritesView
struct FavoritesView_Pviews: PreviewProvider {
	@State static var showingProfile: Bool = true // Static binding for preview

	static var previews: some View {
		FavoritesView(showingProfile: $showingProfile)
			.previewLayout(.sizeThatFits) // Adjust preview layout as needed
			.padding(0)
	}
}

