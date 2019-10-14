//
//  AlbumHeaderView.swift
//  CravingForSound
//
//  Created by Rodion on 13/10/2019.
//  Copyright © 2019 LetsSee. All rights reserved.
//

import UIKit
import RxSwift
import SnapKit
import Common

final class AlbumHeaderView: UIView {
    
    let imageView = UIImageView()
    let titleLabel = UILabel()
    let artistLabel = UILabel()
    
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
        
        imageView.snp.makeConstraints { make in
            make.height.width.equalTo(100)
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
        
        snp.makeConstraints { make in
            make.height.equalTo(150)
        }
    }
    
    private func configureUI() {
        titleLabel.font = .boldSystemFont(ofSize: 20)
        artistLabel.font = .systemFont(ofSize: 17)
    }
    
    func configue(with viewModel: AlbumHeaderViewModel) {
        if let url = viewModel.imageUrl {
            imageView.af_setImage(withURL: url, placeholderImage: R.image.placeholder())
        } else {
            imageView.image = R.image.placeholder()
        }
        
        titleLabel.text = viewModel.title
        artistLabel.text = viewModel.artist
    }
    
}
