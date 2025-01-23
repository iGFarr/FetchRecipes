//
//  Item.swift
//  FetchRecipes
//
//  Created by Isaac Farr on 1/23/25.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
