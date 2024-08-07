
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
    
    @Environment(\.scenePhase) private var scenePhase
    
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
            
            ScrollViewReader { proxy in
                ScrollView {
                    switch viewModel.state {
                    case .loading:
                        ProgressView()
                    case let .display(feedVideos, pagingState):
                        if feedVideos.isEmpty {
                            EmptyView()
                        } else {
                            
                            LazyVGrid(columns: viewModel.columns) {
                                ForEach(feedVideos) { profileVideo in
                                    ZStack {
                                        Img(url: profileVideo.originCover)
                                    }.onTapGesture {
                                        selectedVideo = profileVideo
                                    }.id(profileVideo.id)
                                }
                            }
                        }
  
                        
                        switch pagingState {
                        case .none:
                            EmptyView()
                        case .hasNextPage:
                            ProgressView().onAppear {
                                Task {
                                    await viewModel.fetchForNextPosts(unique_id: unique_id, cursor_id: viewModel.cursorId)
                                }
                            }
                        case .loadingNextPage:
                            ProgressView()
                        }
                    case .error(let error):
                        Text("Error something happened: \(error.localizedDescription)").font(karrik_font(.normal, font_size: 1))
                    }
                    
                }.coordinateSpace(name: "scroll").onAppear {
                    
                }.refreshable {
                    await viewModel.fetchPostsUser(unique_id: unique_id)
                }.onChange(of: viewModel.hasMore) { hasMore in
                    if hasMore {
                        Task {
                            viewModel.hasMore = false
                            await viewModel.fetchForNextPosts(unique_id: unique_id, cursor_id: viewModel.cursorId)
                        }
                    }

                }
            }
        }.onAppear {
            Task {
                await viewModel.fetchPostsUser(unique_id: unique_id)
            }
        }.onDisappear {
            
        }.fullScreenCover(item: $selectedVideo, onDismiss: {
            selectedVideo = nil
        }, content: { selected in
            DetailVideoView(profileVideo: selected)
        }).onChange(of: scenePhase) { _, newValue in
            switch newValue {
            case .active:
                Task {
                    await viewModel.fetchPostsUser(unique_id: unique_id)
                }
            default:
                break
            }
        }
        
    }
    
    private func Img(url: URL) -> some View {
        KFAnimatedImage(url).setProcessor(WebPProcessor.default).serialize(by: WebPSerializer.default).callbackQueue(.dispatch(.global(qos: .background))).aspectRatio(contentMode: .fit).clipped().id(url.absoluteString).padding(0)
    }
    
    private func scrollToEvent() {
        
    }
}

#Preview {
    ProfileFeedView(unique_id: .constant("fujiiaan"))
}
