//
//  ViewController.swift
//  Soundy
//
//  Created by okmin lee on 2020/08/26.
//  Copyright © 2020 okmin lee. All rights reserved.
//

import UIKit
import MediaPlayer

class LibraryViewController: SoundyViewController<LibraryView, LibraryViewModel> {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.input.checkMediaLibraryAuthorization()
        
        bindViewModel()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let viewController = segue.destination as? AlbumViewController, let album = sender as? MPMediaItemCollection {
            viewController.album = album
        }
    }
}

// MARK: Bind ViewModel
extension LibraryViewController {
    private func bindViewModel() {
        bindMediaLibraryAuthorized()
        bindMediaItems()
        bindAlbum()
    }
    
    private func bindMediaLibraryAuthorized() {
        viewModel.output.mediaLibraryAuthorized.bind { [weak self] authorized in
            guard let authorized = authorized else { return }
            if authorized {
                self?.viewModel.input.getMediaItems()
            }
            if !authorized {
                self?.showSettingsAlert()
            }
        }
    }
    
    private func bindMediaItems() {
        viewModel.output.mediaItems.bind { [weak self] items in
            self?.rootView.artistTableView.register(UINib(nibName: "ArtistTableViewCell", bundle: nil), forCellReuseIdentifier: "ArtistTableViewCell")
            self?.rootView.artistTableView.dataSource = self?.viewModel
            self?.rootView.artistTableView.delegate = self?.viewModel
        }
    }
    
    private func bindAlbum() {
        viewModel.output.album.bind { [weak self] album in
            guard let album = album else { return }
            self?.performSegue(withIdentifier: "libraryToAlbum", sender: album)
        }
    }

    private func showSettingsAlert() {
        let alertController = UIAlertController(title: "앱을 사용하기 위해서 권한이 필요합니다.", message: "설정으로 이동해 미디어 및 Apple Music 권한을 허용해 주세요.", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "확인", style: .default) { _ in
            DispatchQueue.main.async {
                guard let settingsUrl = URL(string: UIApplication.openSettingsURLString), UIApplication.shared.canOpenURL(settingsUrl) else { return }
                UIApplication.shared.open(settingsUrl, completionHandler: nil)
            }
        }
        alertController.addAction(alertAction)
        present(alertController, animated: true, completion: nil)
    }
}
