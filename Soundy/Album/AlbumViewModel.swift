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
    func requestSongs(album: MPMediaItemCollection)
}

protocol AlbumViewModelOutput {
    var artwork: State<UIImage?> { get }
    var albumTitle: State<String?> { get }
    var artist: State<String?> { get }
    var completedRequestSongs: State<Bool?> { get }
}

class AlbumViewModel: NSObject, AlbumViewModelOutput {
    var input: AlbumViewModelInput { return self }
    var output: AlbumViewModelOutput { return self }
    
    var artwork = State<UIImage?>(nil)
    var albumTitle = State<String?>(nil)
    var artist = State<String?>(nil)
    var completedRequestSongs = State<Bool?>(nil)
    
    private var album: MPMediaItemCollection?
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
    
    func requestSongs(album: MPMediaItemCollection) {
        self.album = album
        completedRequestSongs.value = true
    }
}

extension AlbumViewModel: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return album?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: "SongTableViewCell", for: indexPath) as? SongTableViewCell,
            let album = album
        else { return UITableViewCell() }
        cell.numberLabel.text = "\(indexPath.row+1)"
        cell.songTitleLabel.text = album.items[indexPath.row].title
        return cell
    }
}

extension AlbumViewModel: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let album = album else { return }
        let items = Array(album.items)
        let array = Array(items.suffix(from: indexPath.row))
        let collection = MPMediaItemCollection(items: array)
        MusicPlayManager.shared.play(collection)
    }
}
