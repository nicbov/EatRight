//
//  SettingsView.swift
//  eatRight
//
//  Created by Nicolas Boving on 10/3/24.
//

import SwiftUI

struct SettingsView: View { // Make sure the struct name is SettingsView
	@Binding var showingSettings: Bool // Manage visibility

	var body: some View {
		VStack {
			Text("Settings")
				.font(.largeTitle)
				.padding()

			Button("Done") {
				showingSettings = false // Dismiss the settings view
			}
			.padding()
			.background(Color.green)
			.foregroundColor(.white)
			.cornerRadius(10)
		}
		.padding()
	}
}

struct SettingsView_Previews: PreviewProvider {
	@State static var showingSettings = true

	static var previews: some View {
		SettingsView(showingSettings: $showingSettings)
	}
}
