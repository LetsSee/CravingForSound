//
//  Album.swift
//  Model
//
//  Created by Rodion on 04/10/2019.
//  Copyright © 2019 LetsSee. All rights reserved.
//

import Foundation
import RealmSwift

public final class Album: Object {
    
    @objc public dynamic var mbid = ""
    @objc public dynamic var title = ""
    @objc public dynamic var artistName = ""
    @objc public dynamic var isDeleted = false
    
    @objc public dynamic var imageUrl: String?
    
    public dynamic var tracks = List<Track>()
    
    public override static func primaryKey() -> String? {
      return "mbid"
    }
    
}
