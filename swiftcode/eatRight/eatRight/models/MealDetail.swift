//
//  MealDetail.swift
//  eatRight
//
//  Created by Max Boving on 11/21/24.
//
import Foundation

// Main structure for meal details
struct MealDetail: Identifiable, Decodable {
	let id = UUID()
	let instructionsInfo: [Instruction]
	let nutritionInfo: [Nutrition]
	let priceInfo: [Price]
	let tasteInfo: [Taste]
	
	var totalCost: Double?
	var totalCostPerServing: Double?

	private enum CodingKeys: String, CodingKey {
		case instructionsInfo = "instructions_info"
		case nutritionInfo = "nutrition_info"
		case priceInfo = "price_info"
		case tasteInfo = "taste_info"
	}

	init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		
		do {
			instructionsInfo = try container.decode([Instruction].self, forKey: .instructionsInfo)
		} catch {
			print("Error decoding instructions_info: \(error)")
			throw error
		}
		
		do {
			nutritionInfo = try container.decode([Nutrition].self, forKey: .nutritionInfo)
		} catch {
			print("Error decoding nutrition_info: \(error)")
			throw error
		}
		
		do {
			priceInfo = try container.decode([Price].self, forKey: .priceInfo)
		} catch {
			print("Error decoding price_info: \(error)")
			throw error
		}
		
		do {
			tasteInfo = try container.decode([Taste].self, forKey: .tasteInfo)
		} catch {
			print("Error decoding taste_info: \(error)")
			throw error
		}

		// Calculate total cost from priceInfo
		totalCost = priceInfo.reduce(0) { $0 + $1.price }
		
		// Assuming a default of 4 servings
		if let _ = priceInfo.first {
			let servings = 4.0 // You can change this value if actual servings are available
			totalCostPerServing = totalCost! / servings
		}
	}
}

// Struct for instructions in the recipe
struct Instruction: Identifiable, Decodable {
	let id = UUID()
	let instruction: String
	let step: Int

	private enum CodingKeys: String, CodingKey {
		case instruction = "Description"
		case step = "Step"
	}
}

// Struct for nutrition details in the recipe
struct Nutrition: Identifiable, Decodable {
	let id = UUID()
	let name: String
	let amount: Double
	let unit: String
	let percentOfDailyNeeds: Double

	private enum CodingKeys: String, CodingKey {
		case name = "Name"
		case amount = "Amount"
		case unit = "Unit"
		case percentOfDailyNeeds = "PercentOfDailyNeeds"
	}
}

// Struct for price information of ingredients
struct Price: Identifiable, Decodable {
	let id = UUID()
	let ingredient: String
	let price: Double
	let amount: String

	private enum CodingKeys: String, CodingKey {
		case ingredient = "Ingredient"
		case price = "Price"
		case amount = "Amount"
	}
}

// Struct for taste profile
struct Taste: Identifiable, Decodable {
	let id = UUID()
	let tasteMetric: String
	let value: Double

	private enum CodingKeys: String, CodingKey {
		case tasteMetric = "Taste Metric"
		case value = "Value"
	}
}

