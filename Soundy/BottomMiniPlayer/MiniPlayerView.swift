//
//  MiniPlayerView.swift
//  Soundy
//
//  Created by okmin lee on 2020/08/28.
//  Copyright © 2020 okmin lee. All rights reserved.
//

import UIKit

protocol MiniPlayerViewDelegate: class {
    func soundControlAction()
}
class MiniPlayerView: UIView {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var soundControlButton: UIButton!
    @IBOutlet var containerView: UIView!
    @IBOutlet weak var progressSlider: UISlider!
    
    let play = UIImage().playImage
    let pause = UIImage().pauseImage
    var animator: UIViewPropertyAnimator?
    var songTimer: Timer?
    
    weak var delegate: MiniPlayerViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initSubView()
    }
    
    private func initSubView() {
        let bundleName = Bundle(for: type(of: self))
        let nibName = String(describing: type(of: self))
        let nib = UINib(nibName: nibName, bundle: bundleName)
        nib.instantiate(withOwner: self, options: nil)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(containerView)
        addConstraints()
        soundControlButton.setImage(play, for: .normal)
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: containerView.topAnchor),
            leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])
    }
    
    func toggleSoundControlButton() {
        switch soundControlButton.image(for: .normal) {
        case play: soundControlButton.setImage(pause, for: .normal)
        case pause: soundControlButton.setImage(play, for: .normal)
        case .none, .some(_): ()
        }
    }
    
    func soundControlButtonToPause() {
        soundControlButton.setImage(pause, for: .normal)
    }
    
    func soundControlButtonToPlay() {
        soundControlButton.setImage(play, for: .normal)
    }
    
    func animateProgress(interval: TimeInterval) {
        if animator == nil {
            animator = UIViewPropertyAnimator(duration: interval, curve: .linear){
                self.progressSlider.setValue(1.0, animated: true)
            }
            animator?.addCompletion({ (_) in
                self.progressSlider.setValue(0.0, animated: false)
                self.animator = nil
            })
            animator?.startAnimation()
        } else {
            animator?.continueAnimation(withTimingParameters: .none, durationFactor: 0)
        }
    }
    
    func pauseProgress() {
        animator?.pauseAnimation()
        let value = self.progressSlider.value
        self.progressSlider.setValue(value, animated: false)
    }
    
    func stopProgress() {
        self.progressSlider.setValue(0.0, animated: false)
        self.animator?.stopAnimation(false)
        self.animator?.finishAnimation(at: .end)
        self.animator = nil
    }
    
    func requestSongTimes(currentPlaybackTime: TimeInterval, interval: TimeInterval) {
        if let timer = songTimer {
            timer.invalidate()
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "m:ss"
        
        var timeInterval = interval - currentPlaybackTime
        var currentPlaybackTime = currentPlaybackTime
        songTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] timer in
            timeInterval -= 0.1
            currentPlaybackTime += 0.1
            self?.progressSlider.setValue(Float(currentPlaybackTime/interval), animated: true)
            if timeInterval <= 0 {
                timer.invalidate()
            }
        }
        songTimer?.fire()
    }
    
    func stopSongTimer() {
        if let timer = songTimer {
            timer.invalidate()
        }
    }
    
    @IBAction func soundControlAction(_ sender: UIButton) {
        guard let text = titleLabel.text, !text.isEmpty else { return }
        toggleSoundControlButton()
        delegate?.soundControlAction()
    }
}
