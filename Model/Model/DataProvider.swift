//
//  DataProvider.swift
//  Model
//
//  Created by Rodion on 08/10/2019.
//  Copyright © 2019 LetsSee. All rights reserved.
//

import Foundation
import RealmSwift
import RxRealm
import RxSwift

public protocol DataProvidingProtocol {
    
    func getAlbums() -> Observable<[Album]>
    func createTestAlbum() throws
    
}

public final class DataProvider: DataProvidingProtocol {
    
    let realm = try? Realm()
    
    public init() { }
    
    public func getAlbums() -> Observable<[Album]> {
        guard let realm = realm else {
            return Observable.just([])
        }
        let albums = realm.objects(Album.self)
        return Observable.array(from: albums)
    }
    
}

public extension DataProvider {
    
    func createTestAlbum() throws {
        guard let realm = realm else {
            return
        }
        
        try realm.write {
            let newAlbum = Album()
            newAlbum.title = "Album title"
            newAlbum.artistName = "Artist name"
            newAlbum.imageUrl = "fake url"
            realm.add(newAlbum)
        }
    }
    
}
