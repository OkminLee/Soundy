//
//  ArtistTableViewCell.swift
//  Soundy
//
//  Created by okmin lee on 2020/08/27.
//  Copyright © 2020 okmin lee. All rights reserved.
//

import UIKit
import MediaPlayer
import AVFoundation

protocol ArtistTableViewCellDelegate: class {
    func didSelected(album : MPMediaItemCollection)
}
class ArtistTableViewCell: UITableViewCell {
    var albums: [MPMediaItemCollection]?
    weak var delegate: ArtistTableViewCellDelegate?
    
    @IBOutlet weak var albumCollectionView: UICollectionView!
}

extension ArtistTableViewCell: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return albums?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AlbumCollectionViewCell", for: indexPath) as? AlbumCollectionViewCell else { return UICollectionViewCell() }
        cell.artworkImageView.image = albums?[indexPath.row].representativeItem?.artwork?.image(at: CGSize(width: 200, height: 200)) ?? UIImage(systemName: "music.note")
        cell.titleLabel.text = albums?[indexPath.row].representativeItem?.albumTitle
        cell.titleLabel.adjustsFontSizeToFitWidth = true
        
        return cell
    }
    
}


extension ArtistTableViewCell: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let album = albums?[indexPath.row] else { return }
        delegate?.didSelected(album: album)
        MusicPlayManager.shared.play(album)
    }
}
