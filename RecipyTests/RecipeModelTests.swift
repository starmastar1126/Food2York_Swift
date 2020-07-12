//
//  RecipeModelTests.swift
//  Recipy
//
//  Created by Sebastian Jolly on 7/20/19.
//  Copyright © 2019 Sebastian Jolly. All rights reserved.
//

import XCTest
@testable import Recipy

class RecipeModelTests: XCTestCase {
    
    struct DemoRecipeData {
        let recipeId = "7744xx"
        let imageUrl = "http://allrecipes.com/image.jpg"
        let sourceUrl = "http://allrecipes.com/Recipe/Slow-Cooker-Chicken-Tortilla-Soup/Detail.aspx"
        let f2fUrl = "http://food2fork.com/F2F/recipes/view/29159"
        let title = "Slow-Cooker Chicken Tortilla Soup"
        let publisher = "Allrecipes.com"
        let publisherUrl = "http://allrecipes.com"
        let socialRank = 99.81007979198002
    }
    let demoRecipe = DemoRecipeData()
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testCreationWithEmptyJsonIsNil() {
        let json: JSON = ["":""]
        let recipe = Recipe(json: json)
        XCTAssertNil(recipe)
    }
    
    func testCreationWithNotEnoughJsonFieldIsNil() {
        let json: JSON = ["image_url": "http://www.image.com/myimage.jpg"]
        let recipe = Recipe(json: json)
        XCTAssertNil(recipe)
    }
    
    func testCreationWithMinimumJsonFieldIsNotNil() {
        let json: JSON = [
            "recipe_id": demoRecipe.recipeId,
            "image_url": demoRecipe.imageUrl,
            "publisher": demoRecipe.publisher,
            "social_rank": demoRecipe.socialRank,
            "f2f_url": demoRecipe.f2fUrl,
            "publisher_url": demoRecipe.publisherUrl,
            "title": demoRecipe.title,
            "source_url": demoRecipe.sourceUrl]
        let recipe = Recipe(json: json)
        XCTAssertNotNil(recipe)
    }
    
    func testRecipeCreationDataMatchJson() {
        let json: JSON = [
            "recipe_id": demoRecipe.recipeId,
            "image_url": demoRecipe.imageUrl,
            "publisher": demoRecipe.publisher,
            "social_rank": demoRecipe.socialRank,
            "f2f_url": demoRecipe.f2fUrl,
            "publisher_url": demoRecipe.publisherUrl,
            "title": demoRecipe.title,
            "source_url": demoRecipe.sourceUrl]
        let recipe = Recipe(json: json)
        XCTAssertEqual(recipe?.recipeId, demoRecipe.recipeId)
        XCTAssertEqual(recipe?.publisher, demoRecipe.publisher)
        XCTAssertEqual(recipe?.socialRank, demoRecipe.socialRank)
        XCTAssertEqual(recipe?.f2fUrl.absoluteString, demoRecipe.f2fUrl)
        XCTAssertEqual(recipe?.publisherUrl.absoluteString, demoRecipe.publisherUrl)
        XCTAssertEqual(recipe?.title, demoRecipe.title)
        XCTAssertEqual(recipe?.sourceUrl.absoluteString, demoRecipe.sourceUrl)
    }
    
    func testCreationWithNotIncorectJsonFieldFormatIsNil() {
        let json: JSON = [
            "recipe_id": demoRecipe.recipeId,
            "image_url": demoRecipe.imageUrl,
            "publisher": demoRecipe.publisher,
            "social_rank": "7827652476524",
            "f2f_url": demoRecipe.f2fUrl,
            "publisher_url": demoRecipe.publisherUrl,
            "title": demoRecipe.title,
            "source_url": demoRecipe.sourceUrl]
        let recipe = Recipe(json: json)
        XCTAssertNil(recipe)
    }
}
