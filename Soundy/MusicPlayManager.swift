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
}
class MusicPlayManager: NSObject {
    static let shared = MusicPlayManager()
    private let player = MPMusicPlayerController.applicationMusicPlayer
    
    var currentMusic: MPMediaItem? {
        player.nowPlayingItem
    }
    
    var prePlayMusic: MPMediaItem?
    
    var isPlaying: Bool {
        return player.playbackState == .playing
    }
    
    weak var delegate: MusicPlayMangerDelegate?
    
    
    private override init() {
        super.init()
        player.beginGeneratingPlaybackNotifications()
//        NotificationCenter.default.addObserver(self, selector: #selector(changed), name: .MPMusicPlayerControllerVolumeDidChange, object: player.nowPlayingItem)
        NotificationCenter.default.addObserver(self, selector: #selector(NowPlayingItemDidChanged), name: .MPMusicPlayerControllerNowPlayingItemDidChange, object: player)
//        NotificationCenter.default.addObserver(self, selector: #selector(playbackStateDidChanged), name: .MPMusicPlayerControllerPlaybackStateDidChange, object: player)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .MPMusicPlayerControllerNowPlayingItemDidChange, object: nil)
//        NotificationCenter.default.removeObserver(self, name: .MPMusicPlayerControllerPlaybackStateDidChange, object: nil)
        player.endGeneratingPlaybackNotifications()
    }
    
    func play(_ collection: MPMediaItemCollection) {
        player.setQueue(with: (collection))
        player.play()
    }
    
    func play() {
        player.play()
    }
    
    func stop() {
        player.pause()
    }
    
    @objc func NowPlayingItemDidChanged() {
        guard let item = player.nowPlayingItem else { return }
        delegate?.startPlay(item: item)
    }
    
    @objc func playbackStateDidChanged() {
        guard let item = player.nowPlayingItem else { return }
        delegate?.startPlay(item: item)
    }
}
