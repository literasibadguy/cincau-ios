//
//  ProfileFeedViewModel.swift
//  bestok
//
//  Created by Firas Rafislam on 08/01/2024.
//

import SwiftUI

@MainActor
class ProfileFeedViewModel: ObservableObject {
    
    
    let tiktokTranslator = TiktokTranslator()
    
    enum State {
        case loading, display(feedVideos: [ProfileVideo]), error(error: Error)
    }
    
    var state: State = .loading
    
    @Published var columns: [GridItem] = Array(
        repeating: .init(.flexible(minimum: 60, maximum: 120), spacing: 4),
        count: 3
    )
    @Published var videoData: [ProfileVideo] = []
    
    func fetchPostsUser(unique_id: String) async {
        print("FETCHING \(unique_id)")
        do {
            state = .loading
            let posts = try await tiktokTranslator.translateforUserPosts(unique_id)
            
            videoData = posts.datas.videos
            withAnimation {
                state = .display(feedVideos: videoData)
            }
        } catch {
            withAnimation {
                state = .error(error: error)
            }
        }

        
//        print("IS THERE ANY VIDEO DATA: \(videoData)")
    }
    
}
