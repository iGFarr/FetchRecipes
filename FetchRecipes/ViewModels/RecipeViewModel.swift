//
//  RecipeViewModel.swift
//  FetchRecipes
//
//  Created by Isaac Farr on 1/23/25.
//

import Foundation

struct IdentifiableString: Identifiable {
    let id = UUID()
    let value: String
}

@MainActor
class RecipeViewModel: ObservableObject {
    @Published var recipes: [Recipe] = []
    @Published var errorMessage: IdentifiableString? = nil
    private let apiClient = RecipeAPIClient()

    func fetchRecipes() async {
        do {
            let fetchedRecipes = try await apiClient.fetchRecipes()
            recipes = fetchedRecipes
        } catch {
            errorMessage = IdentifiableString(value: "Failed to load recipes. Please try again.")
        }
    }
}
