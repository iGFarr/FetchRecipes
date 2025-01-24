//
//  RecipeDetailView.swift
//  FetchRecipes
//
//  Created by Isaac Farr on 1/23/25.
//

import SwiftUI
import WebKit

struct RecipeDetailView: View {
    let recipe: Recipe

    var body: some View {
        ScrollView {
            VStack(alignment: .center, spacing: 16) {
                // Recipe Image
                if let photoURLLarge = recipe.photoURLLarge {
                    AsyncImage(url: photoURLLarge) { phase in
                        switch phase {
                        case .success(let image):
                            image
                                .resizable()
                                .scaledToFit()
                        case .failure:
                            Color.gray
                        default:
                            ProgressView()
                        }
                    }
                    .frame(height: 200)
                }

                // Cuisine Type
                Text("Cuisine: \(recipe.cuisine)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)

                // YouTube Video Embed
                if let youtubeURL = recipe.youtubeURL {
                    YouTubeWebView(youtubeURL: youtubeURL)
                        .frame(height: 240)
                        .cornerRadius(8)
                }

                // Recipe Source Link
                if let sourceURL = recipe.sourceURL {
                    Link("View Full Recipe", destination: sourceURL)
                        .font(.headline)
                        .foregroundColor(.blue)
                }
            }
            .padding()
        }
        .navigationTitle(recipe.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct YouTubeWebView: UIViewRepresentable {
    let youtubeURL: URL

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.scrollView.isScrollEnabled = false
        return webView
    }

    func updateUIView(_ webView: WKWebView, context: Context) {
        let embedURL = youtubeURL.embedURL
        webView.load(URLRequest(url: embedURL))
    }
}

// Helper Extension to Convert YouTube URL to Embed URL
extension URL {
    var embedURL: URL {
        guard let videoID = queryParameters["v"] else { return self }
        return URL(string: "https://www.youtube.com/embed/\(videoID)") ?? self
    }

    var queryParameters: [String: String] {
        guard let query = self.query else { return [:] }
        return query
            .split(separator: "&")
            .reduce(into: [String: String]()) { result, pair in
                let parts = pair.split(separator: "=")
                if let key = parts.first, let value = parts.last {
                    result[String(key)] = String(value)
                }
            }
    }
}
