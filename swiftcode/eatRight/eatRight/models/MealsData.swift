//
//  MealsData.swift
//  eatRight
//
//  Created by Max Boving on 11/21/24.
//
import Foundation
import SwiftUI

final class MealsData: ObservableObject {
	@Published var meals: [MealWithDetails] = [] // This holds the list of meals
}
