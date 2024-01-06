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
    

    
    @ObservedObject private var tiktokTranslator: TiktokTranslator = TiktokTranslator()
    
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
                        
//                        TextField("https://www.tiktok.com/@xxx/video/xxxxxxxx", text: $tiktokTranslator.tiktokUrl).tint(.white).font(karrik_font(.normal, font_size: 1)).padding().foregroundStyle(.white)
                        KeyInput
                    }
                    
                    Spacer()
                    Button(action: {
                        Task {
                            let converseStatus = await converse_tiktok(linkUrl: tiktokTranslator.tiktokUrl)
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
    
    var KeyInput: some View {
            HStack {
                Image(systemName: "doc.on.clipboard")
                    .foregroundColor(.gray)
                    .onTapGesture {
                        if let pastedkey = UIPasteboard.general.string {
                            if pastedkey.contains("tiktok.com") {
                                self.tiktokTranslator.tiktokUrl = pastedkey
                            }
                        }
                    }

                TextField("", text: $tiktokTranslator.tiktokUrl).textContentType(.URL)                             .nsecLoginStyle(key:  self.tiktokTranslator.tiktokUrl, title: "Paste TikTok URL here")
            }
            .padding(.horizontal, 10)
            .overlay {
                RoundedRectangle(cornerRadius: 12)
                    .stroke(.gray, lineWidth: 1)
            }
    }
    
    func converse_tiktok(linkUrl: String) async -> TiktokData? {
        let conversed_tiktok = try? await tiktokTranslator.translateForVideoData(linkUrl)
        
        guard let conversed_tiktok else {
            return nil
        }
        
        return conversed_tiktok
    }
    
    private func show_donate() {
        show_support = true
    }

    private func clipboardChanged(){
            let pasteboardString: String? = UIPasteboard.general.string
            if let theString = pasteboardString {
                print("String is \(theString)")
                // Do cool things with the string
            }
        }
}

extension View {
    func placeholder<Content: View>(
            when shouldShow: Bool,
            alignment: Alignment = .leading,
            @ViewBuilder placeholder: () -> Content) -> some View {

            ZStack(alignment: alignment) {
                placeholder().opacity(shouldShow ? 1 : 0)
                self
            }
        }
    
    func nsecLoginStyle(key: String, title: String) -> some View {
        self.placeholder(when: key.isEmpty) {
            Text(title).foregroundStyle(.white.opacity(0.6))
        }
            .padding(10)
            .autocapitalization(.none)
            .autocorrectionDisabled(true)
            .textInputAutocapitalization(.never)
            .font(karrik_font(.normal, font_size: 1))
    }
}

#Preview {
    HomeView()
}
