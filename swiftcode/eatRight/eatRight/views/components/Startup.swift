//
//  Startup.swift
//  eatRight
//
//  Created by Nicolas Boving on 10/3/24.
//

import SwiftUI

struct StartupView: View {
	var body: some View {
		VStack {
			Image("Image") // Make sure you have this image in your asset catalog
				.resizable()
				.scaledToFit()
				.frame(width: 250, height: 250)
				.padding()
			
			ProgressView()
				.progressViewStyle(CircularProgressViewStyle(tint: .green))
				.scaleEffect(1.5)
				.padding()

			Text("CopyRight 2024")
				.font(.subheadline)
				.padding()

		}
	}
}

struct StartupView_Previews: PreviewProvider {
	static var previews: some View {
		StartupView()
	}
}


