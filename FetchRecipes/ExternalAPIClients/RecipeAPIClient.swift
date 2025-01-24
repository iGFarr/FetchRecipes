//
//  RecipeAPIClient.swift
//  FetchRecipes
//
//  Created by Isaac Farr on 1/23/25.
//

import Foundation

class RecipeAPIClient {
    private let url: URL
//  private let url = URL(string: "https://d3jbb8n5wk0qxi.cloudfront.net/recipes-malformed.json")!
//  private let url = URL(string: "https://d3jbb8n5wk0qxi.cloudfront.net/recipes-empty.json")!
    
    init(url: URL = URL(string: "https://d3jbb8n5wk0qxi.cloudfront.net/recipes.json")!) {
        self.url = url
    }

    func fetchRecipes() async throws -> [Recipe] {
        let (data, _) = try await URLSession.shared.data(from: url)
        let decodedData = try JSONDecoder().decode([String: [Recipe]].self, from: data)
        return decodedData["recipes"] ?? []
    }
}
