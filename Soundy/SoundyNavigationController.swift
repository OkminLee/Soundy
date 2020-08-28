//
//  SoundyNavigationController.swift
//  Soundy
//
//  Created by okmin lee on 2020/08/28.
//  Copyright © 2020 okmin lee. All rights reserved.
//

import UIKit
import MediaPlayer

class SoundyNavigationController: UINavigationController {

    var miniPlayer: MiniPlayerView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        MusicPlayManager.shared.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        createMiniPlayer()
    }
    
    func createMiniPlayer() {
        let miniPlayer = MiniPlayerView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 60))

        miniPlayer.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(miniPlayer)
        
        
        NSLayoutConstraint.activate([
            miniPlayer.heightAnchor.constraint(equalToConstant: 60),
            view.leadingAnchor.constraint(equalTo: miniPlayer.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: miniPlayer.trailingAnchor),
            view.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: miniPlayer.bottomAnchor)
        ])
        self.miniPlayer = miniPlayer
        self.miniPlayer?.delegate = self
    }
}

extension SoundyNavigationController: MusicPlayMangerDelegate {
    func startPlay(item: MPMediaItem) {
        guard let miniPlayer = miniPlayer else { return }
        miniPlayer.titleLabel.text = item.title
        miniPlayer.soundControlButtonToPause()
    }
}

extension SoundyNavigationController: MiniPlayerViewDelegate {
    func soundControlAction() {
        if MusicPlayManager.shared.isPlaying {
            MusicPlayManager.shared.stop()
        } else {
            MusicPlayManager.shared.play()
        }
    }
}
