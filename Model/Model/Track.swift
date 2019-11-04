//
//  Track.swift
//  Model
//
//  Created by Rodion on 04/10/2019.
//  Copyright © 2019 LetsSee. All rights reserved.
//

import Foundation
import RealmSwift

public final class Track: Object {

    @objc public dynamic var title: String = ""
    @objc public dynamic var rank: Int = 0
    @objc public dynamic var duration: Int = 0
    
}
