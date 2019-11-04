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
import Common

final class ArtistLookupViewModel {
    
    // MARK: - Properties
    
    private let disposeBag = DisposeBag()
    private let networkService: NetworkServiceProtocol
    
    let title = R.string.common.search()
    let items = BehaviorRelay<[ArtistViewModel]>(value: [])
    let warning = PublishSubject<String>()
    let isLoading = BehaviorRelay(value: false)
    
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
        isLoading.accept(true)
        self.items.accept([])
        networkService
            .artistSearch(by: name)
            .subscribe(onSuccess: { [unowned self] artists in
                self.isLoading.accept(false)
                self.items.accept(artists.map { ArtistViewModel(with: $0) })
            }, onError: { [unowned self]  error in
                self.isLoading.accept(false)
                self.warning.onNext(error.localizedDescription)
        }).disposed(by: disposeBag)
    }
    
    deinit {
        if debug { print("\(type(of: self)) destroyed") }
    }
    
}
