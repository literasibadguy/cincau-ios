//
//  Router.swift
//  bestok
//
//  Created by Firas Rafislam on 06/01/2024.
//

import Foundation
import UIKit
import SwiftUI

enum Route: Hashable {
    case Profile
    
    @ViewBuilder
    func view(navigationCoordinator: NavigationCoordinator) -> some View {
        switch self {
        case .Profile:
            ProfileFeedView()
        }
    }
    
    static func == (lhs: Route, rhs: Route) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
    
    func hash(into hasher: inout Hasher) {
        switch self {
        case .Profile:
            hasher.combine("profile")
        }
    }
}

class NavigationCoordinator: ObservableObject {
    
    func push(route: Route) {
        
    }
}
