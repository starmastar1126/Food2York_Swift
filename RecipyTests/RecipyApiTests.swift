//
//  RecipyTests.swift
//  RecipyTests
//
//  Created by Sebastian Jolly on 7/20/19.
//  Copyright © 2019 Sebastian Jolly. All rights reserved.
//

import XCTest
@testable import Recipy

class RecipyApiTests: XCTestCase {
    
    let sut = RecipeAPI.shared
    var mockURLSession: MockURLSession!
    
    override func setUp() {
        super.setUp()
        mockURLSession = MockURLSession()
        sut.session = mockURLSession
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    // Not used but nice
    func waitUntil(asyncProcess: (_ done: @escaping () -> Void) -> Void) {
        let myExpectation = expectation(description: "async call complete")
        let done = { myExpectation.fulfill() }
        asyncProcess(done)
        waitForExpectations(timeout: 10)
    }
    
    func testSearchMakeRequest() {
        
        let completion = { (recipes: [Recipe]) in }
        sut.recipe(matching: "ham", completion: completion)
        
        XCTAssertNotNil(mockURLSession.completionHandler)
        
        guard let url = mockURLSession.url else { XCTFail(); return }
        let urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true)
        XCTAssertEqual(urlComponents?.host, "food2fork.com")
        
        XCTAssertEqual(urlComponents?.path, "/api/search")
        
        XCTAssertEqual(urlComponents?.query, "key=0714e27e76464dc4c5135f36e726e364&q=ham&page=1")
    }
    
    func testSearchCallsResumeOfDataTask() {
        let completion = { (recipes: [Recipe]) in }
        sut.recipe(matching: "search", completion: completion)
        
        XCTAssertTrue(mockURLSession.dataTask.resumeGotCalled)
    }
    
    func testGetRecipeMakeRequest() {
        let completion = { (recipes: Recipe?) in }
        sut.recipe(id: "22eeX", completion: completion)
        
        XCTAssertNotNil(mockURLSession.completionHandler)
        
        guard let url = mockURLSession.url else { XCTFail(); return }
        let urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true)
        XCTAssertEqual(urlComponents?.host, "food2fork.com")
        
        XCTAssertEqual(urlComponents?.path, "/api/get")
        
        XCTAssertEqual(urlComponents?.query, "key=0714e27e76464dc4c5135f36e726e364&rId=22eeX")
    }
    
    func testGetRecipeCallsResumeOfDataTask() {
        let completion = { (recipes: Recipe?) in }
        sut.recipe(id: "22eeX", completion: completion)
        
        XCTAssertTrue(mockURLSession.dataTask.resumeGotCalled)
    }
    
    func testImageDownloadMakeRequest() {
        let completion = { (image: UIImage?) in }
        let url = URL(string: "www.food2fork.com/image.jpg")!
        sut.downloadImage(at: url, completion: completion)
        
        XCTAssertNotNil(mockURLSession.completionHandler)
    }
    
    func testImageDownloadCallsResumeOfDataTask() {
        let completion = { (image: UIImage?) in }
        let url = URL(string: "www.food2fork.com/image.jpg")!
        sut.downloadImage(at: url, completion: completion)
        
        XCTAssertTrue(mockURLSession.dataTask.resumeGotCalled)
    }
    
    func testCancelImageDownloadCallsCancelOfDataTask() {
        let completion = { (image: UIImage?) in }
        let url = URL(string: "www.food2fork.com/image.jpg")!
        sut.downloadImage(at: url, completion: completion)
        sut.cancelImageDownload()
        
        XCTAssertTrue(mockURLSession.dataTask.cancelGotCalled)
    }
}

extension RecipyApiTests {
    class MockURLSession: RecipeURLSession {
        typealias Handler = (Data?, URLResponse?, Error?) -> Void
        
        var completionHandler: Handler?
        var url: URL?
        var dataTask = MockURLSessionDataTask()
        
        func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
            self.url = url
            self.completionHandler = completionHandler
            return dataTask
        }
    }
    
    class MockURLSessionDataTask : URLSessionDataTask {
        var resumeGotCalled = false
        var cancelGotCalled = false
        
        override func resume() {
            resumeGotCalled = true
        }
        
        override func cancel() {
            cancelGotCalled = true
        }
    }
}
