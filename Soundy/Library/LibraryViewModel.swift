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
}

protocol LibraryViewModelOutput {
    var mediaLibraryAuthorized: State<Bool?> { get set }
    var mediaItems: [MPMediaItem] { get }
}


class LibraryViewModel: LibraryViewModelOutput {
    var input: LibraryViewModelInput { return self }
    var output: LibraryViewModelOutput { return self }
    
    var mediaLibraryAuthorized = State<Bool?>(nil)
    
    var mediaItems: [MPMediaItem] {
        guard let mediaItems = MPMediaQuery.songs().items else { return [] }
        return mediaItems
    }
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
}