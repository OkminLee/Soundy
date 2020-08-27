//
//  ArtistTableViewCell.swift
//  Soundy
//
//  Created by okmin lee on 2020/08/27.
//  Copyright © 2020 okmin lee. All rights reserved.
//

import UIKit

class ArtistTableViewCell: UITableViewCell {
    var albums: [String?]?
    
    @IBOutlet weak var albumCollectionView: UICollectionView!
}

extension ArtistTableViewCell: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return albums?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AlbumCollectionViewCell", for: indexPath) as? AlbumCollectionViewCell else { return UICollectionViewCell() }
        cell.titleLabel.text = albums?[indexPath.row]
        return cell
    }
}
