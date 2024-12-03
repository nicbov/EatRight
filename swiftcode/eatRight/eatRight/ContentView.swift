//
//new contentview
import SwiftUI

enum AppState {
	case loading
	case login
	case home
}

struct ContentView: View {
	@State private var appState: AppState = .loading
	@State private var isAuthenticated: Bool = false
	@State private var showingProfile = false
	@EnvironmentObject var mealsData: MealsData  // Access mealsData from environment

	var body: some View {
		VStack {
			switch appState {
			case .loading:
				StartupView()
					.onAppear {
						DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
							appState = .login
						}
					}

			case .login:
				LoginView(authenticate: authenticateUser)

			case .home:
				NavigationView {
					VStack(spacing: 0) { // Set spacing to 0 to remove unwanted padding
						HeaderView(
							showingProfile: $showingProfile)
						.environmentObject(mealsData) // Ensure mealsData is passed into the view

						TabView {
							HomeView(showingProfile: $showingProfile)
								.tabItem {
									Label("Home", systemImage: "house.fill")
								}

							FavoritesView(showingProfile: $showingProfile)
								.tabItem {
									Label("Favorites", systemImage: "star.fill")
								}

							MyMealsView()
								.tabItem {
									Label("My Meals", systemImage: "book.fill")
								}
						}
						.accentColor(.green) // Optional: set a color for the selected tab
						.sheet(isPresented: $showingProfile) {
							ProfileView(showingProfile: $showingProfile)
						}
					}
				}
			}
		}
		.padding()
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
