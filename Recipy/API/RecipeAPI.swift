//
//  RecipeAPI.swift
//  Recipy
//
//  Created by Sebastian Jolly on 7/21/19.
//  Copyright © 2019 Sebastian Jolly. All rights reserved.
//

import Foundation
import UIKit

enum RequestType {
    case search
    case get
    case random
}

typealias JSON = [String: Any]

protocol RecipeURLSession {
    func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask
}
extension URLSession: RecipeURLSession {}

class RecipeAPI {
    
    // Can't init because it is singleton
    private init() {}
    static let shared: RecipeAPI = RecipeAPI()
    
    private var usedPages:[Int] = []
    //     Client Key
    //    private let apiKey = "10c7a64dbc5de05e8f4b92236672b85b"
    
    // My Key
    private let apiKey = "ac27422ec15eb5e306894dfbe174bc85"
    
    //     My Key
  //      private let apiKey = "304d668bc906a9dff9e85d2fdeaff9d6"
    
    
    //    private let apiKey = "eb8ed820f7adfa161eba51ca846bde91"
    
    
    private let urlComponents = URLComponents(string: "http://food2fork.com/api/")! // base URL components of the web service
    private var imageDownloadTask: URLSessionDataTask?
    
    lazy var session: RecipeURLSession = URLSession.shared
    
    
    /// Build the api url with the given parameters
    ///
    /// - Parameters:
    ///   - type: The type of request (Search or Get)
    ///   - params: Customs parameters to send
    /// - Returns: The GET url
    private func buildURL(type: RequestType, params: [String: String?]?) -> URL {
        var queryItems = [URLQueryItem(name: "key", value: apiKey)]
        var components = urlComponents
        
        switch type {
        case .search:
            components.path += "search"
            break
        case .get:
            components.path += "get"
            break
        case .random:
            components.path += "random"
            break
        }
        
        if let params = params {
            for p in params {
                queryItems += [URLQueryItem(name: p.key, value: p.value)]
            }
        }
        components.queryItems = queryItems
        return components.url!
    }
    
    
    /// Build a search recipe api request
    ///
    /// - Parameters:
    ///   - query: The terms to search
    ///   - page: Page to load if there is more than 30 results
    /// - Returns: The GET url
    private func buildSearchRequest(query: String?, page: Int) -> URL {
        var params = ["q": query]
        if page > 0 { params["page"] = String(page) }
        return buildURL(type: .search, params: params)
    }
    
    /// Build a get recipe api request
    ///
    /// - Parameters:
    ///   - recipeId: The id of the recipe as retreived in the search results
    /// - Returns: The GET url
    private func buildGetRequest(recipeId: String) -> URL {
        return buildURL(type: .get, params: ["rId": recipeId])
    }
    
    
    /// Search recipes matching the query
    ///
    /// - Parameters:
    ///   - query: The query to search the recipes that matches it
    ///   - completion: A completion handler with a list of recipes matching the query
    ///     or an empty array of no recipe was found
    func recipe(matching query: String, page: Int = 1, completion: @escaping ([Recipe]) -> Void) {
        let url = buildSearchRequest(query: query, page: page)
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
    
    func getRecipesSortedByRating(page: Int = 1, completion: @escaping ([Recipe]) -> Void) {
        
        let list = Array(1...50)
        var random = list.randomElement() ?? 1
        
        while usedPages.contains(random) {
            random = list.randomElement() ?? 1
            if !usedPages.contains(random) {
                usedPages.append(random)
                break
            }
        }
        
        let url = buildURL(type: RequestType.search, params: ["page":"\(random)","sort":"r"])
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
