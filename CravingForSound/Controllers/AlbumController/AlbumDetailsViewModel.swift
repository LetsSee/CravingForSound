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

struct AlbumHeaderViewModel {
    
    let mbid: String?
    let imageUrl: URL?
    let title: String
    let artist: String
    
}

final class AlbumDetailsViewModel {
    
    // MARK: - Properties
    
    private let disposeBag = DisposeBag()
    private let networkService: NetworkServiceProtocol
    private let dataProvider: DataProvidingProtocol
    
    let id: String?
    
    let items = PublishSubject<[TrackViewModel]>()
    let headerViewModel: BehaviorRelay<AlbumHeaderViewModel>
    
    // MARK: - Navigation
    
    let goBacknavigation = PublishSubject<Void>()
    
    // MARK: - Methods
    
    init(with viewModel: AlbumCollectionViewPresentingProtocol,
         networkService: NetworkServiceProtocol,
         dataProvider: DataProvidingProtocol) {

        self.id = viewModel.mbid
        
        let header = AlbumHeaderViewModel(mbid: viewModel.mbid,
                                          imageUrl: viewModel.imageUrl,
                                          title: viewModel.title,
                                          artist: viewModel.artist)
        
        headerViewModel = BehaviorRelay(value: header)
        
        self.networkService = networkService
        self.dataProvider = dataProvider
    }
    
    func getAlbumInfo() {
        let mbid = headerViewModel.value.mbid
        let title = headerViewModel.value.title
        
        networkService.albumInfo(by: mbid, name: title).subscribe(onSuccess: { album in
            self.items.onNext(album.tracks.map { TrackViewModel(with: $0) })
        }, onError: { error in
            print("ERROR \(error)")
        }).disposed(by: disposeBag)
    }
    
}
