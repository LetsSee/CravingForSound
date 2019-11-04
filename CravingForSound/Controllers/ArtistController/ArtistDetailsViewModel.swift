//
//  ArtistDetailsViewModel.swift
//  CravingForSound
//
//  Created by Rodion on 11/10/2019.
//  Copyright © 2019 LetsSee. All rights reserved.
//

import Foundation
import Net
import RxSwift
import RxCocoa
import Model
import Common

final class ArtistDetailsViewModel {
    
    // MARK: - Properties
    
    private let disposeBag = DisposeBag()
    private let networkService: NetworkServiceProtocol
    private let dataProvider: DataProvidingProtocol
    private let artistId: String
   
    let title: String
    let albums = BehaviorRelay<[AlbumViewModel]>(value: [])
    let error = PublishSubject<String>()
    let isLoading = BehaviorRelay(value: false)
    
    // MARK: - Navigation
    
    let navigation = (
        goBack: PublishSubject<Void>(),
        close: PublishSubject<Void>(),
        albumDetails: PublishSubject<AlbumViewModel>()
    )
    
    // MARK: - Methods
    
    init(with viewModel: ArtistViewModel, networkService: NetworkServiceProtocol, dataProvider: DataProvidingProtocol) {
        self.artistId = viewModel.mdib
        self.title = viewModel.name
        
        self.networkService = networkService
        self.dataProvider = dataProvider
    }
    
    func getAlbums() {
        isLoading.accept(true)
        networkService.topAlbums(by: artistId).subscribe(onSuccess: { [unowned self] albums in
            self.isLoading.accept(false)
            self.albums.accept(albums.map { AlbumViewModel(with: $0) })
        }, onError: { [unowned self] error in
            self.isLoading.accept(false)
            self.error.onNext(error.localizedDescription)
        }).disposed(by: disposeBag)
    }
    
    deinit {
        if debug { print("\(type(of: self)) destroyed") }
    }
    
}
