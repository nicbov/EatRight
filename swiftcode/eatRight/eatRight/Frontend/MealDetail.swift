// MealDetail.swift
// eatRight
//
// Created by Nicolas Boving on 11/1/24.
//
import Foundation

struct MealDetail: Identifiable, Decodable {
	let id = UUID()
	let instructionsInfo: [Instruction]
	let nutritionInfo: [Nutrition]
	let priceInfo: [Price]
	let tasteInfo: [Taste]

	// Additional properties for total cost and cost per serving
	var totalCost: Double? // Use Double to match the JSON price format
	var totalCostPerServing: Double?

	private enum CodingKeys: String, CodingKey {
		case instructionsInfo = "instructions_info"
		case nutritionInfo = "nutrition_info"
		case priceInfo = "price_info"
		case tasteInfo = "taste_info"
	}

	init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		instructionsInfo = try container.decode([Instruction].self, forKey: .instructionsInfo)
		nutritionInfo = try container.decode([Nutrition].self, forKey: .nutritionInfo)
		priceInfo = try container.decode([Price].self, forKey: .priceInfo)
		tasteInfo = try container.decode([Taste].self, forKey: .tasteInfo)

		// Extract total cost and cost per serving from priceInfo
		let totalCostEntry = priceInfo.first { $0.name == "Total Cost" }
		let costPerServingEntry = priceInfo.first { $0.name == "Cost per Serving" }

		totalCost = totalCostEntry?.price
		totalCostPerServing = costPerServingEntry?.price
	}
}

struct Instruction: Identifiable, Decodable {
	let id = UUID()
	let instruction: String
	let step: Int

	private enum CodingKeys: String, CodingKey {
		case instruction = "Instruction"
		case step = "Step"
	}
}

struct Nutrition: Identifiable, Decodable {
	let id = UUID()
	let nutritionMetric: String
	let value: String

	private enum CodingKeys: String, CodingKey {
		case nutritionMetric = "Nutrition Metric"
		case value = "Value"
	}
}

struct Price: Identifiable, Decodable {
	let id = UUID()
	let amount: String // Keep as String to handle empty strings
	let name: String
	let price: Double // Keep as Double

	private enum CodingKeys: String, CodingKey {
		case amount = "Amount"
		case name = "Name"
		case price = "Price"
	}

	// Custom initializer to handle different types for amount
	init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)

		// Attempt to decode amount as a String
		if let amountString = try? container.decode(String.self, forKey: .amount) {
			amount = amountString
		} else {
			// If that fails, try to decode it as a Double and convert to String
			let amountDouble = try container.decode(Double.self, forKey: .amount)
			amount = String(amountDouble)
		}
		
		name = try container.decode(String.self, forKey: .name)
		price = try container.decode(Double.self, forKey: .price)
	}
}

struct Taste: Identifiable, Decodable {
	let id = UUID()
	let tasteMetric: String
	let value: Double

	private enum CodingKeys: String, CodingKey {
		case tasteMetric = "Taste Metric"
		case value = "Value"
	}
}
