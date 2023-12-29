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
    case conversed(URL)
    case error
}

struct NavDismissBarView: View {
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        HStack(alignment: .center) {
            Spacer()
            
            Button(action: {
                dismiss()
            }, label: {
                Image("xmark")
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


class ConverseViewModel: ObservableObject {
    @Published var state: ConverseStatus
    
    init(state: ConverseStatus) {
        self.state = state
    }
}

struct DetailVideoView: View {
    
    let videoData: TiktokData
    
    @State private var completed = false
    @State private var tiktokUrl = ""
    
    @State private var show_share_sheet = false
    
    @State private var is_timeline = true
    
    
    var ConverseButton: some View {
        Button("Download Video") {
            converse()
        }
    }
    
    var body: some View {
        ZStack {
            Color(.black).ignoresSafeArea()
            
            ShortVideoPlayer(url: videoData.play, video_size: .constant(nil), controller: VideoController())
            
            VStack {
                HStack() {
                    
                    
                    
                    VStack(alignment: .leading) {
                        Text(videoData.author.nickname).font(karrik_font(.title, font_size: 1)).foregroundStyle(.windowBackground)
                        Text(videoData.author.uniqueId).font(karrik_font(.subheadline, font_size: 1)).foregroundStyle(.windowBackground)
                    }
                    
                    Spacer()
                    
                }.padding().padding(.top, 45)
                
                
                Spacer()
            }
            
            VStack {
                
                Spacer()
                
                Text(videoData.title).font(karrik_font(.small, font_size: 1)).foregroundStyle(.windowBackground)
                
                Button(action: {
//                    Task {
//                        let converseStatus = await converse_tiktok(linkUrl: tiktokUrl)
//                        tiktokVideo = converseStatus
//                    }
                    show_share_sheet = true
                }, label: {
                    HStack {
                        Text("Download").font(karrik_font(.normal, font_size: 1)).foregroundStyle(.white)
                    }.frame(minWidth: 300, maxWidth: .infinity, alignment: .center)
                }).buttonStyle(WhiteBorderButtonStyle(padding: 16)).padding()

                
                
            }.padding(.bottom, 100)
            
            VStack {
                
                Spacer()
                
                HStack {
                    
                    VStack(alignment: .leading) {
                        Text(videoData.musicInfo.title).font(karrik_font(.small, font_size: 1)).foregroundStyle(.windowBackground)
                        Text(videoData.musicInfo.author).font(karrik_font(.small, font_size: 1)).foregroundStyle(.windowBackground)
                    }
                    
                    Spacer()
                }
            }.padding(.bottom, is_timeline ? 36 : 12).padding(.leading, 10)
            
        }.sheet(isPresented: $show_share_sheet) {
            ShareSheet(activityItems: [videoData.hdPlay])
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
    
    func converse() {
        Task {
            let res = await converse_tiktok(linkUrl: tiktokUrl)
            DispatchQueue.main.async {
                self.completed = true
            }
        }
    }
}

func converse_tiktok(linkUrl: String) async -> ConverseStatus {
    let translator = TiktokTranslator()
    
    let conversed_tiktok = try? await translator.translateForVideoUrl(linkUrl, from: "", to: "")
    
    guard let conversed_tiktok else {
        return .error
    }
    
    return .conversed(conversed_tiktok)
}

#Preview {
    DetailVideoView(videoData: .sample)
}
