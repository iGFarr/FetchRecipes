//
//  ImageCache.swift
//  FetchRecipes
//
//  Created by Isaac Farr on 1/23/25.
//

import UIKit

class ImageCache {
    static let shared = ImageCache()
    private var memoryCache: [String: UIImage] = [:]

    private init() {}

    func isImageInCache(for url: URL) -> Bool {
        let cacheKey = url.absoluteString
        if let cachedImage = memoryCache[cacheKey] {
            return true
        }
        return false
    }
    
    func loadImage(for url: URL) async throws -> UIImage? {
        let cacheKey = url.absoluteString

        // Check in-memory cache first
        if isImageInCache(for: url) {
            return memoryCache[cacheKey]
        }

        // Download the image and cache it
        let (data, _) = try await URLSession.shared.data(from: url)
        let image = UIImage(data: data)
        if let image = image {
            await MainActor.run {
                memoryCache[cacheKey] = image
            }
        }
        return image
    }
}
