//
//  ViewController.swift
//  Craving for Sound
//
//  Created by Rodion on 03/10/2019.
//  Copyright © 2019 LetsSee. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Common
import Model

final class MainViewController: UIViewController {
    
    // MARK: - Properties
    
    private let disposeBag = DisposeBag()
    var viewModel: MainViewModel!
    
    @IBOutlet private weak var collectionView: UICollectionView!
    private let searchButton = UIBarButtonItem(barButtonSystemItem: .search, target: nil, action: nil)
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupRx()
    }
    
    // MARK: - Setup
    
    private func setupUI() {
        navigationItem.title = viewModel.title
        navigationItem.rightBarButtonItem = searchButton
        collectionView.collectionViewLayout = createCollectionLayout()
    }
    
    private func setupRx() {
        viewModel.items.bind(to: items()).disposed(by: disposeBag)
        
        searchButton.rx.tap.subscribe(onNext: { [unowned self] _ in
            self.viewModel.artistLookupNavigation.onNext()
        }).disposed(by: disposeBag)
    }
    
    // MARK: - Rx methods
    
    func items() -> (_ source: Observable<[AlbumCollectionViewModel]>) -> Disposable {
        return { [unowned self] source in
            source
                .bind(to: self.collectionView.rx
                    .items(cellIdentifier: AlbumCollectionViewCell.defaultIdentifier,
                           cellType: AlbumCollectionViewCell.self)) { _, element, cell in
                            cell.setup(with: element)
            }
        }
    }
    
    private func createCollectionLayout() -> UICollectionViewFlowLayout {
        let cellWidth = view.bounds.width/2 - standardOffset
        let layout = LeftAlignedLayout(itemSpacing: 2, leftInset: standardOffset, lineSpacing: standardOffset)
        layout.sectionInset = UIEdgeInsets(top: 8, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: cellWidth, height: cellWidth+54)
        return layout
    }
    
    deinit {
        if debug { print("\(type(of: self)) destroyed") }
    }
    
}
