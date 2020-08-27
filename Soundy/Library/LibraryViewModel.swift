//
//  LibraryViewModel.swift
//  Soundy
//
//  Created by okmin lee on 2020/08/26.
//  Copyright © 2020 okmin lee. All rights reserved.
//

import MediaPlayer

protocol LibraryViewModelInput {
    func checkMediaLibraryAuthorization()
    func getMediaItems()
}

protocol LibraryViewModelOutput {
    var mediaLibraryAuthorized: State<Bool?> { get set }
    var mediaItems: State<[MPMediaItem]?> { get }
}


class LibraryViewModel: NSObject, LibraryViewModelOutput {
    var input: LibraryViewModelInput { return self }
    var output: LibraryViewModelOutput { return self }
    
    var mediaLibraryAuthorized = State<Bool?>(nil)
    var mediaItems = State<[MPMediaItem]?>(nil)
    
    var albums:[String:[String]] = [:]
    
    var artists: [MPMediaItemCollection]?
}

extension LibraryViewModel: LibraryViewModelInput {
    func checkMediaLibraryAuthorization() {
        let status = MPMediaLibrary.authorizationStatus()
        switch status {
        case .authorized:
            mediaLibraryAuthorized.value = true
        case .notDetermined, .denied, .restricted:
            requestMediaLibraryAuthorization()
        @unknown default:
            requestMediaLibraryAuthorization()
        }
    }
    
    private func requestMediaLibraryAuthorization() {
        MPMediaLibrary.requestAuthorization { [weak self] status in
            switch status {
            case .authorized:
                self?.mediaLibraryAuthorized.value = true
            case .notDetermined, .denied, .restricted:
                self?.mediaLibraryAuthorized.value = false
            @unknown default: break
            }
        }
    }
    
    func getMediaItems() {
        guard let mediaItems = MPMediaQuery.songs().items else { return }
        self.mediaItems.value = mediaItems
        
        artists = MPMediaQuery.artists().collections
        
//        print(artists?[0].items.map { $0.albumTitle }.uniques, artists?[0].items[0].albumTitle)
        guard let albums = MPMediaQuery.albums().items else { return }
        for album in albums {
            
            guard let artist = album.artist, let title = album.albumTitle else { continue }
            if let dest = self.albums[artist] {
                if !dest.contains(title) {
                    self.albums[artist]?.append(title)
                }
            } else {
                self.albums.updateValue([title], forKey: artist)
            }
        }
        
        print(self.albums)
        print()
    }
}

extension LibraryViewModel: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.artists?.count ?? 0
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let artist = self.artists?[section].representativeItem?.artist else { return "unknown" }
        return artist
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ArtistTableViewCell", for: indexPath) as? ArtistTableViewCell else { return UITableViewCell() }
        cell.albums = self.artists?[indexPath.section].items.map { $0.albumTitle }.uniques
        cell.albumCollectionView.register(UINib(nibName: "AlbumCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "AlbumCollectionViewCell")
        cell.albumCollectionView.dataSource = cell
        cell.albumCollectionView.delegate = self
        cell.albumCollectionView.reloadData()
        return cell
    }
}

extension LibraryViewModel: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
}


extension LibraryViewModel: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

    }
}
