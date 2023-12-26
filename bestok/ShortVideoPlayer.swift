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
            let localFrame = geo.frame(in: .local)
            let centerY = globalCoordinate(localX: 0, localY: localFrame.midY, localGeometry: geo).y
            ZStack {

                AVPlayerView(player: model.player)
            }.onAppear {
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
    
    
//    private func update_is_visible(centerY: CGFloat) {
//        let isBelowTop = centerY > 100,
//        isAboveBottom = centerY < orientationTracker.deviceMajorAxis
//        model.set_view_is_visible(isBelowTop && isAboveBottom)
//    }
}


#Preview {
    ShortVideoPlayer(url: URL(string: "https://v16m-default.akamaized.net/b9e4c7ae5cc448dd73fca0c876fa1f39/658934d8/video/tos/maliva/tos-maliva-ve-0068c799-us/osIuZl7VfABdbmDlE2kmZFIA7FRHmZMejVEQEu/?a=0&ch=0&cr=0&dr=0&lr=all&cd=0%7C0%7C0%7C0&cv=1&br=1358&bt=679&bti=OUBzOTg7QGo6OjZAL3AjLTAzYCMxNDNg&cs=0&ds=6&ft=XE5bCqT0m7jPD1204VsR3wUTV3yKMeF~O5&mime_type=video_mp4&qs=0&rc=ZjQ5NTY1Ozw4ZThkZjM5OUBpajdxZnE5cnM5bzMzaTczNEAuNmIzLTRgXmAxXjYxYjMvYSNfMG8uMmRjYGdgLS1kMTJzcw%3D%3D&l=2023122501524558088B0EC8105DA3D512&btag=e00088000")!, video_size: .constant(nil), controller: VideoController())
}
