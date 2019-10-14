//
//  TrackTableViewCell.swift
//  CravingForSound
//
//  Created by Rodion on 13/10/2019.
//  Copyright © 2019 LetsSee. All rights reserved.
//

import UIKit

final class TrackTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var numberLabel: UILabel!
    @IBOutlet private weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setup(with viewModel: TrackViewPresentingProtocol) {
        nameLabel.text = viewModel.name
        numberLabel.text = viewModel.number
    }
    
}
