//
//  ContentView.swift
//  eatRight
// add social medi aspect to cooking, maybe posting dishes of their own on instagram like UI
//  Created by only Nico Boving(alone) on 9/30/24.
import SwiftUI

enum AppState {
	case loading
	case login
	case home
}

enum Tab {
	case home
	case favorites
	case myMeals // Added new tab for My Meals
}

struct ContentView: View {
	@State private var appState: AppState = .loading
	@State private var selectedTab: Tab = .home // Track the active tab
	@State private var isAuthenticated: Bool = false
	@State private var showingProfile = false // State for profile view
	@State private var showingMyMeals = false // State for My Meals view


	var body: some View {
		VStack {
			switch appState {
			case .loading:
				StartupView()
					.onAppear {
						DispatchQueue.main.asyncAfter(deadline: .now() + 6) {
							appState = .login
						}
					}
			case .login:
				LoginView(authenticate: authenticateUser)
			case .home:
				VStack {
					HeaderView(
						showingProfile: $showingProfile,
						selectedTab: $selectedTab,
						showingMyMeals: $showingMyMeals,
						switchToFavorites: switchToFavorites,
						switchToMyMeals: switchToMyMeals
					)

					// Display content based on the selected tab
					switch selectedTab {
					case .home:
						HomeView(showingProfile: $showingProfile, switchToFavorites: switchToFavorites)
					case .favorites:
						FavoritesView(showingProfile: $showingProfile)
					case .myMeals:
						MyMealsView(showingProfile: $showingProfile)
					}
				}
				.sheet(isPresented: $showingProfile) {
					ProfileView(showingProfile: $showingProfile) // Correctly pass showingProfile as binding
				}
			}
		}
		.padding()
	}

	// Switch to Favorites tab
	func switchToFavorites() {
		selectedTab = .favorites
	}

	// Switch to My Meals tab
	func switchToMyMeals() {
		selectedTab = .myMeals // Update this to switch to My Meals tab
		showingMyMeals = true // Ensure My Meals view is shown if you need it
	}

	func authenticateUser(isAuthenticated: Bool) {
		if isAuthenticated {
			self.isAuthenticated = true
			appState = .home
		} else {
			print("Authentication failed")
		}
	}
}

// Preview for ContentView
struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		ContentView()
	}
}
