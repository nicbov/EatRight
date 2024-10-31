//
//  MyMealsView.swift
//  eatRight
//
//  Created by Nicolas Boving on 10/13/24.
//
import SwiftUI

struct MyMealsView: View {
	@Binding var showingProfile: Bool // Binding to manage profile view visibility
	@State private var meals = [
		"Meal 1", "Meal 2", "Meal 3", "Meal 4", "Meal 5",
		"Meal 6", "Meal 7", "Meal 8", "Meal 9", "Meal 10"
	]

	var body: some View {
		NavigationView {
			VStack {
				// Meal Grid Layout
				let columns = [
					GridItem(.flexible(), spacing: 20), // Spacing between columns
					GridItem(.flexible(), spacing: 20)
				]

				ScrollView {
					LazyVGrid(columns: columns, spacing: 20) {
						ForEach(meals, id: \.self) { meal in
							Button(action: {
								// Button action can be added later
							}) {
								Text(meal)
									.font(.headline)
									.padding()
									.frame(width: 100, height: 100) // Make boxes more square
									.background(Color.white) // Background for meal box
									.cornerRadius(10) // Rounded corners
									.overlay(RoundedRectangle(cornerRadius: 10)
										.stroke(Color.orange, lineWidth: 2)) // Orange outline
									.shadow(color: Color.gray.opacity(0.3), radius: 5, x: 0, y: 3) // Shadow effect
							}
						}
					}
					.padding()
				}
				Spacer() // Push content upwards
			}

		}
	}
}

// Preview for MyMealsView
struct MyMealsView_Previews: PreviewProvider {
	@State static var showingProfile: Bool = false // Static binding for preview

	static var previews: some View {
		MyMealsView(showingProfile: $showingProfile)
			.previewLayout(.sizeThatFits) // Adjust preview layout as needed
			.padding()
	}
}

