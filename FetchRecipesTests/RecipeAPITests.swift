//
//  RecipeAPITests.swift
//  FetchRecipesTests
//
//  Created by Isaac Farr on 1/23/25.
//

import XCTest
@testable import FetchRecipes

class RecipeAPITests: XCTestCase {
    func testFetchRecipes() async throws {
        let apiClient = RecipeAPIClient()
        let recipes = try await apiClient.fetchRecipes()
        XCTAssertFalse(recipes.isEmpty, "Recipes should not be empty.")
    }

    func testImageCaching() async throws {
        let cache = ImageCache()
        let testURL = URL(string: "https://some.url/small.jpg")!
        let image = try await cache.loadImage(for: testURL)
        XCTAssertNotNil(image, "Image should be cached successfully.")
    }
}
