//
//  ViewModel.swift
//  FetchExcercise
//
//  Created by Aditya on 7/11/24.
//

import Foundation

struct Meal: Codable, Identifiable {
    let idMeal: String
    let strMeal: String
    let strMealThumb: String
    
    var id: String { idMeal }
}

struct MealDetail: Codable {
    let idMeal: String
    let strMeal: String
    let strMealThumb: String
    let strInstructions: String
    var ingredients: [String: String] = [:]
    
    enum MealInfoKeys: String, CodingKey {
        case idMeal, strMeal, strMealThumb, strInstructions
    }
    
    enum IngredientKeys: String, CodingKey {
        case strIngredient1, strIngredient2, strIngredient3, strIngredient4, strIngredient5, strIngredient6, strIngredient7, strIngredient8, strIngredient9, strIngredient10, strIngredient11, strIngredient12, strIngredient13, strIngredient14, strIngredient15, strIngredient16, strIngredient17, strIngredient18, strIngredient19, strIngredient20

        case strMeasure1, strMeasure2, strMeasure3, strMeasure4, strMeasure5, strMeasure6, strMeasure7, strMeasure8, strMeasure9, strMeasure10, strMeasure11, strMeasure12, strMeasure13, strMeasure14, strMeasure15, strMeasure16, strMeasure17, strMeasure18, strMeasure19, strMeasure20
    }
    
    init(from decoder: Decoder) throws {
        let mealInfoCodes = try decoder.container(keyedBy: MealInfoKeys.self)
        idMeal = try mealInfoCodes.decode(String.self, forKey: .idMeal)
        strMeal = try mealInfoCodes.decode(String.self, forKey: .strMeal)
        strMealThumb = try mealInfoCodes.decode(String.self, forKey: .strMealThumb)
        strInstructions = try mealInfoCodes.decode(String.self, forKey: .strInstructions)
        
        let ingredientCodes = try decoder.container(keyedBy: IngredientKeys.self)
        
        for i in 1...20 {
            let ingredientCode = IngredientKeys(stringValue: "strIngredient\(i)")!
            let measureCode = IngredientKeys(stringValue: "strMeasure\(i)")!
            
            if let ingredient = try? ingredientCodes.decode(String.self, forKey: ingredientCode),
               let measure = try? ingredientCodes.decode(String.self, forKey: measureCode),
               !ingredient.isEmpty, !measure.isEmpty{
                ingredients[ingredient] = measure
            }
        }
    }
}

struct MealsFromAPI: Codable {
    let meals: [Meal]
}

struct MealDetailFromAPI: Codable {
    let meals: [MealDetail]
}

@MainActor
class ViewModel: ObservableObject {
    @Published var meals: [Meal] = []
    @Published var mealDetails: MealDetail?
    
    func fetchMeals() async {
        do {
            let api_url = URL(string: "https://themealdb.com/api/json/v1/1/filter.php?c=Dessert")!
            
            let (data, _) = try await URLSession.shared.data(from: api_url)
            let response = try JSONDecoder().decode(MealsFromAPI.self, from: data)
            meals = response.meals.sorted { $0.strMeal < $1.strMeal }
        } catch {
            print("Failed to fetch meals from API")
        }
    }
    
    func fetchMealDetails(meal_id: String) async {
        do {
            let api_url = URL(string: "https://themealdb.com/api/json/v1/1/lookup.php?i=\(meal_id)")!
            
            let (data, _) = try await URLSession.shared.data(from: api_url)
            let response = try JSONDecoder().decode(MealDetailFromAPI.self, from: data)
            mealDetails = response.meals.first!
        } catch {
            print("Failed to fetch mealDetails from API")
        }
    }
    
}
