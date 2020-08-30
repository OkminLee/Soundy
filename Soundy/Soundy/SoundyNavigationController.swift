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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let viewController = segue.destination as? PlayerViewController, let currentMusic = sender as? MPMediaItem {
            viewController.currentMusic = currentMusic
            viewController.delgate = self
        }
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
        guard let currentMusic = MusicPlayManager.shared.currentMusic else { return }
        performSegue(withIdentifier: "toPlayer", sender: currentMusic)
    }
}

extension SoundyNavigationController: MusicPlayMangerDelegate {
    func startPlay(item: MPMediaItem) {
        guard let miniPlayer = miniPlayer else { return }
        miniPlayer.titleLabel.text = item.title
        miniPlayer.soundControlButtonToPause()
        miniPlayer.stopProgress()
        miniPlayer.animateProgress(interval: item.playbackDuration)
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
    
    func backward(item: MPMediaItem) {}
}

extension SoundyNavigationController: MiniPlayerViewDelegate {
    func soundControlAction() {
        MusicPlayManager.shared.handlePlayState()
    }
}

extension SoundyNavigationController: PlayerViewControllerDelegate {
    func viewWillDisappear() {
        MusicPlayManager.shared.delegate = self
        guard let miniPlayer = miniPlayer, let item = MusicPlayManager.shared.currentMusic else { return }
        miniPlayer.titleLabel.text = item.title
        let duration = item.playbackDuration - MusicPlayManager.shared.currentPlaybackTime
        miniPlayer.animateProgress(interval: duration)
        if MusicPlayManager.shared.isPlaying {
            miniPlayer.soundControlButtonToPause()
        } else {
            
        }
    }
}
