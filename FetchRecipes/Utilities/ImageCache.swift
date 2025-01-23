//
//  ImageCache.swift
//  FetchRecipes
//
//  Created by Isaac Farr on 1/23/25.
//

import UIKit

class ImageCache {
    private let cacheDirectory: URL

    init() {
        let paths = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)
        cacheDirectory = paths[0]
    }

    func loadImage(for url: URL) async throws -> UIImage? {
        let cachePath = cacheDirectory.appendingPathComponent(url.lastPathComponent)

        if FileManager.default.fileExists(atPath: cachePath.path) {
            return UIImage(contentsOfFile: cachePath.path)
        }

        let (data, _) = try await URLSession.shared.data(from: url)
        try data.write(to: cachePath)
        return UIImage(data: data)
    }
}
