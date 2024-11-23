//
//  ProfileView.swift
//  eatRight
//
//  Created by Nicolas Boving on 10/3/24.
//import SwiftUI
import SwiftUI

struct ProfileView: View {
	@Binding var showingProfile: Bool // Binding to manage visibility
	@State private var showAccountSettings = false // State to manage navigation to Account Settings

	var body: some View {
		NavigationView {
			VStack(spacing: 20) {
				// Profile Title
				Text("Profile")
					.font(.largeTitle)
					.fontWeight(.bold)
					.padding()

				// Profile Image Placeholder
				Image(systemName: "person.circle.fill")
					.resizable()
					.scaledToFit()
					.frame(width: 100, height: 100)
					.foregroundColor(.green)
					.padding()

				// Account Settings Button
				Button(action: {
					showAccountSettings.toggle() // Show Account Settings
				}) {
					HStack {
						Image(systemName: "gear")
							.foregroundColor(.green)
						Text("Account Settings")
							.font(.headline)
							.foregroundColor(.primary)
						Spacer()
					}
					.padding()
					.background(Color.white)
					.cornerRadius(10)
					.shadow(color: Color.gray.opacity(0.3), radius: 5, x: 0, y: 3)
				}
				.sheet(isPresented: $showAccountSettings) {
					AccountSettingView() // Navigate to AccountSettingView
				}

				// Interactive Elements
				Group {
					Button(action: {
						// Action for Notifications
					}) {
						HStack {
							Image(systemName: "bell")
								.foregroundColor(.green)
							Text("Notifications")
								.foregroundColor(.primary)
							Spacer()
						}
						.padding()
						.background(Color.white)
						.cornerRadius(10)
						.shadow(color: Color.gray.opacity(0.3), radius: 5, x: 0, y: 3)
					}

					Button(action: {
						// Action for Payment Activity
					}) {
						HStack {
							Image(systemName: "lock")
								.foregroundColor(.green)
							Text("Payment Activity")
								.foregroundColor(.primary)
							Spacer()
						}
						.padding()
						.background(Color.white)
						.cornerRadius(10)
						.shadow(color: Color.gray.opacity(0.3), radius: 5, x: 0, y: 3)
					}

					Button(action: {
						// Action for Privacy Settings
					}) {
						HStack {
							Image(systemName: "lock")
								.foregroundColor(.green)
							Text("Privacy Settings")
								.foregroundColor(.primary)
							Spacer()
						}
						.padding()
						.background(Color.white)
						.cornerRadius(10)
						.shadow(color: Color.gray.opacity(0.3), radius: 5, x: 0, y: 3)
					}

					Button(action: {
						// Action for Help & Support
					}) {
						HStack {
							Image(systemName: "questionmark.circle")
								.foregroundColor(.green)
							Text("Help & Support")
								.foregroundColor(.primary)
							Spacer()
						}
						.padding()
						.background(Color.white)
						.cornerRadius(10)
						.shadow(color: Color.gray.opacity(0.3), radius: 5, x: 0, y: 3)
					}

					Button(action: {
						// Action for About Us
					}) {
						HStack {
							Image(systemName: "info.circle")
								.foregroundColor(.green)
							Text("About Us")
								.foregroundColor(.primary)
							Spacer()
						}
						.padding()
						.background(Color.white)
						.cornerRadius(10)
						.shadow(color: Color.gray.opacity(0.3), radius: 5, x: 0, y: 3)
					}
				}

				// Spacer to push content upwards
				Spacer()

				// Done Button
				Button("Done") {
					showingProfile = false // Dismiss the profile view
				}
				.padding()
				.background(Color.green)
				.foregroundColor(.white)
				.cornerRadius(10)
			}
			.padding()
		}
	}
}

// Preview for ProfileView
struct ProfileView_Previews: PreviewProvider {
	@State static var showingProfile: Bool = true // Static binding for preview

	static var previews: some View {
		ProfileView(showingProfile: $showingProfile)
			.previewLayout(.sizeThatFits) // Adjust preview layout as needed
			.padding()
	}
}
