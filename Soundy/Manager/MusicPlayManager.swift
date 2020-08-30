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
    func backward(item: MPMediaItem)
}
class MusicPlayManager: NSObject {
    static let shared = MusicPlayManager()
    private let player = MPMusicPlayerController.applicationQueuePlayer
    
    var pausedMusic: MPMediaItem?
    
    var currentMusic: MPMediaItem? {
        player.nowPlayingItem
    }
    
    var currentTitle: String {
        player.nowPlayingItem?.title ?? ""
    }
    
    var currentPlaybackTime: TimeInterval {
        player.currentPlaybackTime
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
        player.prepareToPlay { [weak self] error in
            if let error = error {
                print("error ", error.localizedDescription)
            } else {
                self?.player.play()
            }
        }
    }
    
    func play() {
        player.play()
    }
    
    func stop() {
        pausedMusic = player.nowPlayingItem
        player.pause()
    }
    
    func backward() {
        player.skipToPreviousItem()
    }
    
    func forward() {
        player.skipToNextItem()
    }
    
    func seek(interval: TimeInterval) {
        player.currentPlaybackTime = interval
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
            if let currentMusic = pausedMusic, currentMusic == item {
                delegate?.resume(interval: item.playbackDuration - player.currentPlaybackTime)
            } else {
                delegate?.backward(item: item)
            }
        case .seekingForward: ()
        case .seekingBackward: ()
        @unknown default: ()
        }
    }
}
