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
    func requestSongs()
}

protocol LibraryViewModelOutput {
    var mediaLibraryAuthorized: State<Bool?> { get }
    var album: State<MPMediaItemCollection?> { get }
    var completedRequestSongs: State<Bool?> { get }
}

class LibraryViewModel: NSObject, LibraryViewModelOutput {
    var input: LibraryViewModelInput { return self }
    var output: LibraryViewModelOutput { return self }
    
    var mediaLibraryAuthorized = State<Bool?>(nil)
    var album = State<MPMediaItemCollection?>(nil)
    var completedRequestSongs = State<Bool?>(nil)

    private var songs: [MPMediaItemCollection]?
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
    
    func requestSongs() {
        guard let mediaItems = MPMediaQuery.artists().collections else { return }
        songs = mediaItems
        completedRequestSongs.value = true
    }
}

extension LibraryViewModel: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.songs?.count ?? 0
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let artist = self.songs?[section].representativeItem?.artist else { return "unknown" }
        return artist
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ArtistTableViewCell", for: indexPath) as? ArtistTableViewCell else { return UITableViewCell() }
        let query = MPMediaQuery.albums()
        let predic = MPMediaPropertyPredicate(value: self.songs?[indexPath.section].representativeItem?.artist, forProperty: MPMediaItemPropertyArtist)
        query.addFilterPredicate(predic)
        
        cell.delegate = self
        cell.albums = query.collections
        cell.albumCollectionView.register(UINib(nibName: "AlbumCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "AlbumCollectionViewCell")
        cell.albumCollectionView.dataSource = cell
        cell.albumCollectionView.delegate = cell
        cell.albumCollectionView.reloadData()
        return cell
    }
}

extension LibraryViewModel: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 258
    }
}

extension LibraryViewModel: ArtistTableViewCellDelegate {
    func didSelected(album: MPMediaItemCollection) {
        self.album.value = album
    }
}
