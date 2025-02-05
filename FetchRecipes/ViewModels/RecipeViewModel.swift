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
    @Published var filteredRecipes: [Recipe] = []
    @Published var errorMessage: IdentifiableString? = nil
    @Published var currentSortOption: SortOption = .nameAsc
    private let apiClient = RecipeAPIClient()

    func fetchRecipes() async {
        do {
            let fetchedRecipes = try await apiClient.fetchRecipes()
            recipes = fetchedRecipes
            filteredRecipes = fetchedRecipes
            sortRecipes(by: currentSortOption)
        } catch {
            errorMessage = IdentifiableString(value: "Failed to load recipes. Please try again.")
        }
    }

    func filterRecipes(by searchText: String) {
        if searchText.isEmpty {
            filteredRecipes = recipes
        } else {
            filteredRecipes = recipes.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
    }

    func sortRecipes(by option: SortOption) {
        currentSortOption = option
        switch option {
        case .nameAsc:
            filteredRecipes.sort { $0.name < $1.name }
        case .nameDesc:
            filteredRecipes.sort { $0.name > $1.name }
        case .cuisineAsc:
            filteredRecipes.sort { $0.cuisine < $1.cuisine }
        case .cuisineDesc:
            filteredRecipes.sort { $0.cuisine > $1.cuisine }
        }
    }
}
