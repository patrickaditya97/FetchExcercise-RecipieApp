//
//  MealDetailView.swift
//  FetchExcercise
//
//  Created by Aditya on 7/11/24.
//

import SwiftUI

struct MealDetailView: View {
    let mealId: String?
    @StateObject private var viewModel = ViewModel()
    
    var body: some View {
        ScrollView {
            if let mealDetails = viewModel.mealDetails {
                
                VStack {
                    AsyncImage(url: URL(string: mealDetails.strMealThumb)) { image in
                        image.resizable()
                    } placeholder: {
                        ProgressView()
                    }
                    .aspectRatio(contentMode: .fit)
                    
                    Text("Ingredients: ")
                        .font(.title2)
                        .fontWeight(.bold)
                        .padding(.top, 10)
                    ForEach(Array(mealDetails.ingredients), id: \.0) {ingredient, measure in
                        Text("\(ingredient): \(measure)")
                            .padding(.bottom, 5)
                    }
                    
                    Text("Instructions: ")
                        .font(.title2)
                        .fontWeight(.bold)
                        .padding(.top, 10)
                    Text(mealDetails.strInstructions)
                }
                .navigationTitle(mealDetails.strMeal)
                .padding([.leading, .trailing], 20)
                
            } else {
                ProgressView()
                    .task {
                        await viewModel.fetchMealDetails(meal_id: mealId!)
                    }
            }
        }
    }
}

#Preview {
    MealDetailView(mealId: "")
}
