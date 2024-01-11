
//  ProfileFeedView.swift
//  bestok
//
//  Created by Firas Rafislam on 05/01/2024.
//

import SwiftUI
import Kingfisher
import KingfisherWebP

struct ProfileDismissBarView: View {
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        HStack(alignment: .center) {
            Spacer()
            
            Button(action: {
                dismiss()
            }, label: {
                Image(systemName: "xmark.circle.fill")
                    .frame(width: 33, height: 33)
                    .background(.regularMaterial)
                    .clipShape(Circle()).foregroundStyle(.black)
            })
            

        }
    }
}

struct ProfileFeedView: View {
    
    @StateObject private var viewModel: ProfileFeedViewModel = ProfileFeedViewModel()
    @StateObject private var tiktokTranslator: TiktokTranslator = TiktokTranslator()
    
    @EnvironmentObject private var navigationCoordinator: NavigationCoordinator
    
    @Binding var unique_id: String
    
    @State private var selectedVideo: ProfileVideo?
    
    var body: some View {
        VStack {
            HStack(alignment: .center) {
                Text(unique_id).font(karrik_font(.normal, font_size: 1))
                
                ProfileDismissBarView()
            }.padding()
            
            ScrollView {
                switch viewModel.state {
                case .loading:
                    ProgressView()
                case .display(let feedVideos):
                    LazyVGrid(columns: viewModel.columns) {
                        ForEach(feedVideos) { profileVideo in
                            ZStack {
                                Img(url: profileVideo.originCover)
                            }.onTapGesture {
                                selectedVideo = profileVideo
                            }
                        }
                    }
                case .error(let error):
                    Text("Error something happened")
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
