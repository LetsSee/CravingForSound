//
//  ArtistTableViewCell.swift
//  CravingForSound
//
//  Created by Rodion on 10/10/2019.
//  Copyright © 2019 LetsSee. All rights reserved.
//

import UIKit

final class ArtistTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var avatarImageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        avatarImageView.layer.cornerRadius = avatarImageView.bounds.width/2
        avatarImageView.clipsToBounds = true
    }
    
    func setup(with viewModel: ArtistViewPresentingProtocol) {
        nameLabel?.text = viewModel.name
        
        if let url = viewModel.imageUrl {
            avatarImageView?.af_setImage(withURL: url, placeholderImage: R.image.star())
        } else {
            avatarImageView?.image = R.image.star()
        }
    }
    
}
