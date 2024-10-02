//
//  HomeView.swift
//  eatRight
//
//  Created by Max Boving on 9/30/24.
//


import SwiftUI

struct HomeView: View {
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var registrationMessage: String = ""

    var body: some View {
        NavigationView {
            VStack {
                Image("YourLogo") // Replace with your logo image
                    .resizable()
                    .scaledToFit()
                    .frame(height: 200)

                TextField("Username", text: $username)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                SecureField("Password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                Button(action: register) {
                    Text("Register")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .padding()
                
                Text(registrationMessage)
                    .foregroundColor(.red)
                    .padding()

                NavigationLink(destination: SearchView()) {
                    Text("Already have an account? Log In")
                }
                .padding()
            }
            .navigationTitle("Welcome")
        }
    }

    func register() {
        guard let url = URL(string: "http://localhost:5000/api/register") else { return }

        let parameters = ["username": username, "password": password]
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
        } catch {
            print("Error in JSON serialization: \(error)")
            return
        }

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    registrationMessage = "Registration failed: \(error.localizedDescription)"
                }
                return
            }

            guard let responseData = data else { return }
            if let responseJSON = try? JSONSerialization.jsonObject(with: responseData, options: []) as? [String: Any],
               let message = responseJSON["message"] as? String {
                DispatchQueue.main.async {
                    registrationMessage = message
                }
            } else {
                DispatchQueue.main.async {
                    registrationMessage = "Registration failed."
                }
            }
        }
        task.resume()
    }
}
