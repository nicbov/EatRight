//
//  LoginView.swift
//  eatRight
//
//  Created by Nicolas Boving on 10/4/24.
import SwiftUI

struct LoginView: View {
	@State private var username: String = ""
	@State private var password: String = ""
	@State private var showingAlert = false
	@State private var alertMessage = ""
	@State private var isLoading = false
	
	let primaryColor = Color.green
	var authenticate: (Bool) -> Void // Authentication closure passed from ContentView
	
	var body: some View {
		GeometryReader { geometry in
			ScrollView {
				VStack(spacing: 30) {
					Spacer().frame(height: geometry.size.height * 0.05)
					
					// Logo with modified size and styling
					Image("Image") // Replace with your logo name
						.resizable()
						.scaledToFit()
						.frame(height: geometry.size.height * 0.1) // Make the logo smaller
						.padding()
						.background(Color.white) // Background for the logo
						.cornerRadius(10) // Rounded corners
						.shadow(color: Color.black.opacity(0.3), radius: 5, x: 0, y: 5) // Shadow effect
						.overlay(
							RoundedRectangle(cornerRadius: 10)
								.stroke(primaryColor, lineWidth: 2) // Outline around the logo
						)

					Text("Sign In")
						.font(.largeTitle)
						.foregroundColor(primaryColor) // Change the title color

					VStack(spacing: 15) {
						TextField("Username", text: $username)
							.textFieldStyle(RoundedBorderTextFieldStyle())
							.autocapitalization(.none)
							.padding(.horizontal)
							.cornerRadius(10)

						SecureField("Password", text: $password)
							.textFieldStyle(RoundedBorderTextFieldStyle())
							.padding(.horizontal)
							.cornerRadius(10)

						Button(action: performLogin) {
							if isLoading {
								ProgressView()
									.progressViewStyle(CircularProgressViewStyle(tint: .white))
							} else {
								Text("Login")
									.frame(maxWidth: .infinity)
							}
						}
						.padding()
						.background(primaryColor)
						.foregroundColor(.white)
						.cornerRadius(10)
						.disabled(username.isEmpty || password.isEmpty || isLoading)
					}
					.padding(.horizontal)
					
					HStack {
						Button("Forgot Password?") {
							print("Forgot password tapped")
						}
						.foregroundColor(primaryColor)
						
						Spacer()
						
						Button("Create Account") {
							print("Create account tapped")
						}
						.foregroundColor(primaryColor)
					}
					.padding(.horizontal)
					
					Spacer()
				}
				.frame(minHeight: geometry.size.height)
			}
		}
		.alert(isPresented: $showingAlert) {
			Alert(title: Text("Login Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
		}
	}
	
	private func performLogin() {
		guard !username.isEmpty && !password.isEmpty else {
			alertMessage = "Please enter both username and password."
			showingAlert = true
			return
		}
		
		isLoading = true
		
		DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
			isLoading = false
			
			if username == "Test" && password == "Password" {
				print("Login successful")
				authenticate(true) // Call the authentication closure to switch to home
			} else {
				alertMessage = "Invalid username or password. Please try again."
				showingAlert = true
				authenticate(false)
			}
		}
	}
}

struct LoginView_Previews: PreviewProvider {
	static var previews: some View {
		LoginView(authenticate: { _ in })
	}
}

