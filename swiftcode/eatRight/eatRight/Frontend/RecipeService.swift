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
	func fetchRecipes(dish: String, cuisine: String?, diet: String?, intolerance: String?, completion: @escaping (Result<[Recipe], Error>) -> Void) {
		var urlComponents = URLComponents(string: "http://127.0.0.1:3000/search_recipes")!
		var queryItems = [URLQueryItem(name: "dish", value: dish)]
		
		if let cuisine = cuisine {
			queryItems.append(URLQueryItem(name: "cuisine", value: cuisine))
		}
		if let diet = diet {
			queryItems.append(URLQueryItem(name: "diet", value: diet))
		}
		if let intolerance = intolerance {
			queryItems.append(URLQueryItem(name: "intolerance", value: intolerance))
		}
		
		urlComponents.queryItems = queryItems
		
		guard let url = urlComponents.url else {
			completion(.failure(NSError(domain: "URLConstructionError", code: -1, userInfo: nil)))
			return
		}
		
		print("Fetching recipes from URL: \(url)") // Debug: Print the URL
		
		let task = URLSession.shared.dataTask(with: url) { data, response, error in
			if let error = error {
				print("Error fetching data: \(error)") // Debug: Print the error
				completion(.failure(error))
				return
			}
			
			guard let httpResponse = response as? HTTPURLResponse else {
				completion(.failure(NSError(domain: "ResponseError", code: -1, userInfo: nil)))
				return
			}

			print("HTTP Response Status Code: \(httpResponse.statusCode)") // Debug: Print HTTP status code
			
			guard let data = data else {
				print("No data returned.") // Debug: Print message if no data
				completion(.failure(NSError(domain: "DataError", code: -1, userInfo: nil)))
				return
			}

			if let jsonString = String(data: data, encoding: .utf8) {
				print("Response JSON: \(jsonString)") // Debug: Print the raw JSON response
			}

			do {
				let recipes = try JSONDecoder().decode([Recipe].self, from: data)
				completion(.success(recipes))
			} catch {
				print("Error decoding JSON: \(error)") // Debug: Print JSON decoding error
				completion(.failure(error))
			}
		}
		
		task.resume()
	}

	func fetchRecipeDetails(recipeId: Int, completion: @escaping (Result<MealDetail, Error>) -> Void) {
		let urlString = "http://127.0.0.1:3000/recipe/\(recipeId)"
		guard let url = URL(string: urlString) else {
			let error = NSError(domain: "InvalidURL", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL: \(urlString)"])
			print("Debug: \(error.localizedDescription)") // Debug: Print invalid URL error
			completion(.failure(error))
			return
		}
		
		print("Debug: Fetching recipe details from URL: \(url)") // Debug: Print the URL being fetched
		
		let task = URLSession.shared.dataTask(with: url) { data, response, error in
			if let error = error {
				print("Debug: Error fetching recipe details: \(error.localizedDescription)") // Debug: Print the error
				completion(.failure(error))
				return
			}
			
			guard let httpResponse = response as? HTTPURLResponse else {
				let error = NSError(domain: "ResponseError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid response"])
				print("Debug: \(error.localizedDescription)") // Debug: Print response error
				completion(.failure(error))
				return
			}

			print("Debug: HTTP Response Status Code: \(httpResponse.statusCode)") // Debug: Print HTTP status code
			
			guard let data = data else {
				let error = NSError(domain: "DataError", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data returned for recipe details."])
				print("Debug: \(error.localizedDescription)") // Debug: Print message if no data
				completion(.failure(error))
				return
			}

			// Print the raw JSON response for debugging
			if let jsonString = String(data: data, encoding: .utf8) {
				print("Debug: Recipe Details JSON: \(jsonString)") // Debug: Print the raw JSON response
			}

			do {
				let mealDetail = try JSONDecoder().decode(MealDetail.self, from: data)
				completion(.success(mealDetail))
			} catch {
				print("Debug: Error decoding recipe details JSON: \(error.localizedDescription)") // Debug: Print JSON decoding error
				completion(.failure(error))
			}
		}
		
		task.resume() // Don't forget to start the task!
	}
}
