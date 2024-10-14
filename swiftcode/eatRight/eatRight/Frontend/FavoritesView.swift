//
//  FavoritesView.swift
//  eatRight
//
//  Created by Nicolas Boving on 10/3/24.
//
import SwiftUI

struct FavoritesView: View {
	@Binding var showingProfile: Bool // Binding to manage profile view visibility
	@State private var showAccountSettings = false // State to manage navigation to Account Settings

	var body: some View {

			// Example favorites list
			List {
				Text("Favorite Recipe 1")
				Text("Favorite Recipe 2")
			}
			.listStyle(PlainListStyle())
		}
	}


// Preview for FavoritesView
struct FavoritesView_Previews: PreviewProvider {
	@State static var showingProfile: Bool = true // Static binding for preview

	static var previews: some View {
		FavoritesView(showingProfile: $showingProfile)
			.previewLayout(.sizeThatFits) // Adjust preview layout as needed
			.padding()
	}
}
