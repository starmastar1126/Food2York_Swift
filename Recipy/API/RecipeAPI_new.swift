//
//  RecipeAPI_new.swift
//  Recipy
//
//  Created by eric on 2019/8/23.
//  Copyright © 2019 Sebastian Jolly. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

//enum RequestType {
//    case search
//    case get
//}

//typealias JSON = [String: Any]

//protocol RecipeURLSession {
//    func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask
//}
//extension URLSession: RecipeURLSession {}

class RecipeAPI_new {
    
    // Can't init because it is singleton
    private init() {}
    static let shared: RecipeAPI_new = RecipeAPI_new()
    
    private var usedPages:[Int] = []
    

    private let apiKey = "bf04a45769d042ec99794ed60d2e914a"         // spoonacular api
    private let urlComponents = URLComponents(string: "https://api.spoonacular.com/recipes/")!
    
    private var imageDownloadTask: URLSessionDataTask?
    lazy var session: RecipeURLSession = URLSession.shared
    
    
    /// Build the api url with the given parameters
    ///
    /// - Parameters:
    ///   - type: The type of request (Search or Get)
    ///   - params: Customs parameters to send
    /// - Returns: The GET url
    private func buildURL(type: RequestType, params: [String: String?]?) -> URL {
        var queryItems = [URLQueryItem(name: "apiKey", value: apiKey)]
        var components = urlComponents
        
        switch type {
        case .search:
            components.path += "search"
            if let params = params {
                for p in params {
                    queryItems += [URLQueryItem(name: p.key, value: p.value)]
                }
            }
            break

        case .get:
            if let params = params {
                for p in params {
                    components.path += p.value!
                }
            }
            components.path += "information"
            break

        case .random:
            components.path += "random"
            if let params = params {
                for p in params {
                    queryItems += [URLQueryItem(name: p.key, value: p.value)]
                }
            }
            break
        }
        
        components.queryItems = queryItems
        return components.url!
    }
    
    
    /// Build a search recipe api request
    ///
    /// - Parameters:
    ///   - query: The terms to search
    ///   - number: more than 30 results
    /// - Returns: The GET url
    private func buildSearchRequest(query: String?, number: Int) -> URL {
        var params = ["query": query]
        if number > 0 { params["number"] = String(number) }
        return buildURL(type: .search, params: params)
    }
    
    /// Build a get recipe api request
    ///
    /// - Parameters:
    ///   - recipeId: The id of the recipe as retreived in the search results
    /// - Returns: The GET url
    private func buildGetRequest(recipeId: String) -> URL {
        return buildURL(type: .get, params: ["id": recipeId])
    }
    
    
    /// Search recipes matching the query
    ///
    /// - Parameters:
    ///   - query: The query to search the recipes that matches it
    ///   - completion: A completion handler with a list of recipes matching the query
    ///     or an empty array of no recipe was found
    func recipe(matching query: String, page: Int = 1, completion: @escaping ([Recipe]) -> Void) {
        let url = buildSearchRequest(query: query, number: page * 30)
        session.dataTask(with: url) { data, response, error in
            var recipes = [Recipe]()
            
            do {
                if let data = data,
                    let jsonResult = try JSONSerialization.jsonObject(with: data, options: []) as? JSON,
                    let baseURL = jsonResult["baseUri"] as? String,
                    let results = jsonResult["results"] as? [JSON] {
                    for case var result in results {
                        result["image"] = "\(baseURL)" + "\(result["image"] ?? 0)"
                        if let recipe = Recipe(json: result) {
                            recipes += [recipe]
                        }
                    }
                }
            } catch {}
            
            completion(recipes)
            
            }.resume()
    }
    
    
    /// Retreive a recipe from the given id
    ///
    /// - Parameters:
    ///   - id: The recipe id
    ///   - completion: A completion handler with the recipe matching the given id
    ///     or nil if not recipe corespond to this id
    func recipe(id: String, completion: @escaping (Recipe?) -> Void) {
        let url = buildGetRequest(recipeId: id)
        
        session.dataTask(with: url) { data, response, error in
            
            var recipe: Recipe?
            
            do {
                if let data = data,
                    let jsonResult = try JSONSerialization.jsonObject(with: data, options: []) as? JSON,
                    let result = jsonResult["recipe"] as? JSON {
                    recipe = Recipe(json: result)
                    print(jsonResult)
                    completion(recipe)
                }
            } catch {
                completion(nil)
            }
            
            }.resume()
    }
    
    
    /// Download an image from a url
    /// Keep a reference to the URLSessionDataTask to be canceled if needed
    ///
    /// - Parameters:
    ///   - url: The image URL
    ///   - completion: Completion handler returning the image
    ///     or nil if no image was found or if the data was incorrect
    func downloadImage(at url: URL, completion: @escaping (UIImage?) -> Void) {
        imageDownloadTask = session.dataTask(with: url) { data, _, _ in
            self.imageDownloadTask = nil
            var image: UIImage?
            if let data = data {
                image = UIImage(data: data)
            }
            completion(image)
            
        }
        imageDownloadTask?.resume()
    }
    
    /// Cancel downloading of image if it exist
    func cancelImageDownload() {
        imageDownloadTask?.cancel()
        imageDownloadTask = nil
    }
    
    func getRandomRecipes(randomcount: Int = 10, completion: @escaping ([Recipe]) -> Void) {
       
        let url = buildURL(type: RequestType.random, params: ["number":"\(randomcount)"])
        session.dataTask(with: url) { data, response, error in
            var recipes = [Recipe]()
            
            do {
                if let data = data,
                    let jsonResult = try JSONSerialization.jsonObject(with: data, options: []) as? JSON,
                    let results = jsonResult["recipes"] as? [JSON] {
                    for case let result in results {
                        if let recipe = Recipe(json: result) {
                            recipes += [recipe]
                        }
                    }
                }
            } catch {}
            
            completion(recipes)
            
            }.resume()
    }
}
