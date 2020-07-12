//
//  RecipeSimple.swift
//  Recipy
//
//  Created by Dan Jin on 2019/8/28.
//  Copyright © 2019 Sebastian Jolly. All rights reserved.
//

import Foundation

class RecipeSimple:NSObject,NSCoding {

    var recipeId: String = ""
    var title: String = ""
    var readyInMinutes: Int = 0
    var servings: Int = 0
    var image: String = ""
    var imageUrls: [String] = [""]

    var page: Int?
    var addedToFavoriteOn: Double = 0.0
    var savedObject: [String: Any]

    init?(json: [String: Any]) {
        self.recipeId = "\(json["id"] ?? 0)"
        self.title = json["title"] as! String
        self.readyInMinutes = json["readyInMinutes"] as! Int
        self.servings = json["servings"] as! Int
        self.image = json["image"] as! String
        self.imageUrls = json["imageUrls"] as! [String]

        self.page = json["page"] as? Int
        self.addedToFavoriteOn = json["addedToFavoriteOn"] as? Double ?? 0.0
        self.savedObject = json
    }

    func toJSONForFirebase() -> [String:AnyObject]{
        
        var requestBody:[String:AnyObject] = [String:AnyObject]()
        requestBody["id"] = self.recipeId as AnyObject
        requestBody["title"]   = self.title as AnyObject
        requestBody["readyInMinutes"] = self.readyInMinutes as AnyObject
        requestBody["servings"] = self.servings as AnyObject
        requestBody["image"] = self.image as AnyObject
        requestBody["imageUrls"] = self.imageUrls as AnyObject

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
