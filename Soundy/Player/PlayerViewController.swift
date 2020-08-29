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
    private var animator: UIViewPropertyAnimator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        bindViewModel()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        MusicPlayManager.shared.delegate = self
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard let item = currentMusic else { return }
        let duration = item.playbackDuration - MusicPlayManager.shared.currentPlaybackTime
        animateProgress(interval: duration)
    }
    
    private func initView() {
        guard let item = currentMusic else { return }
        viewModel.input.requestSongTitle(item: item)
        viewModel.input.requestArtwork(item: item, size: rootView.artworkImageView.intrinsicContentSize)
        viewModel.input.requestAlbumTitle(item: item)
        viewModel.input.requestArtist(item: item)
        
        let progress = MusicPlayManager.shared.currentPlaybackTime / item.playbackDuration
        
        rootView.progressSlider.setValue(Float(progress), animated: false)
    }
    
    func animateProgress(interval: TimeInterval) {
        if animator == nil {
            animator = UIViewPropertyAnimator(duration: interval, curve: .linear){
                self.rootView.progressSlider.setValue(1.0, animated: true)
            }
            animator?.addCompletion({ (_) in
                self.rootView.progressSlider.setValue(0.0, animated: false)
                self.animator = nil
            })
            animator?.startAnimation()
        } else {
            animator?.continueAnimation(withTimingParameters: .none, durationFactor: 0)
        }
    }
    
    func pauseProgress() {
        animator?.pauseAnimation()
        let value = self.rootView.progressSlider.value
        self.rootView.progressSlider.setValue(value, animated: false)
    }
    
    func stopProgress() {
        self.rootView.progressSlider.setValue(0.0, animated: false)
        self.animator?.stopAnimation(false)
        self.animator?.finishAnimation(at: .end)
        self.animator = nil
    }

    @IBAction func closeAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func controlAction(_ sender: UIButton) {
        if MusicPlayManager.shared.isPlaying {
            sender.setImage(UIImage().playCircleImage, for: .normal)
            MusicPlayManager.shared.stop()
        } else {
            sender.setImage(UIImage().pauseCircleImage, for: .normal)
            MusicPlayManager.shared.play()
        }
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

extension PlayerViewController: MusicPlayMangerDelegate {
    func startPlay(item: MPMediaItem) {
        rootView.controlButton.setImage(UIImage().playCircleImage, for: .normal)
        currentMusic = item
        initView()
        self.stopProgress()
        animateProgress(interval: item.playbackDuration)
//        let dateFormmater = DateFormatter()
//        dateFormmater.dateFormat = "m:ss"
//        let min = dateFormmater.string(from: Date(timeIntervalSinceReferenceDate: item.playbackDuration))
//        print(min)
    }
    
    func paused() {
        rootView.controlButton.setImage(UIImage().pauseCircleImage, for: .normal)
        pauseProgress()
    }
    
    func resume(interval: TimeInterval) {
        rootView.controlButton.setImage(UIImage().playCircleImage, for: .normal)
        animateProgress(interval: interval)
    }
}
