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

struct ContentView: View {
	@State private var appState: AppState = .loading
	@State private var isAuthenticated: Bool = false
	@State private var showingProfile = false // State for profile view

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
				HomeView(showingProfile: $showingProfile) // Pass binding to HomeView
					.sheet(isPresented: $showingProfile) { // Present ProfileView as a sheet
						ProfileView(showingProfile: $showingProfile) // Bind showingProfile to dismiss
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

struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		ContentView()
	}
}

