//
//  RecipeDetailViewModel.swift
//  Recipy
//
//  Created by Sebastian Jolly on 7/21/19.
//  Copyright © 2019 Sebastian Jolly. All rights reserved.
//

import Foundation
import UIKit

struct RecipeDetailViewModel {
    private let apiClient = RecipeAPI_new.shared
    
    let recipe: Recipe
    
    var title: String {
        return recipe.title
    }
    
    func image(completion: @escaping (UIImage?) -> Void) {
        apiClient.downloadImage(at: URL(string: recipe.imageUrl)!, completion: completion)
    }
    
    func cancelImageDownload() {
        apiClient.cancelImageDownload()
    }
    
    var nbIngredients: Int {
        return recipe.extendedIngredients.count 
    }
    
    func ingredient(at index: Int) -> [String: Any]? {
        return recipe.extendedIngredients[index]
    }
    
    func details(completion: @escaping (RecipeDetailViewModel) -> Void) {
        apiClient.recipe(id: recipe.recipeId) { (recipeDetails) in
            if let recipeDetails = recipeDetails {
                let vm = RecipeDetailViewModel(recipe: recipeDetails)
                completion(vm)
            }
        }
    }
}
