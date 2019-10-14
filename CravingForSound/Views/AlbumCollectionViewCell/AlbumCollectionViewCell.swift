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

final class AlbumCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var artistLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setup(with viewModel: AlbumCollectionViewPresentingProtocol) {
        titleLabel.text = viewModel.title
        artistLabel.text = viewModel.artist
        
        if let url = viewModel.imageUrl {
            imageView.af_setImage(withURL: url, placeholderImage: R.image.placeholder())
        } else {
            imageView.image = R.image.placeholder()
        }
    }
    
}
