//
//  eatRightApp.swift
//  eatRight
//
//  Created by Max Boving on 9/30/24.
//
import SwiftUI

@main
struct EatRightApp: App {
	@StateObject var mealsData = MealsData() // Create shared meals data

	var body: some Scene {
		WindowGroup {
			ContentView()
				.environmentObject(mealsData) // Inject MealsData into the environment
		}
	}
}

