//
//  SearchCoordinator.swift
//  CravingForSound
//
//  Created by Rodion on 22/10/2019.
//  Copyright © 2019 LetsSee. All rights reserved.
//

import Foundation
import Common
import UIKit
import RxSwift
import Model
import Net

final class SearchCoordinator: Coordinator<SearchCoordinator.Result>, CommonNavigation {

    // MARK: - Result
    
    enum Result { case dismiss, close }
    
    // MARK: - Properties
    
    private let window: UIWindow
    private let navController = UINavigationController()
    let dataProvider = DataProvider()
    let networkService = NetworkService()
    
    private let onFinish = PublishSubject<Result>()
    
    init(window: UIWindow) {
        self.window = window
    }
    
    // MARK: - Start
    
    override func start() -> Single<Result> {
        return Single.create { [unowned self] observer in
            
            self.window.rootViewController?.present(self.navController, animated: true, completion: nil)
            self.pushSearchController(to: self.navController, animated: false)
            self.setupRx()
            //self.configureAppearance()

            return self.onFinish
                .takeOneAsSingle()
                .map { $0 }
                .subscribe(observer)
        }
    }
    
    // MARK: - Setup
    
    private func setupRx() {
        self.navController.presentationController?.rx.presentationControllerDidDismiss?.subscribe(onNext: { _ in
            self.onFinish.onNext(.dismiss)
         }).disposed(by: disposeBag)
    }
    
    private func configureAppearance() {
        UINavigationBar.appearance().isTranslucent = true
        UINavigationBar.appearance().barStyle = .black
        UINavigationBar.appearance().tintColor = .systemGreen
        UINavigationBar.appearance().titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.font: UIFont(name: "Avenir", size: 21)!]
    }
    
    private func pushSearchController(to navController: UINavigationController, animated: Bool) {
        guard let controller = R.storyboard.main.artistLookupViewController() else { return }
        
        let viewModel = ArtistLookupViewModel(with: networkService)
        controller.viewModel = viewModel
        
        viewModel.navigation.goBack.bind { [unowned self] in
            self.onFinish.onNext(.close)
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
            self.showAlbumDetailsViewController(with: album,
                                                to: navController,
                                                animated: true,
                                                showCloseButton: true)
        }.disposed(by: disposeBag)
        
        viewModel.navigation.goBack.bind { [unowned self] in
            self.goBack(in: navController, animated: true)
        }.disposed(by: disposeBag)
        
        viewModel.navigation.close.bind { [unowned self] in
            self.dismissModalController(in: self.window, animated: true)
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
    
}
