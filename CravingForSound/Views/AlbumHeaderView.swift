//
//  AlbumHeaderView.swift
//  CravingForSound
//
//  Created by Rodion on 13/10/2019.
//  Copyright © 2019 LetsSee. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Common

let albumHeaderHeight: CGFloat = 160

final class AlbumHeaderView: UIView {
    
    let imageView = UIImageView()
    let titleLabel = UILabel()
    let artistLabel = UILabel()
    let addButton = UIButton()
    
    let disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        configureLayout()
        configureUI()
    }
    
    private func configureLayout() {
        addSubview(imageView)
        addSubview(titleLabel)
        addSubview(artistLabel)
        addSubview(addButton)
        
        imageView.snp.makeConstraints { make in
            make.height.width.equalTo(140)
            make.top.leading.equalToSuperview().offset(doubleOffset)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(doubleOffset)
            make.leading.equalTo(imageView.snp.trailing).offset(standardOffset)
            make.trailing.equalToSuperview().inset(standardOffset)
        }
        
        artistLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(standardOffset)
            make.leading.equalTo(imageView.snp.trailing).offset(standardOffset)
            make.trailing.equalToSuperview().inset(standardOffset)
        }
        
        addButton.snp.makeConstraints { make in
            make.leading.equalTo(imageView.snp.trailing).offset(standardOffset)
            make.width.equalTo(80)
            make.height.equalTo(34)
            make.bottom.equalTo(imageView.snp.bottom)
        }
        
        snp.makeConstraints { make in
            make.height.equalTo(albumHeaderHeight)
            make.width.equalTo(UIScreen.main.bounds.width)
        }
    }
    
    private func configureUI() {
        addButton.backgroundColor = .flatGreen
        addButton.titleColor = .white
        addButton.title = R.string.common.save().uppercased()
        addButton.titleFont = .systemFont(ofSize: 14)
        addButton.clipsToBounds = true
        addButton.layer.cornerRadius = 15
        
        titleLabel.font = .boldSystemFont(ofSize: 21)
        titleLabel.numberOfLines = 2
        artistLabel.font = .systemFont(ofSize: 17)
    }
    
    fileprivate func configue(with viewModel: AlbumPresentingProtocol) {
        if let url = viewModel.imageUrl {
            imageView.af_setImage(withURL: url, placeholderImage: R.image.placeholder())
        } else {
            imageView.image = R.image.placeholder()
        }
        
        titleLabel.text = viewModel.title
        artistLabel.text = viewModel.artist
        addButton.title = viewModel.isSaved
            ? R.string.common.delete().uppercased()
            : R.string.common.save().uppercased()
    }
    
}

extension Reactive where Base: AlbumHeaderView {
    var state: Binder<AlbumPresentingProtocol> {
        return Binder(self.base) { view, state in
            view.configue(with: state)
        }
    }

}
