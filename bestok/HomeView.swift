//
//  HomeView.swift
//  bestok
//
//  Created by Firas Rafislam on 28/12/2023.
//

import SwiftUI
import Photos

struct Blur: UIViewRepresentable {
    var style: UIBlurEffect.Style = .dark

    func makeUIView(context: Context) -> UIVisualEffectView {
        return UIVisualEffectView(effect: UIBlurEffect(style: style))
    }

    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        uiView.effect = UIBlurEffect(style: style)
    }
}

struct GradientButtonStyle: ButtonStyle {
    let padding: CGFloat
    
    init(padding: CGFloat) {
        self.padding = padding
    }
    
    func makeBody(configuration: Configuration) -> some View {
        return configuration.label
            .padding(padding)
            .background {
                ZStack {
                    
                    RoundedRectangle(cornerRadius: 12).fill(Color.white)
                }
            }.scaleEffect(configuration.isPressed ? 0.85 : 1.0)
    }
}
struct HomeView: View {
    let customFont = Font.custom("Karrik-Regular", fixedSize: 32)
    
    @ObservedObject private var converseViewModel: ConverseViewModel = ConverseViewModel(state: .havent_converse)
    
    @State private var tiktokUrl = ""
    
    @State private var tiktokVideo: TiktokData?
    
    @State private var show_support = false
    
    var body: some View {
        NavigationView(content: {
        
            ZStack {
                
//                Image("aespa_scene", bundle: .main)
                
                Blur().background {
                    Image("aespa_scene")
                }.ignoresSafeArea()
                
                VStack(alignment: .leading) {
                    
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Cincau").font(karrik_font(.title, font_size: 1)).foregroundStyle(.white)

                        Text("Download TikTok Video without label watermark, high quality").font(karrik_font(.normal, font_size: 1)).foregroundStyle(.windowBackground)
                    }
                    
                    Spacer()
                    
                    VStack {
                        
                        TextField("https://www.tiktok.com/@xxx/video/xxxxxxxx", text: $tiktokUrl).tint(.white).font(karrik_font(.normal, font_size: 1)).padding().foregroundStyle(.white)
                    }
                    
                    Spacer()
                    Button(action: {
                        Task {
                            let converseStatus = await converse_tiktok(linkUrl: tiktokUrl)
                            tiktokVideo = converseStatus
                        }
                        
                    }, label: {
                        HStack {
                            Text("Download").foregroundStyle(.black).font(karrik_font(.normal, font_size: 1))
                        }.frame(minWidth: 300, maxWidth: .infinity, alignment: .center)
                    }).buttonStyle(GradientButtonStyle(padding: 16)).padding()
                }.onAppear {
                    PHPhotoLibrary.requestAuthorization(for: .readWrite) { _ in
                        
                    }
                    guard let tiktokPaste = UIPasteboard.general.string else {
                        return
                    }
                    if tiktokPaste.contains("tiktok.com") {
                        tiktokUrl = tiktokPaste
                        Task {
                            let converseStatus = await converse_tiktok(linkUrl: tiktokUrl)
                            tiktokVideo = converseStatus
                        }
                    }
                }.padding().toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: show_donate) {
                            Text("Support").font(karrik_font(.normal, font_size: 1))
                        }
                    }
                }.fullScreenCover(item: $tiktokVideo) { tiktokData in
                    DetailVideoView(videoData: tiktokData)
                }.sheet(isPresented: $show_support, content: {
                    DonateView()
                })
            }
        })

    }
    
    func converse_tiktok(linkUrl: String) async -> TiktokData? {
        let translator = TiktokTranslator()
        
        let conversed_tiktok = try? await translator.translateForVideoData(linkUrl)
        
        guard let conversed_tiktok else {
            return nil
        }
        
        return conversed_tiktok
    }
    
    private func show_donate() {
        show_support = true
    }

}

#Preview {
    HomeView()
}
