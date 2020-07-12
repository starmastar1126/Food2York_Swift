//
//  RecipeDetailsCellTests.swift
//  Recipy
//
//  Created by Sebastian Jolly on 7/20/19.
//  Copyright © 2019 Sebastian Jolly. All rights reserved.
//

import XCTest
@testable import Recipy

class RecipeDetailsCellTests: XCTestCase {
    
    var tableView: UITableView!
    var controller: RecipeDetailViewController!
    let dataProvider = FakeDataSource()
    
    override func setUp() {
        super.setUp()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        controller = storyboard.instantiateViewController(
            withIdentifier: "RecipeDetailViewController") as! RecipeDetailViewController
        _ = controller.view
        tableView = controller.tableView
        tableView.dataSource = dataProvider
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testCellHasPublisherLabel() {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "RecipeDetailCellIdentifier",
            for: IndexPath(row: 0, section: 0)) as! RecipeDetailCell
        
        XCTAssertNotNil(cell.publisherLabel)
    }
    
    func testCellHasRankLabel() {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "RecipeDetailCellIdentifier",
            for: IndexPath(row: 0, section: 0)) as! RecipeDetailCell
        
        XCTAssertNotNil(cell.rankLabel)
    }
    
    func testCellHasInstructionsButton() {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "RecipeDetailCellIdentifier",
            for: IndexPath(row: 0, section: 0)) as! RecipeDetailCell
        
        XCTAssertNotNil(cell.instructionButton)
    }
    
    func testCellHasOriginalButton() {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "RecipeDetailCellIdentifier",
            for: IndexPath(row: 0, section: 0)) as! RecipeDetailCell
        
        XCTAssertNotNil(cell.originalButton)
    }
    
    func testCellConfiguredWithRecipeHasCorrectLabels() {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "RecipeDetailCellIdentifier",
            for: IndexPath(row: 0, section: 0)) as! RecipeDetailCell
        
        let recipe = Recipe(recipeId: "XX33",
                            imageUrl: URL(string: "www.recipe.com/image.jpg")!,
                            sourceUrl: URL(string: "www.recipe.com/source")!,
                            f2fUrl: URL(string: "www.recipe.com/f2f")!,
                            title: "Super recipe",
                            publisher: "Publisher",
                            publisherUrl: URL(string: "www.recipe.com/publisher")!,
                            socialRank: 99.3333,
                            ingredients: nil,
                            page: nil)
        
        cell.configure(recipe: recipe, delegate: controller)
        
        XCTAssertEqual(cell.publisherLabel.text, recipe.publisher)
        XCTAssertEqual(cell.rankLabel.text, "Social rank: \(round(recipe.socialRank))")
    }
    
}

extension RecipeDetailsCellTests {
    class FakeDataSource: NSObject, UITableViewDataSource {
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return 1
        }
        
        func numberOfSections(in tableView: UITableView) -> Int {
            return 1
        }
        
        func tableView(_ tableView: UITableView,
                       cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            return UITableViewCell()
        }
    }
}
