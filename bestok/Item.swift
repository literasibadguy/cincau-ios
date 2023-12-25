//
//  Item.swift
//  bestok
//
//  Created by Firas Rafislam on 25/12/2023.
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
