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
        let gesture = UITapGestureRecognizer(target: self, action: #selector(SoundyNavigationController.miniPlayerAction(recognizer:)))
        self.miniPlayer?.addGestureRecognizer(gesture)
    }
    
    @objc func miniPlayerAction(recognizer: UITapGestureRecognizer) {
        let viewController = PlayerViewController()
        present(viewController, animated: true, completion: nil)
    }
}

extension SoundyNavigationController: MusicPlayMangerDelegate {
    func startPlay(item: MPMediaItem) {
        guard let miniPlayer = miniPlayer else { return }
        miniPlayer.titleLabel.text = item.title
        miniPlayer.soundControlButtonToPause()
        miniPlayer.stopProgress()
        miniPlayer.animateProgress(interval: item.playbackDuration)
//        let dateFormmater = DateFormatter()
//        dateFormmater.dateFormat = "m:ss"
//        let min = dateFormmater.string(from: Date(timeIntervalSinceReferenceDate: item.playbackDuration))
//        print(min)
    }
    
    func paused() {
        guard let miniPlayer = miniPlayer else { return }
        miniPlayer.pauseProgress()
    }
    
    func resume(interval: TimeInterval) {
        guard let miniPlayer = miniPlayer else { return }
        miniPlayer.soundControlButtonToPause()
        miniPlayer.animateProgress(interval: interval)
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
