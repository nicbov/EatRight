//  MealDetailView.swift
//  eatRight
//
//  Created by Nicolas Boving on 10/13/24.

import SwiftUI
import WebKit

struct MealDetailView: View {
	var mealDetail: MealDetail?
	var mealTitle: String
	
	@State private var svgData: Data?  // State to hold SVG data

	var body: some View {
		ScrollView {
			VStack(alignment: .leading, spacing: 20) {
				Text(mealTitle)
					.font(.largeTitle)
					.fontWeight(.bold)
					.padding(.bottom, 10)
				
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
							.foregroundColor(Color.white)

						Text("Cost per Serving: $\(String(format: "%.2f", Double(costPerServing) / 100))")
							.font(.title2)
							.fontWeight(.bold)
							.foregroundColor(Color.white)
					}
					.padding(.top, 10)
				}

				// New section to load and display SVG for taste info
				if let tasteInfo = mealDetail?.tasteInfo {
					SVGView(svgData: $svgData)  // Display SVG if available
						.frame(width: 300, height: 300)
						.onAppear {
							loadTasteChart(tasteInfo: tasteInfo)
						}
				}
			}
			.padding()
		}
		.background(Color.black.ignoresSafeArea())
		.navigationTitle("Recipe Details")
		.navigationBarTitleDisplayMode(.inline)
	}

	private func loadTasteChart(tasteInfo: [Taste]) {
		let tasteInfoDict = tasteInfo.map { ["Taste Metric": $0.tasteMetric, "Value": $0.value] }
		
		RecipeService().fetchTasteChart(tasteInfo: tasteInfoDict) { result in
			switch result {
			case .success(let data):
				svgData = data
			case .failure(let error):
				print("Error fetching SVG: \(error)")
			}
		}
	}

	private func formatNutritionInfo(nutrition: Nutrition) -> String {
		return "\(nutrition.name) (\(nutrition.unit)): \(nutrition.amount)"
	}
}

struct SVGView: UIViewRepresentable {
	@Binding var svgData: Data?

	func makeUIView(context: Context) -> WKWebView {
		let webView = WKWebView()
		webView.isOpaque = false
		webView.backgroundColor = .clear
		return webView
	}

	func updateUIView(_ webView: WKWebView, context: Context) {
		if let svgData = svgData, let svgString = String(data: svgData, encoding: .utf8) {
			webView.loadHTMLString(svgString, baseURL: nil)
		}
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
				.foregroundColor(.white)

			ForEach(content, id: \.self) { item in
				Text(item)
					.padding(5)
					.background(Color.white.opacity(0.1))
					.cornerRadius(5)
					.foregroundColor(.white)
			}
		}
		.padding(.vertical)
		.padding(.horizontal)
		.background(Color.white.opacity(0.1))
		.cornerRadius(10)
		.shadow(color: Color.gray.opacity(0.3), radius: 5, x: 0, y: 3)
	}
}
