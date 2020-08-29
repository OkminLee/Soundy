//
//  AlbumViewModel.swift
//  Soundy
//
//  Created by okmin lee on 2020/08/29.
//  Copyright © 2020 okmin lee. All rights reserved.
//

import UIKit
import MediaPlayer

protocol AlbumViewModelInput {
    func requestArtwork(item: MPMediaItem, size: CGSize)
    func requestAlbumTitle(item: MPMediaItem)
    func requestArtist(item: MPMediaItem)
}

protocol AlbumViewModelOutput {
    var artwork: State<UIImage?> { get }
    var albumTitle: State<String?> { get }
    var artist: State<String?> { get }
}

class AlbumViewModel: NSObject, AlbumViewModelOutput {
    var input: AlbumViewModelInput { return self }
    var output: AlbumViewModelOutput { return self }
    
    var artwork = State<UIImage?>(nil)
    var albumTitle = State<String?>(nil)
    var artist = State<String?>(nil)
}

extension AlbumViewModel: AlbumViewModelInput {
    
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
}

extension AlbumViewModel: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}

extension AlbumViewModel: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
