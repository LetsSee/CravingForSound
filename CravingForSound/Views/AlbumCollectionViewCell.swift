//
//  AlbumCollectionViewCell.swift
//  CravingForSound
//
//  Created by Rodion on 07/10/2019.
//  Copyright © 2019 LetsSee. All rights reserved.
//

import UIKit
import AlamofireImage
import Rswift
import SnapKit
import Common

final class AlbumCollectionViewCell: UICollectionViewCell {
    
    private let imageView = UIImageView()
    private let titleLabel = UILabel()
    private let artistLabel = UILabel()
    
    // MARK: - Init & overrides
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    // MARK: - Setup
    
    private func setup() {
        contentView.addSubviews(imageView, titleLabel, artistLabel)
        imageView.contentMode = .scaleAspectFill
        titleLabel.font = UIFont.boldSystemFont(ofSize: 15)
        artistLabel.font = UIFont.systemFont(ofSize: 15)
        
        artistLabel.textColor = .systemGray
        
        imageView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview().inset(standardOffset)
            make.bottom.equalTo(titleLabel.snp.top)
            make.width.equalTo(imageView.snp.height)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(standardOffset)
            make.bottom.equalTo(artistLabel.snp.top)
        }
        
        artistLabel.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview().inset(standardOffset)
        }
    }
    
    func configure(with viewModel: AlbumPresentingProtocol) {
        titleLabel.text = viewModel.title
        artistLabel.text = viewModel.artist
        
        if let url = viewModel.imageUrl {
            imageView.af_setImage(withURL: url, placeholderImage: R.image.placeholder())
        } else {
            imageView.image = R.image.placeholder()
        }
    }
    
}
