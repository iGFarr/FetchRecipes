//
//  RecipeListItem.swift
//  FetchRecipes
//
//  Created by Isaac Farr on 1/23/25.
//

import SwiftUI

struct RecipeListItem: View {
    private let recipe: Recipe
    private let imageCache = ImageCache()
    @State private var cachedImage: UIImage?

    init(recipe: Recipe) {
        self.recipe = recipe
    }

    var body: some View {
        NavigationLink(destination: RecipeDetailView(recipe: recipe)) {
            HStack {
                if let image = cachedImage {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 50)
                        .cornerRadius(8)
                } else {
                    ProgressView()
                        .frame(width: 50, height: 50)
                        .onAppear {
                            loadImage()
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

    private func loadImage() {
        guard let url = recipe.photoURLSmall else { return }

        Task {
            do {
                let image = try await imageCache.loadImage(for: url)
                DispatchQueue.main.async {
                    cachedImage = image
                }
            } catch {
                print("Failed to load image for URL \(url): \(error)")
            }
        }
    }
}
