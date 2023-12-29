//
//  ShortVideoPlayer.swift
//  bestok
//
//  Created by Firas Rafislam on 25/12/2023.
//

import SwiftUI

/// get coordinates in Global reference frame given a Local point & geometry
func globalCoordinate(localX x: CGFloat, localY y: CGFloat,
                      localGeometry geo: GeometryProxy) -> CGPoint {
    let localPoint = CGPoint(x: x, y: y)
    return geo.frame(in: .global).origin.applying(
        .init(translationX: localPoint.x, y: localPoint.y)
    )
}

struct ShortVideoPlayer: View {
    
    
    let url: URL
    
    
    @StateObject var model: ShortVideoPlayerViewModel
    
    #if os(visionOS)
    @State private var currentStyle: ImmersionStyle = .full
    @Environment(\.openImmersiveSpace) private var openSpace
    @Environment(\.dismissImmersiveSpace) private var dismissSpace
    #endif
    
    @State var isPresentingSpace: Bool = false
    
//    @EnvironmentObject private var orientationTracker: OrientationTracker
    init(url: URL, video_size: Binding<CGSize?>, controller: VideoController) {
        self.url = url
        _model = StateObject(wrappedValue: ShortVideoPlayerViewModel(url: url, video_size: video_size, controller: controller))
//        _isPresentingSpace
    }
    var body: some View {
        GeometryReader { geo in
            let localFrame = geo.frame(in: .global)
            let centerY = globalCoordinate(localX: 0, localY: localFrame.midY, localGeometry: geo).y
            ZStack {

                AVPlayerView(player: model.player).ignoresSafeArea().frame(width: geo.size.height * 16 / 9, height: geo.size.height)
                    .position(x:geo.size.width / 2, y: geo.size.height / 2)
                
                mute_button
                
            }.onTapGesture(count: 2, perform: {
                
            }).onAppear {
                #if os(visionOS)
                Task {
                    guard !isPresentingSpace else { return }
                    // The navigationPath has one video, or is empty.
                    // Await the request to open the destination and set the state accordingly.
                    switch await openSpace(value: "aespa_scene") {
                    case .opened: isPresentingSpace = true
                    default: isPresentingSpace = false
                    }
                }
                #endif
            }

        }
    }
    
    private var mute_button: some View {
        HStack {
            Spacer()
            VStack {
                Spacer()
                
                Button {
                    model.did_tap_mute_button()
                } label: {
                    ZStack {
                        Circle()
                            .opacity(0.2)
                            .frame(width: 32, height: 32)
                            .foregroundColor(.black)
                        
                        Image(systemName: "speaker.slash.fill")
                            .padding()
                            .foregroundColor(.white).font(.headline)
                    }
                }
            }
            
        }
    }
    
    
//    private func update_is_visible(centerY: CGFloat) {
//        let isBelowTop = centerY > 100,
//        isAboveBottom = centerY < orientationTracker.deviceMajorAxis
//        model.set_view_is_visible(isBelowTop && isAboveBottom)
//    }
}


#Preview {
    ShortVideoPlayer(url: URL(string: "https://v16m-default.akamaized.net/eb943fe8647e8bdbd6a5d22a32fec258/658d3168/video/tos/alisg/tos-alisg-pve-0037c001/oUEAYLy1QRIghlACfaA4VIEzbwPoj0pAjytFdG/?a=0&ch=0&cr=0&dr=0&lr=all&cd=0%7C0%7C0%7C1&cv=1&br=5528&bt=2764&bti=OUBzOTg7QGo6OjZAL3AjLTAzYCMxNDNg&cs=0&ds=6&ft=XE5bCqT0m7jPD12Fr6yR3wUTV3yKMeF~O5&mime_type=video_mp4&qs=13&rc=ajM1Zzk6ZmxubjMzODczNEBpajM1Zzk6ZmxubjMzODczNEBlZ18tcjRvX2FgLS1kMS1zYSNlZ18tcjRvX2FgLS1kMS1zcw%3D%3D&l=20231228022705F85EB2C3638AE51D77E6&btag=e00048000")!, video_size: .constant(nil), controller: VideoController())
}
