//
//  MainViewModel.swift
//  CravingForSound
//
//  Created by Rodion on 07/10/2019.
//  Copyright © 2019 LetsSee. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Model
import Net

struct MainViewModel {
    
    // MARK: - Properties
    
    let title = R.string.common.albumsStored()
    private let dataProvider: DataProvidingProtocol
    private let networkService: NetworkServiceProtocol
    private let disposeBag = DisposeBag()
    
    lazy var albums = try? dataProvider.getAlbums().map { albums in albums.map { AlbumViewModel(with: $0) } }
    
    // MARK: - Navigation
    
    let navigation = (
        artistSearch: PublishSubject<Void>(),
        albumDetails: PublishSubject<AlbumViewModel>()
    )
    
    // MARK: - Methods
    
    init(with dataProvider: DataProvidingProtocol, networkService: NetworkServiceProtocol) {
        self.dataProvider = dataProvider
        self.networkService = networkService
    }
    
}
