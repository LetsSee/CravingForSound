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
    var viewModel: AlbumDetailsViewModel!
    
    @IBOutlet weak var tableView: UITableView!
    private let headerView = AlbumHeaderView()
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupRx()
        viewModel.getAlbumInfo()
    }
    
    // MARK: - Setup
    
    private func setupUI() {
        navigationItem.title = viewModel.headerViewModel.value.title
        tableView.tableHeaderView = headerView
    }
    
    private func setupRx() {
        viewModel.items.bind(to: items()).disposed(by: disposeBag)
        viewModel.headerViewModel.subscribe(onNext: { [unowned self] headerViewModel in
            self.headerView.configue(with: headerViewModel)
            self.tableView.layoutIfNeeded()
        }).disposed(by: disposeBag)
    }
    
    // MARK: - Rx methods
    
    func items() -> (_ source: Observable<[TrackViewModel]>) -> Disposable {
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
