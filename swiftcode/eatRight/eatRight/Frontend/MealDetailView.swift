//  MealDetailView.swift
//  eatRight
//
//  Created by Nicolas Boving on 10/13/24.
import SwiftUI
import WebKit

struct MealDetailView: View {
	var mealDetail: MealDetail?
	var mealTitle: String

	struct SectionView: View {
		var title: String
		var content: [String]

		var body: some View {
			VStack(alignment: .leading, spacing: 10) {
				ForEach(content, id: \.self) { item in
					HStack {
						Image(systemName: "circle.fill")
							.font(.caption)
							.foregroundColor(.black) // Bullet style
						Text(item)
							.font(.body)
					}
				}
			}
			.padding(.bottom, 15)
		}
	}

	@State private var svgData: Data?  // State to hold SVG data
	@State private var showSpicyPepper: Bool = false  // State to track if a spicy pepper should be displayed
	@State private var isInstructionsExpanded: Bool = false  // State for Instructions dropdown
	@State private var isNutritionExpanded: Bool = false  // State for Nutrition dropdown
	@State private var isPriceExpanded: Bool = false  // State for Price dropdown

	var body: some View {
		ScrollView {
			VStack(alignment: .leading, spacing: 20) {
				// Title with optional spicy pepper icon
				HStack {
					Text(mealTitle)
						.font(.largeTitle)
						.fontWeight(.bold)
					if showSpicyPepper {
						Image("Image 1")
							.resizable()
							.frame(width: 60, height: 60)
							.padding(.leading, 5)
						
						
					}
				}

				// Instructions dropdown
				if let instructions = mealDetail?.instructionsInfo {
					DisclosureGroup("Instructions", isExpanded: $isInstructionsExpanded) {
						SectionView(title: "Instructions", content: instructions.map { $0.instruction })
							.padding(.top, 5)
					}
					.padding(.bottom, 10)
					.font(.title2)
					.foregroundColor(.black)
				}

				// Nutrition dropdown
				if let nutrition = mealDetail?.nutritionInfo {
					DisclosureGroup("Nutrition", isExpanded: $isNutritionExpanded) {
						SectionView(title: "Nutrition", content: nutrition.map { formatNutritionInfo(nutrition: $0) })
							.padding(.top, 5)
					}
					.padding(.bottom, 10)
					.font(.title2)
					.foregroundColor(.black)
				}

				// Price dropdown
				if let price = mealDetail?.priceInfo {
					DisclosureGroup("Price Info", isExpanded: $isPriceExpanded) {
						SectionView(title: "Price Info", content: price.map { "\($0.amount) \($0.name) - $\(String(format: "%.2f", $0.price / 100))" })
							.padding(.top, 5)
					}
					.padding(.bottom, 10)
					.font(.title2)
					.foregroundColor(.black)
				}

				// Total Cost and Cost per Serving in a prominent box
				if let totalCost = mealDetail?.totalCost, let costPerServing = mealDetail?.totalCostPerServing {
					VStack(alignment: .leading, spacing: 10) {
						// Total Cost
						HStack {
							Text("Total Cost:")
								.font(.title2)
								.fontWeight(.bold)
								.foregroundColor(.black)

							Text("$\(String(format: "%.2f", Double(totalCost) / 100))")
								.font(.title2)
								.fontWeight(.bold)
								.foregroundColor(.black)
						}
						.padding()
						.background(Color.gray.opacity(0.2))  // Light grey background
						.cornerRadius(10)  // Rounded corners
						.shadow(radius: 5)  // Optional shadow for emphasis

						// Cost per Serving
						HStack {
							Text("Cost per Serving:")
								.font(.title2)
								.fontWeight(.bold)
								.foregroundColor(.black)

							Text("$\(String(format: "%.2f", Double(costPerServing) / 100))")
								.font(.title2)
								.fontWeight(.bold)
								.foregroundColor(.black)
						}
						.padding()
						.background(Color.gray.opacity(0.2))  // Light grey background
						.cornerRadius(10)  // Rounded corners
						.shadow(radius: 5)  // Optional shadow for emphasis
					}
					.padding(.top, 10)
				}

				// Load and display SVG for taste info
				if let tasteInfo = mealDetail?.tasteInfo {
					SVGView(svgData: $svgData)
						.frame(width: 350, height: 350)  // Increased frame size
						.padding(.top, 20)  // Add padding to move it higher
						.onAppear {
							loadTasteChart(tasteInfo: tasteInfo)
						}
				}
			}
			.padding()
		}
		.navigationTitle("Recipe Details")
		.navigationBarTitleDisplayMode(.inline)
	}

	private func loadTasteChart(tasteInfo: [Taste]) {
		if let spicy = tasteInfo.first(where: { $0.tasteMetric == "spiciness" })?.value, spicy > 500 {
			showSpicyPepper = true
		}

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

	func updateUIView(_ uiView: WKWebView, context: Context) {
		if let data = svgData {
			uiView.load(data, mimeType: "image/svg+xml", characterEncodingName: "utf-8", baseURL: URL(string: "https://www.example.com")!)
		}
	}
}
