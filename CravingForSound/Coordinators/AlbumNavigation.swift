//
//  AlbumNavigation.swift
//  CravingForSound
//
//  Created by Rodion on 06.12.2019.
//  Copyright © 2019 LetsSee. All rights reserved.
//

import UIKit
import RxSwift
import Model
import Net

protocol AlbumNavigation: CommonNavigation {
    
    var disposeBag: DisposeBag { get }
    var networkService: NetworkService { get }
    var dataProvider: DataProvider { get }
    var window: UIWindow { get }
    
    func showAlbumDetailsViewController(with album: AlbumPresentingProtocol,
                                        to navController: UINavigationController,
                                        animated: Bool, showCloseButton: Bool)
}

extension AlbumNavigation {
    
    func showAlbumDetailsViewController(with album: AlbumPresentingProtocol,
                                        to navController: UINavigationController,
                                        animated: Bool,
                                        showCloseButton: Bool) {
        guard let controller = R.storyboard.main.albumDetailsViewController() else { return }
        
        let viewModel = AlbumDetailsViewModel(with: album,
                                              networkService: networkService,
                                              dataProvider: dataProvider)
        
        viewModel.navigation.goBack.bind { [unowned self] in
            self.goBack(in: navController, animated: true)
        }.disposed(by: disposeBag)
        
        viewModel.navigation.close.bind { [unowned self] in
            self.dismissModalController(in: self.window, animated: true)
        }.disposed(by: disposeBag)
        
        controller.viewModel = viewModel
        
        navController.pushViewController(controller, animated: animated)
    }
    
}
