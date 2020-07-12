//
//  Recipe.swift
//  Recipy
//
//  Created by Sebastian Jolly on 7/21/19.
//  Copyright © 2019 Sebastian Jolly. All rights reserved.
//

import Foundation

class Recipe:NSObject,NSCoding {
    
    var vegetarian: Bool
    var vegan: Bool
    var glutenFree: Bool
    var dairyFree: Bool
    var veryHealthy: Bool
    var cheap: Bool
    var veryPopular: Bool
    var sustainable: Bool
    var lowFodmap: Bool
    var ketogenic: Bool
    var whole30: Bool
    var weightWatcherSmartPoints: Int
    var preparationMinutes: Int
    var cookingMinutes: Int
    var aggregateLikes: Int
    var spoonacularScore: Int
    var healthScore: Int
    var readyInMinutes: Int
    var servings: Int
    var pricePerServing: Double
    var gaps: String
    var creditsText: String
    var sourceName: String
    var recipeId: String = ""
    var title: String
    var imageType: String
    var imageUrl: String
    var sourceUrl: String
    var spoonacularSourceUrl: String
    var instructions: String
    var cuisines: [String]
    var dishTypes: [String]
    var diets: [String]
    var occasions: [[String: Any]] = []
    var winePairing: [String: Any]
    var extendedIngredients: [[String: Any]]
    var analyzedInstructions: [[String: Any]]

    var page: Int?
    var addedToFavoriteOn: Double = 0.0
    var savedObject: [String: Any]

    
    init?(json: [String: Any]) {
        // First we make sure that the non-optional fields are present in the Json
        // else the initialisation fails
//        guard
        let recipeId = "\(json["id"] ?? 0)"
        let title = json["title"] as? String
        let vegetarian = json["vegetarian"] as? Bool
        let vegan = json["vegan"] as? Bool
        let glutenFree = json["glutenFree"] as? Bool
        let dairyFree = json["dairyFree"] as? Bool
        let veryHealthy = json["veryHealthy"] as? Bool
        let cheap = json["cheap"] as? Bool
        let veryPopular = json["veryPopular"] as? Bool
        let sustainable = json["sustainable"] as? Bool
        let lowFodmap = json["lowFodmap"] as? Bool
        let ketogenic = json["ketogenic"] as? Bool
        let whole30 = json["whole30"] as? Bool
        let weightWatcherSmartPoints = json["weightWatcherSmartPoints"] as? Int
        let preparationMinutes = json["preparationMinutes"] as? Int
        let cookingMinutes = json["cookingMinutes"] as? Int
        let aggregateLikes = json["aggregateLikes"] as? Int
        let spoonacularScore = json["spoonacularScore"] as? Int
        let healthScore = json["healthScore"] as? Int
        let readyInMinutes = json["readyInMinutes"] as? Int
        let servings = json["servings"] as? Int
        let pricePerServing = json["pricePerServing"] as? Double
        let gaps = json["gaps"] as? String
        let creditsText = json["creditsText"] as? String
        let sourceName = json["sourceName"] as? String
        let instructions = json["instructions"] as? String
        let cuisines = json["cuisines"] as? [String]
        let dishTypes = json["dishTypes"] as? [String]
        let diets = json["diets"] as? [String]
        let occasions = json["occasions"] as? [[String: Any]]
        let winePairing = json["winePairing"] as? [String: Any]
        let extendedIngredients = json["extendedIngredients"] as? [[String: Any]]
        let analyzedInstructions = json["analyzedInstructions"] as? [[String: Any]]
        
        // We try to create URL from the string retreived
        // else the initialisation fails
        let imageType = json["imageType"] as? String
        let imageUrl = json["image"] as? String
        let spoonacularSourceUrl = json["spoonacularSourceUrl"] ?? "https://spoonacular.com"
        let sourceUrl = json["source_url"] ?? "http://www.foodnetwork.com/recipes"
        
        // We assign the retreived value and the optionals one to the our recipe
        if recipeId == "0" {
            return nil
        } else {
            self.recipeId = recipeId
        }
        if imageUrl == nil {
            return nil
        } else {
            self.imageUrl = imageUrl!
        }
        self.imageType = imageType ?? "jpg"
        self.title = title ?? ""
        self.spoonacularSourceUrl = spoonacularSourceUrl as! String
        self.sourceUrl = sourceUrl as! String
        self.vegetarian = vegetarian ?? false
        self.vegan = vegan ?? false
        self.glutenFree = glutenFree ?? false
        self.dairyFree = dairyFree ?? false
        self.veryHealthy = veryHealthy ?? false
        self.cheap = cheap ?? false
        self.veryPopular = veryPopular ?? false
        self.sustainable = sustainable ?? false
        self.weightWatcherSmartPoints = weightWatcherSmartPoints ?? 0
        self.lowFodmap = lowFodmap ?? false
        self.ketogenic = ketogenic ?? false
        self.whole30 = whole30 ?? false
        self.preparationMinutes = preparationMinutes ?? 0
        self.cookingMinutes = cookingMinutes ?? 0
        self.readyInMinutes = readyInMinutes ?? 0
        self.aggregateLikes = aggregateLikes ?? 0
        self.spoonacularScore = spoonacularScore ?? 0
        self.healthScore = healthScore ?? 0
        self.servings = servings ?? 0
        self.pricePerServing = pricePerServing ?? 0.0
        self.gaps = gaps ?? ""
        self.creditsText = creditsText ?? ""
        self.sourceName = sourceName ?? ""
        self.instructions = instructions ?? ""
        self.winePairing = winePairing ?? [:]
        self.cuisines = cuisines ?? []
        self.dishTypes = dishTypes ?? []
        self.diets = diets ?? []
        self.occasions = occasions ?? []
        self.analyzedInstructions = analyzedInstructions ?? []
        self.extendedIngredients = extendedIngredients ?? []

        self.page = json["page"] as? Int
        self.addedToFavoriteOn = json["addedToFavoriteOn"] as? Double ?? 0.0
        self.savedObject = json

    }
    
