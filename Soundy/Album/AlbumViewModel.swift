//
//  AlbumViewModel.swift
//  Soundy
//
//  Created by okmin lee on 2020/08/29.
//  Copyright © 2020 okmin lee. All rights reserved.
//

import UIKit

class AlbumViewModel: NSObject {
    
}

extension AlbumViewModel: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}

extension AlbumViewModel: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
