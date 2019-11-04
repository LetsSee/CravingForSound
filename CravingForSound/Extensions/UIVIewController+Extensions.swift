//
//  UIVIewController+Extensions.swift
//  CravingForSound
//
//  Created by Rodion on 15/10/2019.
//  Copyright © 2019 LetsSee. All rights reserved.
//

import UIKit
import SnapKit

public extension UIViewController {

    func addChildViewController(_ viewController: UIViewController, to view: UIView) {
        addChildViewController(viewController, to: view) { make in
            make.edges.equalToSuperview()
        }
    }

    func addChildViewController(_ viewController: UIViewController, to view: UIView,
                                constraints: (ConstraintMaker) -> Void) {
        addChild(viewController)
        view.addSubview(viewController.view)
        viewController.view.snp.makeConstraints(constraints)
        viewController.didMove(toParent: self)
    }

    func removeFromChildren(_ viewController: UIViewController) {
        viewController.willMove(toParent: nil)
        viewController.view.removeFromSuperview()
        viewController.removeFromParent()
    }

}

extension UIViewController {
    
    func alert(message: String, tryAgainHandler: (() -> Void)? = nil, closeHandler: (() -> Void)? = nil) {
        let errorTitle = R.string.common.somethingGoesWrong()
        let alert = UIAlertController(title: errorTitle, message: message, preferredStyle: .alert)
        alert.view.tintColor = .systemGray
        
        if tryAgainHandler != nil {
            let tryAgainAction = UIAlertAction(title: R.string.common.tryAgain(), style: .default) { _ in tryAgainHandler?() }
            alert.addAction(tryAgainAction)
        }
        let cancelAction = UIAlertAction(title: R.string.common.close(), style: .default) { _ in closeHandler?() }
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true)
    }
    
}
