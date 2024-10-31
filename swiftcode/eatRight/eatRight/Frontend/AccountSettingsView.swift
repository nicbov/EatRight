//
//  AccountSettingsView.swift
//  eatRight
//
//  Created by Nicolas Boving on 10/13/24.
//
import SwiftUI

struct AccountSettingView: View {
	@Environment(\.presentationMode) var presentationMode // To dismiss the view

	var body: some View {
		NavigationView {
			VStack(spacing: 20) {
				// Account Settings Title
				Text("Account Settings")
					.font(.largeTitle)
					.fontWeight(.bold)
					.padding()

				// Interactive Elements
				Group {
					Button(action: {
						// Action for Change Email and Password
					}) {
						HStack {
							Image(systemName: "lock.fill")
								.foregroundColor(.green)
							Text("Change Email and Password")
								.foregroundColor(.primary)
							Spacer()
						}
						.padding()
						.background(Color.white)
						.cornerRadius(10)
						.shadow(color: Color.gray.opacity(0.3), radius: 5, x: 0, y: 3)
					}

					Button(action: {
						// Action for Profile Information
					}) {
						HStack {
							Image(systemName: "person.circle.fill")
								.foregroundColor(.green)
							Text("Profile Information")
								.foregroundColor(.primary)
							Spacer()
						}
						.padding()
						.background(Color.white)
						.cornerRadius(10)
						.shadow(color: Color.gray.opacity(0.3), radius: 5, x: 0, y: 3)
					}

					Button(action: {
						// Action for Language Preferences
					}) {
						HStack {
							Image(systemName: "globe")
								.foregroundColor(.green)
							Text("Language Preferences")
								.foregroundColor(.primary)
							Spacer()
						}
						.padding()
						.background(Color.white)
						.cornerRadius(10)
						.shadow(color: Color.gray.opacity(0.3), radius: 5, x: 0, y: 3)
					}

					Button(action: {
						// Action for Manage Subscriptions
					}) {
						HStack {
							Image(systemName: "star.fill")
								.foregroundColor(.green)
							Text("Manage Subscriptions")
								.foregroundColor(.primary)
							Spacer()
						}
						.padding()
						.background(Color.white)
						.cornerRadius(10)
						.shadow(color: Color.gray.opacity(0.3), radius: 5, x: 0, y: 3)
					}

					Button(action: {
						// Action for Data Privacy
					}) {
						HStack {
							Image(systemName: "shield.fill")
								.foregroundColor(.green)
							Text("Data Privacy")
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

				// Logout Button
				Button(action: {
					// Action for logout (currently does nothing)
				}) {
					HStack {
						Image(systemName: "arrow.left.circle")
							.foregroundColor(.red)
						Text("Logout")
							.foregroundColor(.red)
						Spacer()
					}
					.padding()
					.background(Color.white)
					.cornerRadius(10)
					.shadow(color: Color.gray.opacity(0.3), radius: 5, x: 0, y: 3)
				}

				// Done Button to return to ProfileView
				Button("Done") {
					presentationMode.wrappedValue.dismiss() // Dismiss the AccountSettingsView
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

// Preview for AccountSettingView
struct AccountSettingView_Previews: PreviewProvider {
	static var previews: some View {
		AccountSettingView()
			.previewLayout(.sizeThatFits) // Adjust preview layout as needed
			.padding()
	}
}
