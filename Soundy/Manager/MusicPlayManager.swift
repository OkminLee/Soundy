//
//  MusicPlayManager.swift
//  Soundy
//
//  Created by okmin lee on 2020/08/28.
//  Copyright © 2020 okmin lee. All rights reserved.
//

import Foundation
import MediaPlayer

protocol MusicPlayMangerDelegate: class {
    func startPlay(item: MPMediaItem)
    func paused()
    func resume(interval: TimeInterval)
}
class MusicPlayManager: NSObject {
    static let shared = MusicPlayManager()
    private let player = MPMusicPlayerController.applicationMusicPlayer
    
    var currentMusic: MPMediaItem?
    
    var currentTitle: String {
        player.nowPlayingItem?.title ?? ""
    }
    
    var isPlaying: Bool {
        player.playbackState == .playing
    }
    
    weak var delegate: MusicPlayMangerDelegate?
    
    private override init() {
        super.init()
        player.beginGeneratingPlaybackNotifications()
//        NotificationCenter.default.addObserver(self, selector: #selector(changed), name: .MPMusicPlayerControllerVolumeDidChange, object: player.nowPlayingItem)
        NotificationCenter.default.addObserver(self, selector: #selector(NowPlayingItemDidChanged), name: .MPMusicPlayerControllerNowPlayingItemDidChange, object: player)
        NotificationCenter.default.addObserver(self, selector: #selector(playbackStateDidChanged), name: .MPMusicPlayerControllerPlaybackStateDidChange, object: player)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .MPMusicPlayerControllerNowPlayingItemDidChange, object: nil)
        NotificationCenter.default.removeObserver(self, name: .MPMusicPlayerControllerPlaybackStateDidChange, object: nil)
        player.endGeneratingPlaybackNotifications()
    }
    
    func play(_ collection: MPMediaItemCollection) {
        guard collection.items.count > 0 else { return }
        player.pause()
        player.stop()
        player.setQueue(with: collection)
        player.play()
    }
    
    func play() {
        player.play()
    }
    
    func stop() {
        currentMusic = player.nowPlayingItem
        player.pause()
        
    }
    
    @objc func NowPlayingItemDidChanged() {
        guard let item = player.nowPlayingItem else { return }
        delegate?.startPlay(item: item)
    }
    
    @objc func playbackStateDidChanged() {
        guard let item = player.nowPlayingItem else { return }
        switch player.playbackState {
        case .interrupted: ()
        case .paused: delegate?.paused()
        case .stopped: ()
        case .playing:
            guard let currentMusic = currentMusic, currentMusic == item else { return }
            delegate?.resume(interval: item.playbackDuration - player.currentPlaybackTime)
        case .seekingForward: ()
        case .seekingBackward: ()
        @unknown default: ()
        }
    }
}
