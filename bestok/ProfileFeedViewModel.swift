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
        public enum PagingState {
            case none, hasNextPage, loadingNextPage
        }
        case loading, display(feedVideos: [ProfileVideo], nextPageState: State.PagingState), error(error: Error)
    }
    
    var isLoadingFirstPage: Bool = true
    var isLoadingNextPage: Bool = true
    
    
    var state: State = .loading
    
    @Published var columns: [GridItem] = Array(
        repeating: .init(.flexible(minimum: 60, maximum: 120), spacing: 4),
        count: 3
    )
    var videoData: [ProfileVideo] = []
    @Published var cursorId: String = ""
    @Published var hasMore: Bool = false
    
    func fetchPostsUser(unique_id: String) async {
        print("FETCHING \(unique_id)")
        do {
            var nextPageState: State.PagingState = .none
            isLoadingFirstPage = true
            let posts = try await tiktokTranslator.translateforUserPosts(unique_id, cursorId: "")
             
            videoData = posts.datas.videos
            cursorId = posts.datas.cursor
            isLoadingFirstPage = false
            nextPageState = posts.datas.hasMore ? .hasNextPage : .none
            withAnimation {
                state = .display(feedVideos: videoData, nextPageState: nextPageState)
            }
        } catch {
            withAnimation {
                state = .error(error: error)
            }
        }

        
//        print("IS THERE ANY VIDEO DATA: \(videoData)")
    }
    
    func fetchForNextPosts(unique_id: String, cursor_id: String) async {
        do {
            var nextPageState: State.PagingState = .loadingNextPage
            state = .display(feedVideos: videoData, nextPageState: nextPageState)
            let nextPosts = try await tiktokTranslator.translateforUserPosts(unique_id, cursorId: cursor_id)
            
            videoData.append(contentsOf: nextPosts.datas.videos)
            cursorId = nextPosts.datas.cursor
            nextPageState = nextPosts.datas.hasMore ? .hasNextPage : .none
            print("SHOULD BE MORE: \(nextPosts.datas.hasMore)")
            hasMore = nextPosts.datas.hasMore
            state = .display(feedVideos: videoData, nextPageState: nextPageState)
            
        } catch {
            state = .display(feedVideos: videoData, nextPageState: .none)
        }
    }
    
}
