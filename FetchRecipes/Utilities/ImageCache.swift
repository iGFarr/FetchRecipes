//
//  ImageCache.swift
//  FetchRecipes
//
//  Created by Isaac Farr on 1/23/25.
//

import UIKit

class ImageCache {
    private var memoryCache: [String: UIImage] = [:]


    func loadImage(for url: URL) async throws -> UIImage? {
        let cacheKey = url.absoluteString

        // Check in-memory cache first
        if let cachedImage = memoryCache[cacheKey] {
            return cachedImage
        }


        // Download the image and cache it
        let (data, _) = try await URLSession.shared.data(from: url)
        let image = UIImage(data: data)
        if let image = image {
            memoryCache[cacheKey] = image // Save to memory
        }
        return image
    }
}
