//
//new contentview
import SwiftUI

enum AppState {
	case loading
	case login
	case home
}

enum Tab {
	case home
	case favorites
	case myMeals
}
struct ContentView: View {
	@State private var appState: AppState = .loading
	@State private var selectedTab: Tab = .home
	@State private var isAuthenticated: Bool = false
	@State private var showingProfile = false
	@State private var showingMyMeals = false
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
				HeaderView(
					showingProfile: $showingProfile,
					selectedTab: $selectedTab,
					showingMyMeals: $showingMyMeals,
					switchToFavorites: { selectedTab = .favorites },
					switchToMyMeals: { selectedTab = .myMeals }
				)
				NavigationView {
					VStack(spacing: 0) { // Set spacing to 0 to remove unwanted padding
						switch selectedTab {
						case .home:
							HomeView(showingProfile: $showingProfile) {
								selectedTab = .favorites
							}
							.environmentObject(mealsData)  // Properly pass mealsData to HomeView

						case .favorites:
							FavoritesView(showingProfile: $showingProfile)

						case .myMeals:
							MyMealsView()
								.environmentObject(mealsData)  // Pass mealsData to MyMealsView
						}
					}
					.sheet(isPresented: $showingProfile) {
						ProfileView(showingProfile: $showingProfile)
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
