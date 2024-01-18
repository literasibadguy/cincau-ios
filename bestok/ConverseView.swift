//
//  ConverseView.swift
//  bestok
//
//  Created by Firas Rafislam on 25/12/2023.
//

import SwiftUI

enum FontViewKind {
    case small
    case normal
    case selected
    case title
    case subheadline
}


enum ConverseStatus: Equatable {
    case havent_converse
    case conversing
    case conversed(URL)
    case error
}

enum DownloadType: Equatable {
    case hdPlay
    case playWatermark
    case play
}

struct NavDismissBarView: View {
    
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
                    .clipShape(Circle()).foregroundStyle(.windowBackground)
            })
            

        }
        .padding().padding(.top, 45)
    }
}


struct WhiteBorderButtonStyle: ButtonStyle {
    let padding: CGFloat
    
    init(padding: CGFloat) {
        self.padding = padding
    }
    
    func makeBody(configuration: Configuration) -> some View {
        return configuration.label
            .padding(padding)
            .background {
                RoundedRectangle(cornerRadius: 12).stroke(Color.white, lineWidth: 1)
            }.scaleEffect(configuration.isPressed ? 0.85 : 1.0)
    }
}

func karrik_font(_ size: FontViewKind, font_size: Double) -> Font {
    switch size {
    case .small:
        return .custom("Karrik-Regular", size: 12.0 * font_size)
    case .normal:
        return .custom("Karrik-Regular", size: 17.0) // Assuming .body is 17pt by default
    case .selected:
        return .custom("Karrik-Regular", size: 21.0)
    case .title:
        return .custom("Karrik-Regular", size: 24.0 * font_size) // Assuming .title is 24pt by default
    case .subheadline:
        return .custom("Karrik-Regular", size: 14.0 * font_size) // Assuming .subheadline is 14pt by default
    }
}



struct DetailVideoView: View {
    
    
    @State private var completed = false
    @State private var tiktokUrl = ""
    
    @State private var show_share_sheet = false
    @State private var show_texts = true
    
    @State private var is_timeline = true
    
    @StateObject private var converseViewModel: ConverseViewModel
    
    init(videoData: TiktokData) {
//        self.videoData = videoData
        _converseViewModel = StateObject(wrappedValue: ConverseViewModel(state: .havent_converse, videoData: videoData))
    }
    
    init(trendingData: TrendVideo) {
        _converseViewModel = StateObject(wrappedValue: .init(trendData: trendingData))
    }
    
    init(profileVideo: ProfileVideo) {
        _converseViewModel = StateObject(wrappedValue: .init(profileVideo: profileVideo))
    }
    
    var ConverseButton: some View {
        Button("Download Video") {
//            converse()
        }
    }
    
    var body: some View {
        ZStack {
            Color(.black).ignoresSafeArea()
            
            ShortVideoPlayer(url: converseViewModel.playUrl!, video_size: .constant(nil), controller: VideoController(), tapInteraction: {
                withAnimation {
                    show_texts.toggle()
                }
            })
            
            switch converseViewModel.loadState {
            case .initial:
                EmptyView()
            case .loading:
                ProgressView()
            case .display(_):
               EmptyView()
            case .error(_):
                Text("Something error")
            }
            
            VStack {
                HStack() {
                    
                    
                    
                    VStack(alignment: .leading) {
                        Text(converseViewModel.authorName).font(karrik_font(.title, font_size: 1)).foregroundStyle(.windowBackground)
                        Text(converseViewModel.uniqueId).font(karrik_font(.subheadline, font_size: 1)).foregroundStyle(.windowBackground)
                    }
                    
                    Spacer()
                    
                }.padding().padding(.top, 45)
                
                
                Spacer()
            }
            
            VStack {
                
                Spacer()
                
                if show_texts {
                    Text(converseViewModel.title).font(karrik_font(.small, font_size: 1)).foregroundStyle(.windowBackground)
                }
                
                Button(action: {

                    if (converseViewModel.videoData != nil) {
                        show_share_sheet = true
                    }
                    Task {
                        await converseViewModel.getExtraVideoData()
                    }
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
                            
//                            switch converseViewModel.loadState {
//                            case .initial:
//                                Text("Download").font(karrik_font(.normal, font_size: 1)).foregroundStyle(.white)
//                                break
//                            case .loading:
//                                Text("Please wait").font(karrik_font(.normal, font_size: 1)).foregroundStyle(.white)
//                                break
//                            case .display(_):
//                                Text("Download").font(karrik_font(.normal, font_size: 1)).foregroundStyle(.white)
//                                break
//                            case .error(_):
//                                Text("Error").font(karrik_font(.normal, font_size: 1)).foregroundStyle(.white)
//                                break
//                            }
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
                        Text(converseViewModel.titleMusic).font(karrik_font(.small, font_size: 1)).foregroundStyle(.windowBackground)
                        Text(converseViewModel.artistMusic).font(karrik_font(.small, font_size: 1)).foregroundStyle(.windowBackground)
                    }
                    
                    Spacer()
                }
            }.padding(.bottom, is_timeline ? 36 : 12).padding(.leading, 10)
            
        }.sheet(isPresented: $show_share_sheet) {
            if let videoData = converseViewModel.videoData {
                DownloadActionSheetView(videoData: videoData, downloadAction: {
                    show_share_sheet = true
                    converseViewModel.downloadVideo(url: videoData.hdPlay)
                    
                }).frame(height: 360).presentationBackground(.clear)
            }
        }.sheet(item: $converseViewModel.videoData) { videoData in
            DownloadActionSheetView(videoData: videoData, downloadAction: {
                show_share_sheet = true
                converseViewModel.downloadVideo(url: videoData.hdPlay)
                
            }).frame(height: 360).presentationBackground(.clear)
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
    
//    func converse_tiktok(linkUrl: String) async -> TiktokData? {
//        let conversed_tiktok = try? await converseViewModel.translateForVideoData(linkUrl)
//        
//        guard let conversed_tiktok else {
//            return nil
//        }
//        
//        return conversed_tiktok
//    }
    

}

struct BackgroundClearView: UIViewRepresentable {
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        DispatchQueue.main.async {
            view.superview?.superview?.backgroundColor = .clear
        }
        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {}
}

func converse_tiktok(linkUrl: String) async -> ConverseStatus {
    let translator = TiktokTranslator()
    
    let conversed_tiktok = try? await translator.translateForVideoUrl(linkUrl)
    
    guard let conversed_tiktok else {
        return .error
    }
    
    return .conversed(conversed_tiktok)
}

#Preview {
    DetailVideoView(videoData: .sample)
}
