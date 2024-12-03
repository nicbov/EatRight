//
//  HeaderView.swift
//  eatRight
//
//  Created by Nicolas Boving on 10/13/24.
//
import SwiftUI

struct HeaderView: View {
	@Binding var showingProfile: Bool

	var body: some View {
		VStack {
			HStack {
				// Spacer before the logo to center it
				Spacer()

				// Logo in the center
				Image("Image")
					.resizable()
					.scaledToFit()
					.frame(height: 40) // Adjust the height as needed
					.padding(8) // Padding to give spacing around the image
					.background(
						RoundedRectangle(cornerRadius: 10)
							.stroke(Color.green, lineWidth: 2) // Green outline
					)

				Spacer()

				// Account button on the right
				Button(action: {
					showingProfile.toggle()
				}) {
					Image(systemName: "line.horizontal.3")
						.resizable()
						.frame(width: 20, height: 20) // Adjust size as needed
						.foregroundColor(.green)
				}
				.padding(.trailing, 10) // Padding to position the button on the right
			}

			Divider()
				.background(Color.green.opacity(0.7)) // Match the divider color to the background
		}
		.padding(.top)
	}
}

struct HeaderView_Previews: PreviewProvider {
	@State static var showingProfile: Bool = false

	static var previews: some View {
		HeaderView(showingProfile: $showingProfile)
			.previewLayout(.sizeThatFits)
			.padding()
	}
}
