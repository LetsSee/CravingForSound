//
//  UIButton+Extensions.swift
//  CravingForSound
//
//  Created by Rodion on 16/10/2019.
//  Copyright © 2019 LetsSee. All rights reserved.
//

import UIKit
import SnapKit

public extension UIButton {
    var title: String? {
        get {
            return titleLabel?.text
        }
        set {
            setTitle(newValue, for: .normal)
        }
    }
    
    var attributedTitle: NSAttributedString? {
        get {
            return titleLabel?.attributedText
        }
        set {
            setAttributedTitle(newValue, for: .normal)
        }
    }
    
    var titleColor: UIColor? {
        get {
            return titleLabel?.textColor
        }
        set {
            setTitleColor(newValue, for: .normal)
        }
    }
    
    var titleFont: UIFont? {
        get {
            return titleLabel?.font
        }
        set {
            titleLabel?.font = newValue
        }
    }
}

public extension UIButton {
    
    func showDefaultSpinner() -> UIActivityIndicatorView {
        let spinner = UIActivityIndicatorView()
        addSubview(spinner)
        spinner.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        titleLabel?.alpha = 0.0
        spinner.startAnimating()
        return spinner
    }
    
    func remove(_ spinner: UIActivityIndicatorView) {
        spinner.stopAnimating()
        spinner.removeFromSuperview()
        titleLabel?.alpha = 1.0
    }
    
}
