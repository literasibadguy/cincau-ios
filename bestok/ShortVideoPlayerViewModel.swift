//
//  ShortVideoPlayerViewModel.swift
//  bestok
//
//  Created by Firas Rafislam on 25/12/2023.
//

import Foundation

import AVFoundation
import Combine
import Foundation
import SwiftUI

/// The presentation modes the player supports.
enum Presentation {
    /// Indicates to present the player as a child of a parent user interface.
    case inline
    /// Indicates to present the player in full-window exclusive mode.
    case fullWindow
}

func video_has_audio(player: AVPlayer) async -> Bool {
    do {
        let hasAudibleTracks = ((try await player.currentItem?.asset.loadMediaSelectionGroup(for: .audible)) != nil)
        let tracks = try? await player.currentItem?.asset.load(.tracks)
        let hasAudioTrack = tracks?.filter({ t in t.mediaType == .audio }).first != nil // Deal with odd cases of audio only MOV
        return hasAudibleTracks || hasAudioTrack
    } catch {
        return false
    }
}

@MainActor
final class ShortVideoPlayerViewModel: ObservableObject {
    
    private let url: URL
    private let player_item: AVPlayerItem
    let player: AVPlayer
    private let controller: VideoController
    let id = UUID()
    
    @Published var has_audio = false
    @Published var is_live = false
    @Binding var video_size: CGSize?
    @Published var is_muted = true
    @Published var is_loading = true
    
    private var cancellables = Set<AnyCancellable>()
    
    private var videoSizeObserver: NSKeyValueObservation?
    private var videoDurationObserver: NSKeyValueObservation?
    
    private var is_scrolled_into_view = false {
        didSet {
            if is_scrolled_into_view && !oldValue {
                // we have just scrolled from out of view into view
                controller.focused_model_id = id
            } else if !is_scrolled_into_view && oldValue {
                // we have just scrolled from in view to out of view
                if controller.focused_model_id == id {
                    controller.focused_model_id = nil
                }
            }
        }
    }
    
    init(url: URL, video_size: Binding<CGSize?>, controller: VideoController) {
        self.url = url
        player_item = AVPlayerItem(url: url)
        player = AVPlayer(playerItem: player_item)
        self.controller = controller
        _video_size = video_size
        
        Task {
            await load()
        }
        
        
        is_muted = controller.should_mute_video(url: url)
        player.isMuted = is_muted
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(did_play_to_end),
            name: Notification.Name.AVPlayerItemDidPlayToEndTime,
            object: player_item
        )
        
        controller.$focused_model_id
            .sink { [weak self] model_id in
                model_id == self?.id ? self?.player.play() : self?.player.pause()
            }
            .store(in: &cancellables)
        
        observeVideoSize()
        observeDuration()
        
    }
    
    func preparePlayer() {
        player.audiovisualBackgroundPlaybackPolicy = .pauses
        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: player.currentItem, queue: .main)
        {
            _ in
            Task { @MainActor [weak self] in
                self?.play()
            }
        }
    }
    
    private func observeVideoSize() {
        videoSizeObserver = player.currentItem?.observe(\.presentationSize, options: [.new], changeHandler: { [weak self] (playerItem, change) in
            guard let self else { return }
            if let newSize = change.newValue, newSize != .zero {
                DispatchQueue.main.async {
                    self.video_size = newSize  // Update the bound value
                }
            }
        })
    }
    
    private func observeDuration() {
        videoDurationObserver = player.currentItem?.observe(\.duration, options: [.new], changeHandler: { [weak self] (playerItem, change) in
            guard let self else { return }
            if let newDuration = change.newValue, newDuration != .zero {
                DispatchQueue.main.async {
                    self.is_live = newDuration == .indefinite
                }
            }
        })
    }
    
    func load() async {
        if let meta = controller.metadata(for: url) {
            has_audio = meta.has_audio
            video_size = meta.size
        } else {
            has_audio = await video_has_audio(player: player)
            configureAudioExperience(for: .inline)
        }
        
        is_loading = false
    }
    
    func play() {
        player.seek(to: CMTime.zero)
        player.play()
        player.isMuted = false
    }
    
    func did_tap_mute_button() {
        is_muted.toggle()
        player.isMuted = is_muted
        controller.toggle_should_mute_video(url: url)
    }
    
    func good_tap_mute_button() {
        is_muted.toggle()
    }
    
    func set_view_is_visible(_ is_visible: Bool) {
        is_scrolled_into_view = is_visible
    }
    
    func view_did_disappear() {
        set_view_is_visible(false)
    }
    
    @objc private func did_play_to_end() {
        player.seek(to: CMTime.zero)
        player.play()
    }
    
    private func configureAudioExperience(for presentation: Presentation) {
        #if os(visionOS)
        do {
            let experience: AVAudioSessionSpatialExperience
            switch presentation {
            case .inline:
                // Set a small, focused sound stage when watching trailers.
                experience = .headTracked(soundStageSize: .small, anchoringStrategy: .automatic)
            case .fullWindow:
                // Set a large sound stage size when viewing full window.
                experience = .headTracked(soundStageSize: .large, anchoringStrategy: .automatic)
            }
            try AVAudioSession.sharedInstance().setIntendedSpatialExperience(experience)
        } catch {
            print("Unable to set the intended spatial experience. \(error.localizedDescription)")
        }
        #endif
    }
    
    deinit {
        videoSizeObserver?.invalidate()
        videoDurationObserver?.invalidate()
    }
}
