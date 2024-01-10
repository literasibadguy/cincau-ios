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
    case Profile(uniqueId: String)
    case DetailVideo(videoData: ProfileVideo)
    
    @ViewBuilder
    func view(navigationCoordinator: NavigationCoordinator) -> some View {
        switch self {
        case .Profile(let uniqueId):
            ProfileFeedView(unique_id: .constant(uniqueId))
        case .DetailVideo(let videoData):
            DetailVideoView(profileVideo: videoData)
        }
    }
    
    static func == (lhs: Route, rhs: Route) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
    
    func hash(into hasher: inout Hasher) {
        switch self {
        case .Profile(let uniqueid):
            hasher.combine("profile")
            hasher.combine(uniqueid)
        case .DetailVideo(let videoData):
            hasher.combine("detailVideo")
            hasher.combine(videoData)
        }
    }
}

class NavigationCoordinator: ObservableObject {
    @Published var path = [Route]()
    
    func push(route: Route) {
        print("pushing to : \(route)")
        guard route != path.last else {
            return
        }
        path.append(route)
    }
    
    func isAtRoot() -> Bool {
        return path.count == 0
    }
    
    func popToRoot() {
        path = []
    }
}
