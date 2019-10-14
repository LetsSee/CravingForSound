//
//  MainViewModel.swift
//  CravingForSound
//
//  Created by Rodion on 07/10/2019.
//  Copyright © 2019 LetsSee. All rights reserved.
//

import Foundation
import RxSwift
import Model
import Net

struct MainViewModel {
    
    // MARK: - Properties
    
    let title = R.string.common.albumsStored()
    private let dataProvider: DataProvidingProtocol
    private let networkService: NetworkServiceProtocol
    private(set) lazy var items = dataProvider.getAlbums().map { albums in
        albums.map { AlbumCollectionViewModel(with: $0) }
    }
    
    // MARK: - Navigation
    
    let artistLookupNavigation = PublishSubject<Void>()
    
    // MARK: - Methods
    
    init(with dataProvider: DataProvidingProtocol, networkService: NetworkServiceProtocol) {
        self.dataProvider = dataProvider
        self.networkService = networkService
    }

    func crateTestAlbum() {
        do {
            try dataProvider.createTestAlbum()
        } catch {
            print("Error: \(error)")
        }
    }
    
    //let didSelect = PublishRelay<AlbumCollectionViewPresentingProtocol>()
    
}
