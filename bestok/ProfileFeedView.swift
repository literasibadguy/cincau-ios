//
//  ProfileFeedView.swift
//  bestok
//
//  Created by Firas Rafislam on 05/01/2024.
//

import SwiftUI
import Kingfisher

struct ProfileFeedView: View {
    
    @StateObject private var viewModel: ProfileFeedViewModel = ProfileFeedViewModel()
    @StateObject private var tiktokTranslator: TiktokTranslator = TiktokTranslator()
    
    var body: some View {
        VStack {
            Text("Kang Seulgi")
            
            ScrollView {
                LazyVGrid(columns: viewModel.columns) {
                    ForEach(viewModel.videoData) { videos in
                        ZStack {
                            Img(url: videos.cover)
                        }
                    }
                }
            }
        }.onAppear {
            Task {
                
                await viewModel.fetchPostsUser()
            }
        }
        
    }
    
    private func Img(url: URL) -> some View {
        KFAnimatedImage(url).callbackQueue(.dispatch(.global(qos: .background))).aspectRatio(contentMode: .fit).clipped().id(url.absoluteString).padding(0)
    }
}

#Preview {
    ProfileFeedView()
}
