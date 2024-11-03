//
//  MealDetailView.swift
//  eatRight
//
//  Created by Nicolas Boving on 10/13/24.
//
import SwiftUI

struct MealDetailView: View {
	var mealDetail: MealDetail? // The detail information about the meal
	var mealTitle: String // The title of the meal

	var body: some View {
		VStack {
			if let detail = mealDetail {
				List {
					Section(header: Text("Instructions")) {
						ForEach(detail.instructions_info) { instruction in
							Text("\(instruction.Step): \(instruction.Instruction)")
						}
					}

					Section(header: Text("Nutrition Info")) {
						ForEach(detail.nutrition_info) { nutrition in
							Text("\(nutrition.NutritionMetric): \(nutrition.Value)")
						}
					}

					Section(header: Text("Price Info")) {
						ForEach(detail.price_info) { price in
							Text("\(price.Name): $\(String(format: "%.2f", price.Price))")
						}
					}

					Section(header: Text("Taste Info")) {
						ForEach(detail.taste_info) { taste in
							Text("\(taste.TasteMetric): \(taste.Value)")
						}
					}
				}
				.navigationTitle(mealTitle) // Set the navigation title to the meal title
			} else {
				Text("Loading...").onAppear {
					print("MealDetailView loading for \(mealTitle)") // Debugging
				}
			}
		}
	}
}
