//
//  SoundyViewController.swift
//  Soundy
//
//  Created by okmin lee on 2020/08/29.
//  Copyright © 2020 okmin lee. All rights reserved.
//

import UIKit

class  SoundyViewController<R: UIView, V: NSObject>: UIViewController {
    var rootView: R {
        return self.view as! R
    }
    
    let viewModel = V()
}
