//
//  PlayerViewModel.swift
//  Soundy
//
//  Created by okmin lee on 2020/08/29.
//  Copyright © 2020 okmin lee. All rights reserved.
//

import MediaPlayer

protocol PlayerViewModelInput: AlbumViewModelInput {
    func requestSongTitle(item: MPMediaItem)
    func requestSongTimes(currentPlaybackTime: TimeInterval, interval: TimeInterval)
    func requestControlButtonImage(isPlaying: Bool)
}

protocol PlayerViewModelOutput: AlbumViewModelOutput {
    var songTitle: State<String?> { get }
    var songTimer: Timer? { get }
    var playedTime: State<String?> { get }
    var remainTIme: State<String?> { get }
    var timeProgress: State<Float?> { get }
    var controlButtonImage: State<UIImage?> { get }
}

class PlayerViewModel: NSObject, PlayerViewModelOutput {
    var input: PlayerViewModelInput { return self }
    var output: PlayerViewModelOutput { return self }
    
    var songTitle = State<String?>(nil)
    var artwork = State<UIImage?>(nil)
    var albumTitle = State<String?>(nil)
    var artist = State<String?>(nil)
    var completedRequestSongs = State<Bool?>(nil)
    var songTimer: Timer?
    var playedTime = State<String?>(nil)
    var remainTIme = State<String?>(nil)
    var timeProgress = State<Float?>(nil)
    var controlButtonImage = State<UIImage?>(nil)
}

extension PlayerViewModel: PlayerViewModelInput {
    func requestSongTitle(item: MPMediaItem) {
        songTitle.value = item.title
    }
    
    func requestArtwork(item: MPMediaItem, size: CGSize) {
        let artwork: UIImage
        if let image = item.artwork?.image(at: size) {
            artwork = image
        } else {
            artwork = UIImage().defaultMusicImage
        }
        self.artwork.value = artwork
    }
    
    func requestAlbumTitle(item: MPMediaItem) {
        albumTitle.value = item.albumTitle
    }
    
    func requestArtist(item: MPMediaItem) {
        artist.value = item.artist
    }
    
    func requestSongs(album: MPMediaItemCollection) {}
    
    func requestSongTimes(currentPlaybackTime: TimeInterval, interval: TimeInterval) {
        if let timer = songTimer {
            timer.invalidate()
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "m:ss"
        
        var timeInterval = interval - currentPlaybackTime
        var currentPlaybackTime = currentPlaybackTime
        songTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] timer in
            let remain = Date(timeIntervalSince1970: timeInterval)
            let played = Date(timeIntervalSince1970: currentPlaybackTime)
            self?.remainTIme.value = dateFormatter.string(from: remain)
            self?.playedTime.value = dateFormatter.string(from: played)
            timeInterval -= 0.1
            currentPlaybackTime += 0.1
            self?.timeProgress.value = Float(currentPlaybackTime/interval)
            if timeInterval == 0 {
                timer.invalidate()
            }
        }
        songTimer?.fire()
    }
    
    func stopTimer() {
        if let timer = songTimer {
            timer.invalidate()
        }
    }
    
    func requestControlButtonImage(isPlaying: Bool) {
        let image: UIImage
        if isPlaying {
            image = UIImage().pauseCircleImage
        } else {
            image = UIImage().playCircleImage
        }
        controlButtonImage.value = image
    }
}
