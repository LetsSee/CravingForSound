//
//  NetworkMonitor.swift
//  NetworkService
//
//  Created by Rodion on 10/10/2019.
//  Copyright © 2019 LetsSee. All rights reserved.
//

import Foundation
import Reachability

extension UIApplication {
    
    func setActivityIndicator(visible: Bool) {
        DispatchQueue.main.async {
            self.isNetworkActivityIndicatorVisible = visible
        }
    }
    
}

final class NetworkMonitor {
    
    static let shared = NetworkMonitor()
    private let reachability = Reachability()
    private var count = 0
    
    private init() {
        do {
            try reachability?.startNotifier()
        } catch {
            print(error)
        }
    }
    
    var isNetworkReachable: Bool {
        guard  let connection = reachability?.connection else {
            return true
        }
        return connection != .none
    }
    
    func requestStarted() {
        if count == 0 {
            UIApplication.shared.setActivityIndicator(visible: true)
        }
        count += 1
    }
    
    func requestFinished() {
        count -= 1
        if count == 0 {
            UIApplication.shared.setActivityIndicator(visible: false)
        }
    }
    
}
