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

final class ArtistDetailsViewModel {
    
    // MARK: - Properties
    
    private let disposeBag = DisposeBag()
    private let networkService: NetworkServiceProtocol
    private let dataProvider: DataProvidingProtocol
    
    let id: String
    let title: String
    let items = PublishSubject<[AlbumCollectionViewModel]>()
    
    // MARK: - Navigation
    
    let navigation = (
        goBack: PublishSubject<Void>(),
        albumDetails: PublishSubject<AlbumCollectionViewModel>()
    )
    
    // MARK: - Methods
    
    init(with viewModel: ArtistViewModel, networkService: NetworkServiceProtocol, dataProvider: DataProvidingProtocol) {
        self.id = viewModel.mdib
        self.title = viewModel.name
        
        self.networkService = networkService
        self.dataProvider = dataProvider
    }
    
    func getAlbums() {
        networkService.topAlbums(by: id).subscribe(onSuccess: { albums in
            self.items.onNext(albums.map { AlbumCollectionViewModel(net: $0) })
        }, onError: { error in
            print("ERROR \(error)")
        }).disposed(by: disposeBag)
    }
    
}
