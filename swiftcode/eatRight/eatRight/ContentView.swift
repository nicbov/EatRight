//
//  ContentView.swift
//  eatRight
//
//  Created by only Nico Boving(alone) on 9/30/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image("Image")
				.cornerRadius(20)
				.imageScale(.medium)
				.foregroundStyle(.green)
            Text("Copyright 2024")
				.bold()
				.padding()
        }
        .padding()
    }
}

struct ContentView_Previews:
	PreviewProvider {
	static var  previews: some View {
		ContentView()
	}

}
