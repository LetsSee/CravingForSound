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
    
    func getAlbums() throws -> Observable<[Album]>
    func getAlbum(by mbid: String) throws -> Observable<Album>?
    func save(album: Album) throws
    func update(album: Album, with updater: (Album) -> Void) throws
    func set(album: Album, isDeleted: Bool) throws
    
}

public final class DataProvider: DataProvidingProtocol {
    
    public init() { }
    
    public func getAlbums() throws -> Observable<[Album]> {
        let realm = try Realm()
        let albums = realm.objects(Album.self).filter("isDeleted = false")
        return Observable.array(from: albums)
    }
    
    public func getAlbum(by mbid: String) throws -> Observable<Album>? {
        let realm = try Realm()
        guard let object = realm.object(ofType: Album.self, forPrimaryKey: mbid) else {
            return nil
        }
        return Observable.from(object: object)
    }
    
}

public extension DataProvider {
    
    func save(album: Album) throws {
        let realm = try Realm()
        
        try realm.write {
            realm.add(album)
        }
    }
    
    func update(album: Album, with updater: (Album) -> Void) throws {
        let realm = try Realm()
        
        try realm.write {
            updater(album)
        }
    }
    
    func deleteAlbum(by mbid: String) throws {
        let realm = try Realm()
        
        guard let object = realm.object(ofType: Album.self, forPrimaryKey: mbid) else {
            return
        }
        
        try realm.write {
            realm.delete(object)
        }

    }
    
    func set(album: Album, isDeleted: Bool) throws {
        let realm = try Realm()
        
        try realm.write {
            album.isDeleted = isDeleted
        }
    }
    
}
