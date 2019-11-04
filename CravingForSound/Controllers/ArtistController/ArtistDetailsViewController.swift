//
//  ArtistController.swift
//  CravingForSound
//
//  Created by Rodion on 11/10/2019.
//  Copyright © 2019 LetsSee. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Common

final class ArtistDetailsViewController: UIViewController {
    
    // MARK: - Properties
    
    private let disposeBag = DisposeBag()
    private let spinner  = SpinnerView()

    var viewModel: ArtistDetailsViewModel!
    
    @IBOutlet private weak var collectionView: UICollectionView!
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupRx()
        viewModel.getAlbums()
    }
    
    // MARK: - Setup
    
    private func setupUI() {
        navigationItem.title = viewModel.title
        collectionView.collectionViewLayout = createCollectionLayout()
        addSpinner(spinner)
    }
    
    private func setupRx() {
        viewModel.albums.asDriver().drive(items()).disposed(by: disposeBag)
        
        collectionView.rx.modelSelected(AlbumViewModel.self).subscribe(onNext: { [unowned self] viewModel in
            self.viewModel.navigation.albumDetails.onNext(viewModel)
        }).disposed(by: disposeBag)
        
        viewModel.error.subscribe(onNext: { [unowned self] message in
            self.alert(message: message, tryAgainHandler: { [unowned self] in
                self.viewModel.getAlbums()
            }, closeHandler: { [unowned self] in
                self.viewModel.navigation.goBack.onNext()
            })
        }).disposed(by: disposeBag)
        
        viewModel.isLoading.bind(to: spinner.rx.isVisible).disposed(by: disposeBag)
    }
    
    private func createCollectionLayout() -> UICollectionViewFlowLayout {
        let cellWidth = view.bounds.width/2 - standardOffset
        let layout = LeftAlignedLayout(itemSpacing: 2, leftInset: standardOffset, lineSpacing: standardOffset)
        layout.sectionInset = UIEdgeInsets(top: 8, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: cellWidth, height: cellWidth+54)
        return layout
    }
    
    // MARK: - Rx methods
    
    func items() -> (_ source: Observable<[AlbumViewModel]>) -> Disposable {
        return { [unowned self] source in
            source
                .bind(to: self.collectionView.rx
                    .items(cellIdentifier: AlbumCollectionViewCell.defaultIdentifier,
                           cellType: AlbumCollectionViewCell.self)) { _, element, cell in
                            cell.setup(with: element)
            }
        }
    }
    
    deinit {
        if debug { print("\(type(of: self)) destroyed") }
    }

}
