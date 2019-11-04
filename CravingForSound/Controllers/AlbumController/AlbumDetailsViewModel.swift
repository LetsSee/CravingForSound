//
//  AlbumDetailsViewModel.swift
//  CravingForSound
//
//  Created by Rodion on 12/10/2019.
//  Copyright © 2019 LetsSee. All rights reserved.
//

import Foundation
import Net
import RxSwift
import RxCocoa
import Model
import Common

final class AlbumDetailsViewModel {
    
    // MARK: - Properties
    
    private let disposeBag = DisposeBag()
    private let networkService: NetworkServiceProtocol
    private let dataProvider: DataProvidingProtocol
    private let albumId: String
    private var savedAlbum: Model.Album?
    
    let albumViewModel: BehaviorRelay<AlbumPresentingProtocol>
    let errorMessage = PublishSubject<String>()
    let warning = PublishSubject<String>()
    let isLoading = BehaviorRelay(value: false)
    
    // MARK: - Navigation
    
    let navigation = (
        goBack: PublishSubject<Void>(),
        close: PublishSubject<Void>()
    )
    
    // MARK: - Setup
    
    init(with viewModel: AlbumPresentingProtocol,
         networkService: NetworkServiceProtocol,
         dataProvider: DataProvidingProtocol) {

        self.albumId = viewModel.mbid
        albumViewModel = BehaviorRelay(value: viewModel)
        
        self.networkService = networkService
        self.dataProvider = dataProvider
        self.setup()
    }
    
    private func setup() {
        do {
            try watchAlbum()
        } catch {
            self.errorMessage.onNext(error.localizedDescription)
        }
    }
    
    private func watchAlbum() throws {
        try dataProvider.getAlbum(by: albumId)?.subscribe(onNext: { [unowned self] album in
            self.savedAlbum = album
            self.albumViewModel.accept(AlbumViewModel(with: album))
        }).disposed(by: disposeBag)
    }
    
    // MARK: - Methods
    
    func getAlbumInfo() {
        let noTracks = albumViewModel.value.tracks.count == 0
        
        let mbid = albumViewModel.value.mbid
        let title = albumViewModel.value.title
    
        if noTracks { isLoading.accept(true) }
        
        networkService.albumInfo(by: mbid, name: title).subscribe(onSuccess: { [unowned self] albumDetails in
            if noTracks { self.isLoading.accept(false) }
            if let savedAlbum = self.savedAlbum {
                do {
                    try self.dataProvider.update(album: savedAlbum) { album in
                        let viewModel = AlbumViewModel(with: albumDetails)
                        album.update(with: viewModel)
                    }
                } catch {
                    self.errorMessage.onNext(error.localizedDescription)
                }
            } else {
                self.albumViewModel.accept(AlbumViewModel(with: albumDetails))
            }
        }, onError: { [unowned self] error in
            if noTracks { self.isLoading.accept(false) }
            self.warning.onNext(error.localizedDescription)
        }).disposed(by: disposeBag)
    }
    
    func manageAlbumKeeping() {
        guard let album = Model.Album.createAlbum(with: albumViewModel.value) else {
            return
        }
        
        if let savedAlbum = savedAlbum {
            do {
                let isDeleted = !savedAlbum.isDeleted
                try dataProvider.set(album: savedAlbum, isDeleted: isDeleted)
            } catch {
                errorMessage.onNext(error.localizedDescription)
            }
        } else {
            do {
                try dataProvider.save(album: album)
                try watchAlbum()
            } catch {
                errorMessage.onNext(error.localizedDescription)
            }
        }

    }

    deinit {
        if debug { print("\(type(of: self)) destroyed") }
    }
    
}
