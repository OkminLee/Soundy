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
    }

    @IBAction func closeAction(_ sender: Any) {
        print("closeAction")
        dismiss(animated: true, completion: nil)
    }
}
