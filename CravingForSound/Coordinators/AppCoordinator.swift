//
//  AppCoordinator.swift
//  CravingForSound
//
//  Created by Rodion on 07/10/2019.
//  Copyright © 2019 LetsSee. All rights reserved.
//

import Foundation
import Common
import UIKit
import RxSwift
import Model
import Net

final class AppCoordinator: Coordinator<Never>, CommonNavigation {
    
    // MARK: - Properties
    
    private let window = UIWindow(frame: UIScreen.main.bounds)
    private let navController = UINavigationController()
    private let dataProvider = DataProvider()
    private let networkService = NetworkService()
    
    // MARK: - Start
    
    override func start() -> Single<Never> {
        return Single.create { [unowned self] observer in
            
            self.window.rootViewController = self.navController
            self.window.makeKeyAndVisible()
            
            self.configureAppearance()
            self.showMainController(to: self.navController, animated: false)
            return Single.never().subscribe(observer)
        }
    }
    
    // MARK: - Setup
    
    private func configureAppearance() {
        //        navController.navigationBar.barTintColor = .black
        //        navController.navigationBar.isTranslucent = true
        //        navController.navigationBar.barStyle = .blackTranslucent
    }
    
    // MARK: - Navigation
    
    private func showMainController(to navController: UINavigationController, animated: Bool) {
        guard let controller = R.storyboard.main.mainViewController() else { return }
        
        let viewModel = MainViewModel(with: dataProvider, networkService: networkService)
        controller.viewModel = viewModel
        
        viewModel.artistLookupNavigation.bind { [unowned self] in
            self.showArtistLookupController(to: navController, animated: true)
        }.disposed(by: disposeBag)
        
        navController.pushViewController(controller, animated: animated)
    }
    
    private func showArtistLookupController(to navController: UINavigationController, animated: Bool) {
        guard let controller = R.storyboard.main.artistLookupViewController() else { return }
        
        let viewModel = ArtistLookupViewModel(with: networkService)
        controller.viewModel = viewModel
        
        viewModel.navigation.goBack.bind { [unowned self] in
            self.goBack(in: navController, animated: true)
        }.disposed(by: disposeBag)
        
        viewModel.navigation.artistDetails.bind { [unowned self] artist in
            self.showArtistDetailsViewController(with: artist, to: navController, animated: true)
        }.disposed(by: disposeBag)
        
        navController.pushViewController(controller, animated: animated)
    }
    
    private func showArtistDetailsViewController(with artist: ArtistViewModel,
                                                 to navController: UINavigationController,
                                                 animated: Bool) {
        guard let controller = R.storyboard.main.artistDetailsViewController() else { return }
        
        let viewModel = ArtistDetailsViewModel(with: artist,
                                               networkService: networkService,
                                               dataProvider: dataProvider)
        controller.viewModel = viewModel
        
        viewModel.navigation.albumDetails.bind { [unowned self] album in
            self.showAlbumDetailsViewController(with: album, to: navController, animated: true)
        }.disposed(by: disposeBag)
        
        navController.pushViewController(controller, animated: animated)
    }
    
    private func showAlbumDetailsViewController(with album: AlbumCollectionViewModel,
                                                to navController: UINavigationController,
                                                animated: Bool) {
        guard let controller = R.storyboard.main.albumDetailsViewController() else { return }
        
        let viewModel = AlbumDetailsViewModel(with: album,
                                              networkService: networkService,
                                              dataProvider: dataProvider)
        controller.viewModel = viewModel
        
        navController.pushViewController(controller, animated: animated)
    }
    
}
