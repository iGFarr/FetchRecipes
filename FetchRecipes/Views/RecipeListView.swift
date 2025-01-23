//
//  RecipeListView.swift
//  FetchRecipes
//
//  Created by Isaac Farr on 1/23/25.
//

import SwiftUI

struct RecipeListView: View {
    @StateObject private var viewModel = RecipeViewModel()
    private let imageCache = ImageCache()

    var body: some View {
        NavigationView {
            List(viewModel.recipes) { recipe in
                HStack {
                    AsyncImage(url: recipe.photoURLSmall) { phase in
                        switch phase {
                        case .success(let image):
                            image
                                .resizable()
                                .scaledToFit()
                                .frame(width: 50, height: 50)
                                .cornerRadius(8)
                        case .failure:
                            Color.gray
                                .frame(width: 50, height: 50)
                                .cornerRadius(8)
                        default:
                            ProgressView()
                                .frame(width: 50, height: 50)
                        }
                    }

                    VStack(alignment: .leading) {
                        Text(recipe.name)
                            .font(.headline)
                        Text(recipe.cuisine)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
            }
            .navigationTitle("Recipes")
            .refreshable {
                await viewModel.fetchRecipes()
            }
            .task {
                await viewModel.fetchRecipes()
            }
            .alert(item: $viewModel.errorMessage) { error in
                Alert(title: Text("Error"), message: Text(error.value), dismissButton: .default(Text("OK")))
            }
        }
    }
}
