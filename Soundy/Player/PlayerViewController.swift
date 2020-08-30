//
//  PlayerViewController.swift
//  Soundy
//
//  Created by okmin lee on 2020/08/29.
//  Copyright © 2020 okmin lee. All rights reserved.
//

import UIKit
import MediaPlayer

protocol PlayerViewControllerDelegate: class {
    func viewWillDisappear()
}

class PlayerViewController: SoundyViewController<PlayerView, PlayerViewModel> {
    var currentMusic: MPMediaItem?
    private var animator: UIViewPropertyAnimator?
    
    weak var delgate: PlayerViewControllerDelegate?
    
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
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        delgate?.viewWillDisappear()
    }
    
    private func initView() {
        guard let item = currentMusic else { return }
        viewModel.input.requestSongTitle(item: item)
        viewModel.input.requestArtwork(item: item, size: rootView.artworkImageView.intrinsicContentSize)
        viewModel.input.requestAlbumTitle(item: item)
        viewModel.input.requestArtist(item: item)
        
        let progress = MusicPlayManager.shared.currentPlaybackTime / item.playbackDuration
        rootView.progressSlider.setValue(Float(progress), animated: false)
        
        viewModel.input.requestControlButtonImage(isPlaying: MusicPlayManager.shared.isPlaying)
        
        guard MusicPlayManager.shared.isPlaying else { return }
        let duration = item.playbackDuration - MusicPlayManager.shared.currentPlaybackTime
        viewModel.requestSongTimes(currentPlaybackTime: MusicPlayManager.shared.currentPlaybackTime, interval: duration)
    }

    @IBAction func closeAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func progressValueChanged(_ sender: UISlider) {
        viewModel.stopTimer()
    }
    
    @IBAction func progressAction(_ sender: UISlider) {
        guard let item = currentMusic else { return }
        MusicPlayManager.shared.seek(interval: item.playbackDuration * Double(sender.value))
        let duration = item.playbackDuration - MusicPlayManager.shared.currentPlaybackTime
        viewModel.requestSongTimes(currentPlaybackTime: MusicPlayManager.shared.currentPlaybackTime, interval: duration)
    }
    
    @IBAction func controlAction(_ sender: UIButton) {
        viewModel.stopTimer()
        MusicPlayManager.shared.handlePlayState()
        viewModel.input.requestControlButtonImage(isPlaying: !MusicPlayManager.shared.isPlaying )
    }
    
    @IBAction func backwardAction(_ sender: Any) {
        MusicPlayManager.shared.backward()
    }
    
    @IBAction func forwardAction(_ sender: Any) {
        MusicPlayManager.shared.forward()
    }
}

extension PlayerViewController {
    private func bindViewModel() {
        bindSongTitle()
        bindArtwork()
        bindAlbumTitle()
        bindArtist()
        bindPlaytimes()
        bindControlButtonImage()
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
    
    private func bindPlaytimes() {
        viewModel.output.playedTime.bind { [weak self] value in
            self?.rootView.playedTimeLabel.text = value
        }
        
        viewModel.output.remainTIme.bind { [weak self] value in
            self?.rootView.remainTimeLabel.text = value
        }
        
        viewModel.output.timeProgress.bind { [weak self] value in
            guard let value = value else { return }
            self?.rootView.progressSlider.setValue(value, animated: true)
        }
    }
    
    private func bindControlButtonImage() {
        viewModel.output.controlButtonImage.bind { [weak self] image in
            guard let image = image else { return }
            self?.rootView.controlButton.setImage(image, for: .normal)
        }
    }
}

extension PlayerViewController: MusicPlayMangerDelegate {
    func startPlay(item: MPMediaItem) {
        rootView.controlButton.setImage(UIImage().pauseCircleImage, for: .normal)
        currentMusic = item
        initView()
    }
    
    func paused() {
        rootView.controlButton.setImage(UIImage().playCircleImage, for: .normal)
    }
    
    func resume(interval: TimeInterval) {
        rootView.controlButton.setImage(UIImage().pauseCircleImage, for: .normal)
        viewModel.requestSongTimes(currentPlaybackTime: MusicPlayManager.shared.currentPlaybackTime, interval: interval)
    }
    
    func backward(item: MPMediaItem) {
        viewModel.requestSongTimes(currentPlaybackTime: MusicPlayManager.shared.currentPlaybackTime, interval: item.playbackDuration)
    }
}
