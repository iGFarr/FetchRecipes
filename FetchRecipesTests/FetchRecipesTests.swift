//
//  FetchRecipesTests.swift
//  FetchRecipesTests
//
//  Created by Isaac Farr on 1/23/25.
//

import XCTest
@testable import FetchRecipes

class FetchRecipesTests: XCTestCase {
    func testFetchRecipes() async throws {
        // Test API client fetches recipes successfully
        let apiClient = RecipeAPIClient()
        let recipes = try await apiClient.fetchRecipes()
        XCTAssertFalse(recipes.isEmpty, "Recipes should not be empty.")
    }

    func testMalformedRecipes() async throws {
        // Test handling of malformed data
        let apiClient = RecipeAPIClient(url: URL(string: "https://d3jbb8n5wk0qxi.cloudfront.net/recipes-malformed.json")!)
        do {
            let _ = try await apiClient.fetchRecipes()
            XCTFail("Malformed data should throw an error.")
        } catch {
            XCTAssert(true, "Correctly handled malformed data.")
        }
    }

    func testEmptyRecipes() async throws {
        // Test handling of empty data
        let apiClient = RecipeAPIClient(url: URL(string: "https://d3jbb8n5wk0qxi.cloudfront.net/recipes-empty.json")!)
        let recipes = try await apiClient.fetchRecipes()
        XCTAssertTrue(recipes.isEmpty, "Recipes should be empty.")
    }

    func testImageCaching() async throws {
        // Test caching mechanism loads image from network correctly
        let cache = ImageCache.shared
        let testURL = URL(string: "https://picsum.photos/200/300")!
        let image = try await cache.loadImage(for: testURL)
        XCTAssertNotNil(image, "Image should be loaded successfully.")

        // Test retrieving the cached image
        let cachedImageSuccessfully = cache.isImageInCache(for: testURL)
        XCTAssert(cachedImageSuccessfully, "Image should be retrieved from cache.")
    }

    @MainActor func testRecipeFiltering() {
        // Test filtering logic in the ViewModel
        let viewModel = RecipeViewModel()
        viewModel.recipes = [
            Recipe(id: UUID(), name: "Apple Pie", cuisine: "American", photoURLSmall: nil, photoURLLarge: nil, sourceURL: nil, youtubeURL: nil),
            Recipe(id: UUID(), name: "Banana Bread", cuisine: "American", photoURLSmall: nil, photoURLLarge: nil, sourceURL: nil, youtubeURL: nil)
        ]
        viewModel.filterRecipes(by: "Apple")
        XCTAssertEqual(viewModel.filteredRecipes.count, 1, "Filtering should return only recipes matching the query.")
        XCTAssertEqual(viewModel.filteredRecipes.first?.name, "Apple Pie", "Filtered recipe name should match.")
    }

    @MainActor func testRecipeSorting() {
        // Test sorting logic in the ViewModel
        let viewModel = RecipeViewModel()
        viewModel.recipes = [
            Recipe(id: UUID(), name: "Banana Bread", cuisine: "American", photoURLSmall: nil, photoURLLarge: nil, sourceURL: nil, youtubeURL: nil),
            Recipe(id: UUID(), name: "Apple Pie", cuisine: "American", photoURLSmall: nil, photoURLLarge: nil, sourceURL: nil, youtubeURL: nil)
        ]
        viewModel.filteredRecipes = viewModel.recipes
        
        viewModel.sortRecipes(by: .nameAsc)
        XCTAssertEqual(viewModel.filteredRecipes.first?.name, "Apple Pie", "Recipes should be sorted alphabetically by name.")

        viewModel.sortRecipes(by: .nameDesc)
        XCTAssertEqual(viewModel.filteredRecipes.first?.name, "Banana Bread", "Recipes should be sorted in reverse alphabetical order by name.")
    }
}
