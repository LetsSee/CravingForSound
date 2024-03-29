//
//  CommonNavigation.swift
//  Craving for Sound
//
//  Created by Rodion on 02/09/2019.
//  Copyright © 2019 LetsSee. All rights reserved.
//

import UIKit
import RxSwift

protocol CommonNavigation: class {
    
    var disposeBag: DisposeBag { get }
    func goBack(in navController: UINavigationController, animated: Bool, toRoot: Bool)
    func dismissModalController(in window: UIWindow, animated: Bool)
}

extension CommonNavigation {
    
    func goBack(in navController: UINavigationController, animated: Bool, toRoot: Bool = false) {
        if toRoot {
            navController.popToRootViewController(animated: animated)
        } else {
            navController.popViewController(animated: animated)
        }
    }
    
    func dismissModalController(in window: UIWindow, animated: Bool) {
        window.rootViewController?.dismiss(animated: animated, completion: nil)
    }
    
}
