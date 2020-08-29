//
//  AlbumViewController.swift
//  Soundy
//
//  Created by okmin lee on 2020/08/28.
//  Copyright © 2020 okmin lee. All rights reserved.
//

import UIKit
import MediaPlayer

class AlbumViewController: SoundyViewController<AlbumView, AlbumViewModel>  {
    
    var album: MPMediaItemCollection?

    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        bindViewModel()
    }
    
    private func initView() {
        guard let album = album, let representativeItem = album.representativeItem else { return }
        viewModel.input.requestArtwork(item: representativeItem, size: rootView.artworkImageView.intrinsicContentSize)
        viewModel.input.requestAlbumTitle(item: representativeItem)
        viewModel.input.requestArtist(item: representativeItem)
        viewModel.input.requestSongs(album: album)
    }
}

// MARK: Bind ViewModel
extension AlbumViewController {
    private func bindViewModel() {
        bindArtwork()
        bindAlbumTitle()
        bindArtist()
        bindCompletedRequestSongs()
    }
    
    private func bindArtwork() {
        viewModel.output.artwork.bind { [weak self] artwork in
            guard let artwork = artwork else { return }
            self?.rootView.artworkImageView.image = artwork
        }
    }
    
    private func bindAlbumTitle() {
        viewModel.output.albumTitle.bind { [weak self] albumTitle in
            guard let albumTitle = albumTitle else { return }
            self?.rootView.albumTitleLabel.text = albumTitle
        }
    }
    
    private func bindArtist() {
        viewModel.output.artist.bind { [weak self] artist in
            guard let artist = artist else { return }
            self?.rootView.artistLabel.text = artist
        }
    }
    
    private func bindCompletedRequestSongs() {
        viewModel.output.completedRequestSongs.bind { [weak self] completed in
            guard let completed = completed, completed else { return }
            self?.rootView.songsTableView.register(UINib(nibName: "SongTableViewCell", bundle: nil), forCellReuseIdentifier: "SongTableViewCell")
            self?.rootView.songsTableView.dataSource = self?.viewModel
            self?.rootView.songsTableView.delegate = self?.viewModel
            self?.rootView.songsTableView.reloadData()
        }
    }
}

// MARK: Action
extension AlbumViewController {
    @IBAction func playAction(_ sender: Any) {
        guard let album = album else { return }
        MusicPlayManager.shared.play(album)
    }
    
    @IBAction func shufflePlayAction(_ sender: Any) {
        guard let album = album else { return }
        let collection = MPMediaItemCollection(items: album.items.shuffled())
        MusicPlayManager.shared.play(collection)
    }
}
