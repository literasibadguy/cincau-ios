//
//  TrendingFeedViewModel.swift
//  bestok
//
//  Created by Firas Rafislam on 08/01/2024.
//

import Foundation

@MainActor
class TrendingFeedViewModel: ObservableObject {
    
    private let tiktokTranslator: TiktokTranslator = TiktokTranslator()
    
    @Published var trendingVideos: [TrendVideo] = []
    
    func fetchTrendingData() async {
        do {
            let fetchedTrending = try await tiktokTranslator.translateForTrendingPosts("JP")
            
            trendingVideos = fetchedTrending.datas
        } catch {
            print("Can't getting trending data")
        }
    }
}
