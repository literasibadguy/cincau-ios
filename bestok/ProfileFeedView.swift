
//  ProfileFeedView.swift
//  bestok
//
//  Created by Firas Rafislam on 05/01/2024.
//

import SwiftUI
import Kingfisher
import KingfisherWebP

struct ProfileFeedView: View {
    
    @StateObject private var viewModel: ProfileFeedViewModel = ProfileFeedViewModel()
    @StateObject private var tiktokTranslator: TiktokTranslator = TiktokTranslator()
    
    @EnvironmentObject private var navigationCoordinator: NavigationCoordinator
    
    @Binding var unique_id: String
    
    @State private var selectedVideo: ProfileVideo?
    
    var body: some View {
        VStack {
            Text(unique_id).font(karrik_font(.title, font_size: 1))
            
            ScrollView {
                LazyVGrid(columns: viewModel.columns) {
                    ForEach(viewModel.videoData) { profileVideo in
                        ZStack {
                            Img(url: profileVideo.cover)
                        }.onTapGesture {
                            selectedVideo = profileVideo
                        }
                    }
                }
            }
        }.onAppear {
            Task {
                await viewModel.fetchPostsUser(unique_id: unique_id)
            }
        }.fullScreenCover(item: $selectedVideo, onDismiss: {
            selectedVideo = nil
        }, content: { selected in
            DetailVideoView(profileVideo: selected)
        })
        
    }
    
    private func Img(url: URL) -> some View {
        KFAnimatedImage(url).setProcessor(WebPProcessor.default).serialize(by: WebPSerializer.default).callbackQueue(.dispatch(.global(qos: .background))).aspectRatio(contentMode: .fit).clipped().id(url.absoluteString).padding(0)
    }
}

#Preview {
    ProfileFeedView(unique_id: .constant("fujiiaan"))
}
