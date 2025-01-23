//
//  Recipe.swift
//  FetchRecipes
//
//  Created by Isaac Farr on 1/23/25.
//

import Foundation

struct Recipe: Codable, Identifiable {
    let id: UUID
    let name: String
    let cuisine: String
    let photoURLSmall: URL?
    let photoURLLarge: URL?

    enum CodingKeys: String, CodingKey {
        case id = "uuid"
        case name
        case cuisine
        case photoURLSmall = "photo_url_small"
        case photoURLLarge = "photo_url_large"
    }
}
