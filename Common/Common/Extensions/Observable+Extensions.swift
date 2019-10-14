//
//  Observable+Extensions.swift
//  Common
//
//  Created by Rodion on 10/10/2019.
//  Copyright © 2019 LetsSee. All rights reserved.
//

import Foundation
import RxSwift

public extension ObservableType {
    
    func subscribeIf(_ condition: Bool, onNext: ((Element) -> Void)?) -> Disposable? {
        if condition {
            return subscribe(onNext: onNext)
        }
        return nil
    }
    
    func withPrevious() -> Observable<(previous: Element?, current: Element)> {
        let tuple: (previous: Element?, current: Element?) = (nil, nil)
        return self
            .scan(tuple) { accumulator, current in
                (previous: accumulator.current, current: current)
            }
            .filter { $0.current != nil }
            .map { ($0.previous, $0.current!) }
    }
    
    func combineLatestWith<O, R>(_ observable: O) -> Observable<(Element, R)> where O: ObservableType, O.Element == R {
        return Observable.combineLatest(self, observable)
    }
    
    func asVoid() -> Observable<Void> {
        return self.map { _ in () }
    }
    
    func takeOne() -> Observable<Element> {
        return self.take(1)
    }
    
    func takeOneAsSingle() -> Single<Element> {
        return take(1).asSingle()
    }
    
}

public extension Observable {
    
    func mergeWith(_ observable: Observable<Element>) -> Observable<Element> {
        return Observable.merge(self, observable)
    }
    
}

public extension Observable where Element == Bool {
    
    func negate() -> Observable<Bool> {
        return self.map { !$0 }
    }
    
}

public extension ObserverType where Element == Void {
    
    func onNext() {
        self.onNext(())
    }
    
}
