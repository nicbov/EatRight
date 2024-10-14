//
//  MyMealsView.swift
//  eatRight
//
//  Created by Nicolas Boving on 10/13/24.
//
import SwiftUI

struct MyMealsView: View {
	@Binding var showingProfile: Bool // Binding to manage profile view visibility
	@State private var meals = ["Meal 1", "Meal 2", "Meal 3"] // Example meal list

	var body: some View {
		GeometryReader { geometry in
			NavigationView {
				VStack(spacing: 20) {
					Text("My Meals")
						.font(.largeTitle)
						.fontWeight(.bold)
						.padding()

					// Meal List
					List(meals, id: \.self) { meal in
						Text(meal)
					}
					.listStyle(PlainListStyle())

					// Profile Button
					Button(action: {
						showingProfile.toggle() // Show Profile View
					}) {
						HStack {
							Image(systemName: "person.circle.fill")
								.foregroundColor(.green)
							Text("Profile")
								.font(.headline)
								.foregroundColor(.primary)
							Spacer()
						}
						.padding()
						.background(Color.white)
						.cornerRadius(10)
						.shadow(color: Color.gray.opacity(0.3), radius: 5, x: 0, y: 3)
					}
					.sheet(isPresented: $showingProfile) {
						ProfileView(showingProfile: $showingProfile) // Navigate to ProfileView
					}

					// Spacer to push content upwards
					Spacer()
				}
				.padding()
				.frame(width: geometry.size.width, height: geometry.size.height) // Full view size
			}
		}
	}
}

// Preview for MyMealsView
struct MyMealsView_Previews: PreviewProvider {
	@State static var showingProfile: Bool = true // Static binding for preview

	static var previews: some View {
		MyMealsView(showingProfile: $showingProfile)
			.previewLayout(.sizeThatFits) // Adjust preview layout as needed
			.padding()
	}
}

