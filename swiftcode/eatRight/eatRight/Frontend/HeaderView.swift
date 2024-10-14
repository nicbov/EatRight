//
//  HeaderView.swift
//  eatRight
//
//  Created by Nicolas Boving on 10/13/24.
//
import SwiftUI

struct HeaderView: View {
	@Binding var showingProfile: Bool
	@Binding var selectedTab: Tab // Assuming Tab is defined elsewhere in your project
	@Binding var showingMyMeals: Bool // Ensure this is passed in correctly

	var switchToFavorites: () -> Void
	var switchToMyMeals: () -> Void
	
	var body: some View {
		GeometryReader { geometry in
			VStack {
				// Full-width logo with green outline and rounded corners
				Image("Image")
					.resizable()
					.scaledToFit()
					.frame(width: geometry.size.width * 0.8, height: geometry.size.height * 0.1) // Increased height for the logo
					.overlay(RoundedRectangle(cornerRadius: 10)
						.stroke(Color.green, lineWidth: 2))
					.padding(.top, 10)
				
				// Tabs HStack including Profile in one long box, with vertical separators
				HStack(spacing: 0) {
					// Tab Buttons
					Group {
						// Tab: Home
						createTabButton(title: "Home", tab: .home) {
							showingMyMeals = false // Hide My Meals view
							selectedTab = .home
						}
						
						Divider() // Vertical divider between tabs
						
						// Tab: Favorites
						createTabButton(title: "Favorites", tab: .favorites) {
							switchToFavorites() // Switch to Favorites tab
							showingMyMeals = false // Hide My Meals view when switching
						}
						
						Divider() // Vertical divider between tabs
						
						// Tab: My Meals
						createTabButton(title: "My Meals", tab: .myMeals) {
							showingMyMeals.toggle() // Show My Meals view
						}
					}
					
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
			}
		}
	}
	
	// Function to create tab buttons
	private func createTabButton(title: String, tab: Tab, action: @escaping () -> Void) -> some View {
		Button(action: {
			action()
		}) {
			Text(title)
				.frame(maxWidth: .infinity)
				.padding()
				.foregroundColor(.green) // Set all tab titles to green
				.background(selectedTab == tab ? Color.white : Color.clear)
				.cornerRadius(5)
		}
	}
}

// Preview for HeaderView
struct HeaderView_Previews: PreviewProvider {
	@State static var showingProfile: Bool = true
	@State static var selectedTab: Tab = .home
	@State static var showingMyMeals: Bool = false
	
	static var previews: some View {
		HeaderView(showingProfile: $showingProfile, selectedTab: $selectedTab, showingMyMeals: $showingMyMeals, switchToFavorites: {}, switchToMyMeals: {})
			.previewLayout(.sizeThatFits)
			.padding()
	}
}
