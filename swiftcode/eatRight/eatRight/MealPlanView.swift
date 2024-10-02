//
//  MealPlanView.swift
//  eatRight
//
//  Created by Max Boving on 9/30/24.
//


import SwiftUI

struct MealPlanView: View {
    @State private var meals: [String] = [] // Use a proper model for meals

    var body: some View {
        VStack {
            Text("Your Meal Plan")
                .font(.largeTitle)
                .padding()

            List(meals, id: \.self) { meal in
                Text(meal) // Display meal details
            }

            Button(action: {
                // Logic to add meals to the plan
            }) {
                Text("Add Meal")
            }
            .padding()
        }
        .navigationTitle("Meal Plan")
    }
}
