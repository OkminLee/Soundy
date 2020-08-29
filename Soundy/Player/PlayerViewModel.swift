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
}

protocol PlayerViewModelOutput: AlbumViewModelOutput {
    var songTitle: State<String?> { get }
}

class PlayerViewModel: NSObject, PlayerViewModelOutput {
    var input: PlayerViewModelInput { return self }
    var output: PlayerViewModelOutput { return self }
    
    var songTitle = State<String?>(nil)
    var artwork = State<UIImage?>(nil)
    var albumTitle = State<String?>(nil)
    var artist = State<String?>(nil)
    var completedRequestSongs = State<Bool?>(nil)
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
}
