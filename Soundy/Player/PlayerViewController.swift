//
//  PlayerViewController.swift
//  Soundy
//
//  Created by okmin lee on 2020/08/29.
//  Copyright © 2020 okmin lee. All rights reserved.
//

import UIKit
import MediaPlayer

class PlayerViewController: SoundyViewController<PlayerView, PlayerViewModel> {

    var currentMusic: MPMediaItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDIdLoad")
        initView()
        bindViewModel()
    }
    
    private func initView() {
        guard let item = currentMusic else { return }
        viewModel.input.requestSongTitle(item: item)
        viewModel.input.requestArtwork(item: item, size: rootView.artworkImageView.intrinsicContentSize)
        viewModel.input.requestAlbumTitle(item: item)
        viewModel.input.requestArtist(item: item)
    }

    @IBAction func closeAction(_ sender: Any) {
        print("closeAction")
        dismiss(animated: true, completion: nil)
    }
}

extension PlayerViewController {
    private func bindViewModel() {
        bindSongTitle()
        bindArtwork()
        bindAlbumTitle()
        bindArtist()
    }
    
    private func bindSongTitle() {
        viewModel.output.songTitle.bind { [weak self] songTitle in
            guard let songTitle = songTitle else { return }
            self?.rootView.songTitleLabel.text = songTitle
        }
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
}
