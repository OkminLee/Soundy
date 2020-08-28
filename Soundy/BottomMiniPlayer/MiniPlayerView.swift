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
    
    let play = UIImage(systemName: "play.fill")
    let pause = UIImage(systemName: "pause.fill")
    
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
    
    @IBAction func soundControlAction(_ sender: UIButton) {
        guard let text = titleLabel.text, !text.isEmpty else { return }
        toggleSoundControlButton()
        delegate?.soundControlAction()
    }
}
