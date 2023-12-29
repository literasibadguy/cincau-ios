//
//  AVPlayerView.swift
//  bestok
//
//  Created by Firas Rafislam on 25/12/2023.
//



import Foundation
import AVKit
import SwiftUI

struct AVPlayerView: UIViewControllerRepresentable {
    
    let player: AVPlayer
    
    func makeUIViewController(context: Context) -> AVPlayerViewController {
        AVPlayerViewController()
    }
    
    func updateUIViewController(_ uiViewController: AVPlayerViewController, context: Context) {
        if uiViewController.player == nil {
            uiViewController.player = player
            uiViewController.showsPlaybackControls = false
            player.play()
        }
    }
    
    static func dismantleUIViewController(_ uiViewController: AVPlayerViewController, coordinator: ()) {
        uiViewController.player?.pause()
        uiViewController.player = nil
    }
}
