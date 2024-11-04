//
//  RecipeService.swift
//  eatRight
//
//  Created by Nicolas Boving on 10/31/24.
//
//
//  RecipeService.swift
//  eatRight
//
//  Created by Nicolas Boving on 10/31/24.
//
import Foundation
struct Recipe: Identifiable, Decodable {
	let id: Int
	let title: String
}


class RecipeService {
	let baseURL = "http://127.0.0.1:3000"

	func fetchRecipes(dish: String, cuisine: String?, diet: String?, intolerance: String?, completion: @escaping (Result<[Recipe], Error>) -> Void) {
		var urlComponents = URLComponents(string: "\(baseURL)/search_recipes")!
		var queryItems = [URLQueryItem(name: "dish", value: dish)]
		
		if let cuisine = cuisine { queryItems.append(URLQueryItem(name: "cuisine", value: cuisine)) }
		if let diet = diet { queryItems.append(URLQueryItem(name: "diet", value: diet)) }
		if let intolerance = intolerance { queryItems.append(URLQueryItem(name: "intolerance", value: intolerance)) }
		
		urlComponents.queryItems = queryItems
		
		guard let url = urlComponents.url else {
			completion(.failure(NSError(domain: "URLConstructionError", code: -1, userInfo: nil)))
			return
		}
		
		let task = URLSession.shared.dataTask(with: url) { data, response, error in
			if let error = error {
				completion(.failure(error))
				return
			}
			
			guard let data = data else {
				completion(.failure(NSError(domain: "DataError", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data returned."])))
				return
			}

			do {
				let recipes = try JSONDecoder().decode([Recipe].self, from: data)
				completion(.success(recipes))
			} catch {
				completion(.failure(error))
			}
		}
		
		task.resume()
	}

	func fetchRecipeDetails(recipeId: Int, completion: @escaping (Result<MealDetail, Error>) -> Void) {
		let urlString = "http://127.0.0.1:3000/recipe/\(recipeId)"
		guard let url = URL(string: urlString) else {
			let error = NSError(domain: "InvalidURL", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL: \(urlString)"])
			completion(.failure(error))
			return
		}

		let task = URLSession.shared.dataTask(with: url) { data, response, error in
			if let error = error {
				completion(.failure(error))
				return
			}

			guard let data = data else {
				let noDataError = NSError(domain: "DataError", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data returned for recipe details."])
				completion(.failure(noDataError))
				return
			}

			// Print the raw JSON response for debugging
			if let jsonString = String(data: data, encoding: .utf8) {
				print("Debug: Recipe Details JSON: \(jsonString)")
			}

			do {
				let mealDetail = try JSONDecoder().decode(MealDetail.self, from: data)
				completion(.success(mealDetail))
			} catch {
				print("Debug: Error decoding recipe details JSON: \(error.localizedDescription)")
				completion(.failure(error))
				do {
					let mealDetail = try JSONDecoder().decode(MealDetail.self, from: data)
					completion(.success(mealDetail))
				} catch let decodingError as DecodingError {
					print("Debug: Decoding error: \(decodingError)")
					completion(.failure(decodingError))
				} catch {
					print("Debug: General error: \(error.localizedDescription)")
					completion(.failure(error))
				}
			}
		}

		task.resume()
	}

}
