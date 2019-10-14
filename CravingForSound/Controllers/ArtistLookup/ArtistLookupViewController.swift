//
//  ArtistLookupViewController.swift
//  CravingForSound
//
//  Created by Rodion on 10/10/2019.
//  Copyright © 2019 LetsSee. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxKeyboard
import Common

final class ArtistLookupViewController: UIViewController {
    
    // MARK: - Properties
    
    private let disposeBag = DisposeBag()
    var viewModel: ArtistLookupViewModel!
    
    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var tableView: UITableView!
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupRx()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        searchBar.becomeFirstResponder()
    }
    
    // MARK: - Setup
    
    private func setupUI() {
        tableView.rowHeight = 60
        navigationItem.title = viewModel.title
        searchBar.placeholder = R.string.common.artist()
    }
    
    func items() -> (_ source: Observable<[ArtistViewModel]>) -> Disposable {
        return { [unowned self] source in
            source
                .bind(to: self.tableView.rx
                    .items(cellIdentifier: ArtistTableViewCell.defaultIdentifier,
                           cellType: ArtistTableViewCell.self)) { _, element, cell in
                            cell.setup(with: element)
            }
        }
    }
    
    private func setupRx() {
        viewModel.items.bind(to: items()).disposed(by: disposeBag)
        
        searchBar.rx.cancelButtonClicked.subscribe(onNext: { [unowned self] _ in
            self.viewModel.navigation.goBack.onNext()
        }).disposed(by: disposeBag)
        
        searchBar.rx.text.subscribe(onNext: { [unowned self] string in
            guard let string = string else { return }
            self.searchBar.setShowsCancelButton(!string.isEmpty, animated: true)
        }).disposed(by: disposeBag)
        
        searchBar.rx.searchButtonClicked.subscribe(onNext: {[unowned self] _ in
            self.viewModel.search(for: self.searchBar.text ?? "")
        }).disposed(by: disposeBag)
        
        RxKeyboard.instance.visibleHeight
            .drive(onNext: {[unowned self] height in
            self.tableView.contentInset.bottom = height
        }).disposed(by: disposeBag)
        
        tableView.rx.itemSelected.subscribe(onNext: { [unowned self] indexPath in
            self.tableView.deselectRow(at: indexPath, animated: true)
        }).disposed(by: disposeBag)
        
        tableView.rx.modelSelected(ArtistViewModel.self).subscribe(onNext: { [unowned self] artist in
            self.viewModel.navigation.artistDetails.onNext(artist)
        }).disposed(by: disposeBag)
    }
    
    deinit {
        if debug { print("\(type(of: self)) destroyed") }
    }
    
}
