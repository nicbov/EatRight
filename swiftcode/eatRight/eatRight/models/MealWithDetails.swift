//
//  MealWithDetails.swift
//  eatRight
//
//  Created by Max Boving on 11/21/24.
//
import Foundation
import SwiftUI

struct MealWithDetails: Identifiable {
	var id = UUID()  // Automatically provides a unique identifier for each meal
	var title: String
	var mealDetail: MealDetail
}
