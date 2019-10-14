//
//  ArtistLookupViewModel.swift
//  CravingForSound
//
//  Created by Rodion on 10/10/2019.
//  Copyright © 2019 LetsSee. All rights reserved.
//

import Foundation
import Net
import RxSwift
import RxCocoa

final class ArtistLookupViewModel {
    
    // MARK: - Properties
    
    private let disposeBag = DisposeBag()
    private let networkService: NetworkServiceProtocol
    
    let title = R.string.common.search()
    let items = PublishSubject<[ArtistViewModel]>()
    
    // MARK: - Navigation
    
    let navigation = (
        goBack: PublishSubject<Void>(),
        artistDetails: PublishSubject<ArtistViewModel>()
    )
    
    // MARK: - Methods
    
    init(with networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }
    
    func search(for name: String) {
        networkService
            .artistSearch(by: name)
            .subscribe(onSuccess: { [unowned self] artists in
                self.items.onNext(artists.map { ArtistViewModel(with: $0) })
            }, onError: { error in
                print("ERROR \(error)")
        }).disposed(by: disposeBag)
    }
    
}
