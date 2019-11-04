//
//  AlbumDetailsViewController.swift
//  CravingForSound
//
//  Created by Rodion on 12/10/2019.
//  Copyright © 2019 LetsSee. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Common

final class AlbumDetailsViewController: UIViewController {
    
    // MARK: - Properties
    
    private let disposeBag = DisposeBag()
    private let headerView = AlbumHeaderView()
    private let spinner  = SpinnerView()
    
    var viewModel: AlbumDetailsViewModel!
    
    @IBOutlet private weak var tableView: UITableView!
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupRx()
        
        viewModel.getAlbumInfo()
    }
    
    // MARK: - Setup
    
    private func setupUI() {
        tableView.tableHeaderView = headerView
        tableView.tableFooterView = UIView()
        addSpinner(spinner, in: tableView, customTopOffset: albumHeaderHeight)
    }
    
    private func setupRx() {
        viewModel.albumViewModel.map { $0.tracks }.bind(to: items()).disposed(by: disposeBag)
        viewModel.albumViewModel.bind(to: headerView.rx.state).disposed(by: disposeBag)

        headerView.addButton.rx.tap.subscribe(onNext: { [unowned self] _ in
            self.viewModel.manageAlbumKeeping()
        }).disposed(by: disposeBag)
        
        viewModel.warning.subscribe(onNext: { [unowned self] message in
            self.showToastView(with: message)
        }).disposed(by: disposeBag)
        
        viewModel.errorMessage.subscribe(onNext: { [unowned self] message in
            self.alert(message: message, tryAgainHandler: nil) {
                self.viewModel.navigation.goBack.onNext()
            }
        }).disposed(by: disposeBag)
        
        tableView.rx.itemSelected.subscribe(onNext: { [unowned self] indexPath in
            self.tableView.deselectRow(at: indexPath, animated: true)
        }).disposed(by: disposeBag)
        
        viewModel.isLoading.bind(to: spinner.rx.isVisible).disposed(by: disposeBag)
    }
    
    // MARK: - Rx methods
    
    private func items() -> (_ source: Observable<[TrackPresentingProtocol]>) -> Disposable {
        return { [unowned self] source in
            source
                .bind(to: self.tableView.rx
                    .items(cellIdentifier: TrackTableViewCell.defaultIdentifier,
                           cellType: TrackTableViewCell.self)) { _, element, cell in
                            cell.setup(with: element)
            }
        }
    }
    
    deinit {
        if debug { print("\(type(of: self)) destroyed") }
    }

}
