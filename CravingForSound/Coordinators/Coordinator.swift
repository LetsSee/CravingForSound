//
//  Coordinator.swift
//  Craving for Sound
//
//  Created by Rodion on 28/08/2019.
//  Copyright © 2019 LetsSee. All rights reserved.
//

import UIKit
import RxSwift
import Common

class Coordinator<Result> {
    
    deinit {
        if debug { print("\(type(of: self)) destroyed") }
    }
    
    // MARK: - Properties
    
    private var childCoordinators: [UUID: Any] = [:]
    private let id = UUID()
    
    let disposeBag = DisposeBag()
    
    // MARK: - Internal methods
    
    func start() -> Single<Result> {
        return .never()
    }
    
    func coordinate<Result>(to coordinator: Coordinator<Result>) -> Single<Result> {
        retain(coordinator)
        
        return coordinator.start()
            .do(onSuccess: { [weak self, unowned coordinator] _ in
                self?.release(coordinator)
            })
    }
    
    // MARK: - Private methods
    
    private func retain<T>(_ coordinator: Coordinator<T>) {
        childCoordinators[coordinator.id] = coordinator
    }
    
    private func release<T>(_ coordinator: Coordinator<T>) {
        childCoordinators[coordinator.id] = nil
    }
    
}
