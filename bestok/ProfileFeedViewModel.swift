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
    
    @Published var columns: [GridItem] = Array(
        repeating: .init(.flexible(minimum: 60, maximum: 120), spacing: 4),
        count: 3
    )
    @Published var videoData: [ProfileVideo] = []
    
    func fetchPostsUser() async {
        
        let posts = try? await tiktokTranslator.translateforUserPosts("jinnytty0728")
        
        guard let posts else { return }
        videoData = posts.datas.videos
        
        print("IS THERE ANY VIDEO DATA: \(videoData)")
    }
    
}
