//
//  ProfileView.swift
//  eatRight
//
//  Created by Nicolas Boving on 10/3/24.
//import SwiftUI
import SwiftUI

struct ProfileView: View {
	@Binding var showingProfile: Bool // Binding to dismiss the profile view

	var body: some View {
		NavigationView {
			Form {
				Section(header: Text("Account Settings")
							.foregroundColor(.green)
							.font(.headline)) {
					// Example settings
					HStack {
						Text("Username")
						Spacer()
						Text("YourUsername")
							.foregroundColor(.gray)
					}
					.padding()
					.background(RoundedRectangle(cornerRadius: 10).stroke(Color.green, lineWidth: 1))

					HStack {
						Text("Email")
						Spacer()
						Text("youremail@example.com")
							.foregroundColor(.gray)
					}
					.padding()
					.background(RoundedRectangle(cornerRadius: 10).stroke(Color.green, lineWidth: 1))
				}

				Section {
					Button(action: {
						logout()
					}) {
						Text("Logout")
							.foregroundColor(.red)
							.frame(maxWidth: .infinity, alignment: .center)
							.padding()
							.background(RoundedRectangle(cornerRadius: 10).fill(Color.red.opacity(0.2)))
					}
				}
			}
			.navigationTitle("Profile")
			.navigationBarTitleDisplayMode(.inline) // Display title inline
			.navigationBarItems(trailing: Button("Done") {
				showingProfile = false // Dismiss the profile view
			}
			.foregroundColor(.green)) // Green color for "Done" button
			.accentColor(.green) // Set the tint color for navigation items
		}
		.navigationViewStyle(StackNavigationViewStyle()) // Make navigation view work on all devices
	}

	private func logout() {
		// Implement your logout logic here
		print("Logged out")
		showingProfile = false // Dismiss profile view on logout
	}
}

struct ProfileView_Previews: PreviewProvider {
	static var previews: some View {
		ProfileView(showingProfile: .constant(true)) // Preview with profile view open
	}
}
