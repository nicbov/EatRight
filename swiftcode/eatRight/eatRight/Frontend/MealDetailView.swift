//  MealDetailView.swift
//  eatRight
//
//  Created by Nicolas Boving on 10/13/24.
import SwiftUI

struct MealDetailView: View {
	var mealDetail: MealDetail?
	var mealTitle: String

	var body: some View {
		ScrollView {
			VStack(alignment: .leading, spacing: 20) {
				Text(mealTitle)
					.font(.largeTitle)
					.fontWeight(.bold)
					.padding(.bottom, 10)
					.foregroundColor(.white)
				
				if let instructions = mealDetail?.instructionsInfo {
					SectionView(title: "Instructions", content: instructions.enumerated().map { "\($0.offset + 1). \($0.element.instruction)" })
				}

				if let nutrition = mealDetail?.nutritionInfo {
					SectionView(title: "Nutrition", content: nutrition.map { formatNutritionInfo(nutrition: $0) })
				}

				if let price = mealDetail?.priceInfo {
					SectionView(title: "Price Info", content: price.map { "\($0.amount) \($0.name) - $\(String(format: "%.2f", $0.price / 100))" })
				}

				if let totalCost = mealDetail?.totalCost, let costPerServing = mealDetail?.totalCostPerServing {
					VStack(alignment: .leading, spacing: 5) {
						Text("Total Cost: $\(String(format: "%.2f", Double(totalCost) / 100))")
							.font(.title2)
							.fontWeight(.bold)
							.foregroundColor(.white)

						Text("Cost per Serving: $\(String(format: "%.2f", Double(costPerServing) / 100))")
							.font(.title2)
							.fontWeight(.bold)
							.foregroundColor(.white)
					}
					.padding(.top, 10)
				}

				if let taste = mealDetail?.tasteInfo {
					SectionView(title: "Taste Profile", content: taste.map { "\($0.tasteMetric): \(String(format: "%.1f", $0.value))" })
				}
			}
			.padding()
		}
		.background(Color.black.ignoresSafeArea()) // Background should be black
		.navigationTitle("Recipe Details")
		.navigationBarTitleDisplayMode(.inline)
		.navigationBarHidden(true)
	}

	// Helper function to format nutrition information
	private func formatNutritionInfo(nutrition: Nutrition) -> String {
		return "\(nutrition.name) (\(nutrition.unit)): \(nutrition.amount)"
	}
}


struct SectionView: View {
	var title: String
	var content: [String]

	var body: some View {
		VStack(alignment: .leading) {
			Text(title)
				.font(.title2)
				.fontWeight(.bold)
				.padding(.bottom, 5)
				.foregroundColor(.white)  // Title in white

			ForEach(content, id: \.self) { item in
				Text(item)
					.padding(5)
					.background(Color.white.opacity(0.1))
					.cornerRadius(5)
					.foregroundColor(.white)  // Text in white
			}
		}
		.padding(.vertical)
		.padding(.horizontal)
		.background(Color.white.opacity(0.1)) // Transparent background
		.cornerRadius(10)
		.shadow(color: Color.gray.opacity(0.3), radius: 5, x: 0, y: 3)
	}
}
