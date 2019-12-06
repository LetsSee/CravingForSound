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

final class AppCoordinator: Coordinator<Never>, AlbumNavigation {
    
    // MARK: - Properties
    
    private let navController = UINavigationController()
    
    let window = UIWindow(frame: UIScreen.main.bounds)
    let dataProvider = DataProvider()
    let networkService = NetworkService()
    
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
        UINavigationBar.appearance().tintColor = .systemGreen
    }
    
    // MARK: - Navigation
    
    private func showMainController(to navController: UINavigationController, animated: Bool) {
        guard let controller = R.storyboard.main.mainViewController() else { return }
        
        let viewModel = MainViewModel(with: dataProvider, networkService: networkService)
        controller.viewModel = viewModel
        
        viewModel.navigation.artistSearch.bind { [unowned self] in
            self.showSearch(in: self.window)
        }.disposed(by: disposeBag)
        
        viewModel.navigation.albumDetails.bind { [unowned self] album in
            self.showAlbumDetailsViewController(with: album,
                                                to: navController,
                                                animated: true,
                                                showCloseButton: false)
        }.disposed(by: disposeBag)
        
        navController.pushViewController(controller, animated: animated)
    }
    
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
    
    private func showSearch(in window: UIWindow) {
        let searchCoordinator = SearchCoordinator(window: window)
        
        coordinate(to: searchCoordinator).subscribe(onSuccess: { [unowned self] result in
            switch result {
            case .close:
                self.dismissModalController(in: self.window, animated: true)
            case .dismiss:
                if debug { print("SearchCoordinator dismissed") }
            }
            
        }).disposed(by: disposeBag)
    }
    
}
