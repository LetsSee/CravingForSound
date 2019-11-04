//
//  PresentationControllerDelegateProxy+Rx.swift
//  CravingForSound
//
//  Created by Rodion on 22/10/2019.
//  Copyright © 2019 LetsSee. All rights reserved.
//

import SafariServices
import RxSwift
import RxCocoa

extension UIPresentationController: HasDelegate {
    public typealias Delegate = UIAdaptivePresentationControllerDelegate
}

class PresentationControllerDelegateProxy: DelegateProxy<UIPresentationController, UIAdaptivePresentationControllerDelegate>,
    DelegateProxyType, UIAdaptivePresentationControllerDelegate {
    
    static func registerKnownImplementations() {
        self.register { PresentationControllerDelegateProxy(parentObject: $0,
                                                            delegateProxy: PresentationControllerDelegateProxy.self) }
    }
}

extension Reactive where Base: UIPresentationController {
    
    var delegate: PresentationControllerDelegateProxy {
        return PresentationControllerDelegateProxy.proxy(for: base)
    }
    
    /// Reactive wrapper for delegate method `presentationControllerDidDismiss`
    public var presentationControllerDidDismiss: Observable<Void>? {
        if #available(iOS 13.0, *) {
            return delegate
                .methodInvoked(#selector(UIAdaptivePresentationControllerDelegate.presentationControllerDidDismiss(_:)))
                .map { _ in return }
        } else {
            return nil
        }
    }
    
}
