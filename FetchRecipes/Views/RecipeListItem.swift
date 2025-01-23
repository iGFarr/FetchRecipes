//
//  RecipeListItem.swift
//  FetchRecipes
//
//  Created by Isaac Farr on 1/23/25.
//

import SwiftUI

struct RecipeListItem: View {
    private let recipe: Recipe

    init(recipe: Recipe) {
        self.recipe = recipe
    }

    var body: some View {
        NavigationLink(destination: RecipeDetailView(recipe: recipe)) {
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
    }
}
