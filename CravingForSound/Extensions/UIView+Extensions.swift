//
//  UIView+Extensions.swift
//  CravingForSound
//
//  Created by Rodion on 06.12.2019.
//  Copyright © 2019 LetsSee. All rights reserved.
//

import UIKit

public extension UIView {

    func addSubviews(_ views: UIView...) {
        views.forEach {
            addSubview($0)
        }
    }

    func addSubviews(_ views: [UIView]) {
        views.forEach {
            addSubview($0)
        }
    }

}
