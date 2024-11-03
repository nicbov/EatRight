//
//  MealDetail.swift
//  eatRight
//
//  Created by Nicolas Boving on 11/1/24.
//
import Foundation

// Structure for each instruction in the meal
struct InstructionInfo: Codable, Identifiable {
	var id: Int { Step }
	let Instruction: String
	let Step: Int
}

// Structure for nutrition information
struct NutritionInfo: Codable, Identifiable {
	var id: String { NutritionMetric }
	let NutritionMetric: String
	let Value: String

	// Custom keys to map the JSON structure
	private enum CodingKeys: String, CodingKey {
		case NutritionMetric = "Nutrition Metric"
		case Value
	}
}

// Structure for price information
struct PriceInfo: Codable, Identifiable {
	var id: String { Name }
	let Amount: Double
	let Name: String
	let Price: Double
}

// Structure for taste information
struct TasteInfo: Codable, Identifiable {
	var id: String { TasteMetric }
	let TasteMetric: String
	let Value: Double

	private enum CodingKeys: String, CodingKey {
		case TasteMetric = "Taste Metric" // Correctly maps the key from JSON
		case Value
	}
}

// Main model for meal detail response
struct MealDetail: Codable {
	let instructions_info: [InstructionInfo]
	let nutrition_info: [NutritionInfo]
	let price_info: [PriceInfo]
	let taste_info: [TasteInfo]

	// Custom initializer to limit `nutrition_info` to the first 4 items
	init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		self.instructions_info = try container.decode([InstructionInfo].self, forKey: .instructions_info)
		self.price_info = try container.decode([PriceInfo].self, forKey: .price_info)
		self.taste_info = try container.decode([TasteInfo].self, forKey: .taste_info)

		// Limit `nutrition_info` to the first 4 items
		let nutritionData = try container.decode([NutritionInfo].self, forKey: .nutrition_info)
		self.nutrition_info = Array(nutritionData.prefix(4)) // Keeps only the first 4 entries
	}

	private enum CodingKeys: String, CodingKey {
		case instructions_info, nutrition_info, price_info, taste_info
	}
}
