//
//  UIScreen+Extensions.swift
//  CravingForSound
//
//  Created by Rodion on 15/10/2019.
//  Copyright © 2019 LetsSee. All rights reserved.
//

import UIKit

public struct ScreenSize: OptionSet, Hashable {
    
    public let rawValue: Int
    public init(rawValue: Int) {
        self.rawValue = rawValue
    }

    public static let likeSE = ScreenSize(rawValue: 1 << 0)
    public static let like6 = ScreenSize(rawValue: 1 << 1)
    public static let likePlus = ScreenSize(rawValue: 1 << 2)
    public static let likeX = ScreenSize(rawValue: 1 << 3)
    public static let likeXR = ScreenSize(rawValue: 1 << 4)

    public static let xFamily = [likeX, likeXR]

    public func adoptValue<T>(_ valueMap: [ScreenSize: T], default: T) -> T {
        if let (_, value) = valueMap.first(where: { $0.key.contains(self) }) {
            return value
        }
        return `default`
    }
    
}

extension UIScreen {

    public static let size: ScreenSize = {
        switch main.bounds.height {
        case 568:
            return .likeSE
        case 667:
            return .like6
        case 736:
            return .likePlus
        case 812:
            return .likeX
        case 896:
            return .likeXR
        default:
            return .like6
        }
    }()

}
