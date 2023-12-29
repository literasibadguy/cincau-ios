//
//  HomeView.swift
//  bestok
//
//  Created by Firas Rafislam on 28/12/2023.
//

import SwiftUI

struct GradientButtonStyle: ButtonStyle {
    let padding: CGFloat
    
    init(padding: CGFloat) {
        self.padding = padding
    }
    
    func makeBody(configuration: Configuration) -> some View {
        return configuration.label
            .padding(padding)
            .background {
                RoundedRectangle(cornerRadius: 12).fill(Color.blue)
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
            
        VStack {
            Spacer()
            Text("Download TikTok Video without label watermark, high quality").font(karrik_font(.normal, font_size: 1))
            TextField("https://www.tiktok.com/@xxx/video/xxxxxxxx", text: $tiktokUrl).font(karrik_font(.normal, font_size: 1)).padding()
            
            Spacer()
            Button(action: {
                Task {
                    let converseStatus = await converse_tiktok(linkUrl: tiktokUrl)
                    tiktokVideo = converseStatus
                }
            }, label: {
                HStack {
                    Text("Download").foregroundStyle(.white).font(karrik_font(.normal, font_size: 1))
                }.frame(minWidth: 300, maxWidth: .infinity, alignment: .center)
            }).buttonStyle(GradientButtonStyle(padding: 16)).padding()
        }.toolbar {
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
