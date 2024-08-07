//
//  TrendingVideoView.swift
//  bestok
//
//  Created by Firas Rafislam on 09/01/2024.
//

import SwiftUI

// Temporary for giving item video view on trending

struct TrendingVideoView: View {
    
    let videoData: TrendVideo
    
    @State private var completed = false
    @State private var tiktokUrl = ""
    
    @State private var show_share_sheet = false
    @State private var show_texts = true
    
    @State private var is_timeline = true
    
    @StateObject private var converseViewModel: ConverseViewModel
    

    
    var body: some View {
        ZStack {
            Color(.black).ignoresSafeArea()
            
            ShortVideoPlayer(url: videoData.play, video_size: .constant(nil), controller: VideoController(), tapInteraction: {
                withAnimation {
                    show_texts.toggle()
                }
            })
            
            VStack {
                HStack() {
                    
                    VStack(alignment: .leading) {
                        Text(videoData.author.nickname).font(karrik_font(.title, font_size: 1))
                        Text(videoData.author.uniqueId).font(karrik_font(.subheadline, font_size: 1))
                    }
                    
                    Spacer()
                    
                }.padding().padding(.top, 45)
                
                
                Spacer()
            }
            
            VStack {
                
                Spacer()
                
                if show_texts {
                    
                    Text(videoData.title).font(karrik_font(.small, font_size: 1)).foregroundStyle(.white)
                }
                
                Button(action: {
//                    Task {
//                        let converseStatus = await converse_tiktok(linkUrl: tiktokUrl)
//                        tiktokVideo = converseStatus
//                    }
                    show_share_sheet = true
                }, label: {
                    HStack {
                        Group {
                            switch converseViewModel.state {
                            case .havent_converse:
                                Text("Download").font(karrik_font(.normal, font_size: 1)).foregroundStyle(.white)
                                
                            case .conversed(_):
                                Text("Completed").font(karrik_font(.normal, font_size: 1)).foregroundStyle(.white)
                                
                            case .error:
                                Text("Error").font(karrik_font(.normal, font_size: 1)).foregroundStyle(.red)
                                
                            case .conversing:
                                Text("Downloading").font(karrik_font(.normal, font_size: 1)).foregroundStyle(.red)
                                
                            }
                        }
                    }.frame(minWidth: 300, maxWidth: .infinity, alignment: .center)
                }).buttonStyle(WhiteBorderButtonStyle(padding: 16)).padding()
                
                if converseViewModel.downloading {
                    ProgressView(value: converseViewModel.totalWritten)
                }
                
                
            }.padding(.bottom, 100)
            
            VStack {
                
                Spacer()
                
                HStack {
                    
                    VStack(alignment: .leading) {
                        Text(videoData.musicInfo.title).font(karrik_font(.small, font_size: 1))
                        Text(videoData.musicInfo.author).font(karrik_font(.small, font_size: 1))
                    }
                    
                    Spacer()
                }
            }.padding(.bottom, is_timeline ? 36 : 12).padding(.leading, 10)
            
        }.sheet(isPresented: $show_share_sheet) {
//            DownloadActionSheetView(videoData: videoData, downloadAction: {
//                show_share_sheet = true
//                converseViewModel.downloadVideo(url: videoData.hdPlay)
                
//            }).frame(height: 360).presentationBackground(.clear)
        }.overlay {
            GeometryReader {_ in 
                VStack {
                    
                    HStack {
                        Spacer()
                        NavDismissBarView()
                        
                    }
                        
                    Spacer()
                }
            }


            
        }.statusBarHidden(false)
    }

}

//#Preview {
//    TrendingVideoView()
//}
