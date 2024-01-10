//
//  TrendingFeedView.swift
//  bestok
//
//  Created by Firas Rafislam on 29/12/2023.
//

import SwiftUI


struct TrendingFeedView: View {
    
    public enum IndexPosition {
            case leading
            case trailing
        }
    
    private var indexPosition: IndexPosition = .trailing
    
    @StateObject private var viewModel: TrendingFeedViewModel = TrendingFeedViewModel()
    
    var body: some View {
        GeometryReader { proxy in
                
                TabView {
                    if !viewModel.trendingVideos.isEmpty {
                        ForEach(viewModel.trendingVideos) { trendVideo in
                            
                        }
                    }
                    DetailVideoView(videoData: .sample).frame(width: proxy.size.width, height: proxy.size.height).rotationEffect(.degrees(-90))
                        .rotation3DEffect(flippingAngle, axis: (x: 1, y: 0, z: 0)).offset(y: -10)

                    
                }.onAppear {
                    Task {
                        
                    }
                }.frame(width: proxy.size.height, height: proxy.size.width)
                    .rotation3DEffect(flippingAngle, axis: (x: 1, y: 0, z: 0))
                    .rotationEffect(.degrees(90), anchor: .topLeading)
                    .offset(x: proxy.size.width)
        }.ignoresSafeArea(.all, edges: [.trailing, .leading, .top, .bottom]).tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
    }
    
    private var flippingAngle: Angle {
            switch indexPosition {
            case .leading:
                return .degrees(0)
            case .trailing:
                return .degrees(180)
            }
        }
}

#Preview {
    TrendingFeedView()
}