    func toJSONForFirebase() -> [String:AnyObject]{
        
        var requestBody:[String:AnyObject] = [String:AnyObject]()
        requestBody["id"] = self.recipeId as AnyObject
        requestBody["title"]   = self.title as AnyObject
        requestBody["vegetarian"] = self.vegetarian as AnyObject
        requestBody["vegan"] = self.vegan as AnyObject
        requestBody["glutenFree"] = self.glutenFree as AnyObject
        requestBody["veryHealthy"] = self.veryHealthy as AnyObject
        requestBody["cheap"] = self.cheap as AnyObject
        requestBody["veryPopular"] = self.veryPopular as AnyObject
        requestBody["sustainable"] = self.sustainable as AnyObject
        requestBody["lowFodmap"] = self.lowFodmap as AnyObject
        requestBody["ketogenic"] = self.ketogenic as AnyObject
        requestBody["whole30"] = self.whole30 as AnyObject
        requestBody["weightWatcherSmartPoints"] = self.weightWatcherSmartPoints as AnyObject
        requestBody["preparationMinutes"] = self.preparationMinutes as AnyObject
        requestBody["cookingMinutes"] = self.cookingMinutes as AnyObject
        requestBody["aggregateLikes"] = self.aggregateLikes as AnyObject
        requestBody["spoonacularScore"] = self.spoonacularScore as AnyObject
        requestBody["healthScore"] = self.healthScore as AnyObject
        requestBody["readyInMinutes"] = self.readyInMinutes as AnyObject
        requestBody["servings"] = self.servings as AnyObject
        requestBody["pricePerServing"] = self.pricePerServing as AnyObject
        requestBody["gaps"] = self.gaps as AnyObject
        requestBody["creditsText"] = self.creditsText as AnyObject
        requestBody["sourceName"] = self.sourceName as AnyObject
        requestBody["instructions"] = self.instructions as AnyObject
        requestBody["imageType"] = self.imageType as AnyObject
        requestBody["image"] = self.imageUrl as AnyObject
        requestBody["source_url"] = self.sourceUrl as AnyObject
        requestBody["spoonacularSourceUrl"] = self.spoonacularSourceUrl as AnyObject
        requestBody["cuisines"] = self.cuisines as AnyObject
        requestBody["dishTypes"] = self.dishTypes as AnyObject
        requestBody["diets"] = self.diets as AnyObject
        requestBody["occasions"] = self.occasions as AnyObject
        requestBody["winePairing"] = self.winePairing as AnyObject
        requestBody["extendedIngredients"] = self.extendedIngredients as AnyObject
        requestBody["analyzedInstructions"] = self.analyzedInstructions as AnyObject

        requestBody["page"]   = self.page as AnyObject
        requestBody["addedToFavoriteOn"] = Date().timeIntervalSince1970 as AnyObject
        return requestBody
    }
    
    func encode(with aCoder: NSCoder) {
        
        aCoder.encode(self.savedObject, forKey: "savedReceipe")
        
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        
        guard let obj = aDecoder.decodeObject(forKey: "savedReceipe") as? [String:Any] else { return nil }
        
        self.init(json:obj)
        
    }
    
}
