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

    override func viewDidLoad() {
        super.viewDidLoad()
        MusicPlayManager.shared.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        createMiniPlayer()
    }
    
    func createMiniPlayer() {
        let miniPlayer = UIView(frame: CGRect(x: 0, y: self.view.frame.height-80, width: self.view.frame.width, height: 80))
        miniPlayer.backgroundColor = .white
        let label = UILabel(frame: CGRect(x: 0, y: self.view.frame.height-80, width: 100, height: 100))
        label.text = "TEST"
        label.textColor = .blue
        miniPlayer.addSubview(label)
        view.addSubview(miniPlayer)
        miniPlayer.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
    }
}

extension SoundyNavigationController: MusicPlayMangerDelegate {
    func startPlay(item: MPMediaItem) {
        print(item.albumArtist, item.albumTitle, item.title)
    }
}
