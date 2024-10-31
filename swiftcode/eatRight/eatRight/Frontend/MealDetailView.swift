//
//  MealDetailView.swift
//  eatRight
//
//  Created by Nicolas Boving on 10/13/24.
//


import SwiftUI

struct MealDetailView: View {
    var mealName: String // Variable to hold the name of the meal

    var body: some View {
        VStack {
            Text(mealName) // Display the name of the meal
                .font(.largeTitle)
                .padding()

            // Additional meal details can be added here
            Text("Details about \(mealName)")
                .padding()
        }
    }
}

// Preview for MealDetailView
struct MealDetailView_Previews: PreviewProvider {
    static var previews: some View {
        MealDetailView(mealName: "Sample Meal") // Preview with sample meal
    }
}
