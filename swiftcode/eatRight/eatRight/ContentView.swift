//
//  ContentView.swift
//  eatRight
//
//  Created by only Nico Boving(alone) on 9/30/24.
//

import SwiftUI

enum AppState{
	case loading
	case login
}

struct ContentView: View {
	@State private var appState: AppState = .loading

	var body: some View {
		VStack {
			switch appState {
			case .loading:
				StartupView()
					.onAppear{
						DispatchQueue.main.asyncAfter(deadline: .now() + 6) {
							appState = .login
						}
					}
			case .login:
				LoginView()
			}
			}
		.padding()
		}
	}


struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		ContentView()
	}
}
