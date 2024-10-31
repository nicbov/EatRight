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
			ZStack {
				// Background color for the entire view
				Color.green.opacity(0.2) // Light green background
					.edgesIgnoringSafeArea(.all) // Extend to fill all corners

				VStack {
					Text("My Favorites")
						.font(.largeTitle)
						.fontWeight(.bold)
						.padding(.top)

					List {
						ForEach(1...10, id: \.self) { index in
							HStack {
								Image(systemName: "star.fill") // Solid favorite star
									.foregroundColor(.yellow) // Solid yellow color
									.font(.title)

								Text("Favorite Recipe \(index)") // Dynamic recipe name
									.font(.headline)
									.padding(5) // Padding around the text

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
}

// Preview for FavoritesView
struct FavoritesView_Previews: PreviewProvider {
	@State static var showingProfile: Bool = true // Static binding for preview

	static var previews: some View {
		FavoritesView(showingProfile: $showingProfile)
			.previewLayout(.sizeThatFits) // Adjust preview layout as needed
			.padding(0) // Remove padding for the preview
	}
}
