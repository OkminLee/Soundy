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
    }
    
    private func initView() {
        guard let album = album, let representativeItem = album.representativeItem else { return }
        
        let artwork: UIImage
        if let image = representativeItem.artwork?.image(at: self.rootView.artworkImageView.intrinsicContentSize) {
            artwork = image
        } else {
            artwork = UIImage().defaultMusicImage
        }
        self.rootView.artworkImageView.image = artwork
        self.rootView.albumTitleLabel.text = representativeItem.albumTitle
        self.rootView.artistLabel.text = representativeItem.artist
    }
    @IBAction func playAction(_ sender: Any) {
        guard let album = album else { return }
        MusicPlayManager.shared.play(album)
    }
    @IBAction func shufflePlayAction(_ sender: Any) {
    }
}
