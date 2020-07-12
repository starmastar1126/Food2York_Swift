//
//  RecipeImageCellTests.swift
//  Recipy
//
//  Created by Sebastian Jolly on 7/20/19.
//  Copyright © 2019 Sebastian Jolly. All rights reserved.
//

import XCTest
@testable import Recipy

class RecipeImageCellTests: XCTestCase {
    
    var tableView: UITableView!
    let dataProvider = FakeDataSource()
    
    override func setUp() {
        super.setUp()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(
            withIdentifier: "RecipeDetailViewController") as! RecipeDetailViewController
        _ = controller.view
        tableView = controller.tableView
        tableView.dataSource = dataProvider
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testCellHasImageView() {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "RecipeImageCellIdentifier",
            for: IndexPath(row: 0, section: 0)) as! RecipeImageCell
        
        XCTAssertNotNil(cell.recipeImageView)
    }
    
    func testCellConfiguredWithImageIsSetInImageView() {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "RecipeImageCellIdentifier",
            for: IndexPath(row: 0, section: 0)) as! RecipeImageCell
        let image = UIImage()
        cell.configure(image: image)
        
        XCTAssertEqual(cell.recipeImageView.image, image)
    }
    
}

extension RecipeImageCellTests {
    class FakeDataSource: NSObject, UITableViewDataSource {
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return 1
        }
        
        func numberOfSections(in tableView: UITableView) -> Int {
            return 1
        }
        
        func tableView(_ tableView: UITableView,
                       cellForRowAt indexPath: IndexPath) ->
            UITableViewCell {
                return UITableViewCell()
        }
    }
}
