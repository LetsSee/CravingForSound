//
//  ModelFactories.swift
//  CravingForSound
//
//  Created by Rodion on 24/10/2019.
//  Copyright © 2019 LetsSee. All rights reserved.
//

import Net
import Model
import Realm

extension Model.Album {
 
    static func createAlbum(with albumInfo: AlbumPresentingProtocol) -> Model.Album? {
        let album = Model.Album()
        album.mbid = albumInfo.mbid
        album.title = albumInfo.title
        album.artistName = albumInfo.artist
        album.imageUrl = albumInfo.imageUrl?.absoluteString
        album.tracks.append(objectsIn: albumInfo.tracks.compactMap { Model.Track.createTrack(with: $0) })
        
        return album
    }
    
    func update(with albumInfo: AlbumPresentingProtocol) {
        self.title = albumInfo.title
        self.artistName = albumInfo.artist
        self.imageUrl = albumInfo.imageUrl?.absoluteString
        self.tracks.removeAll()
        self.tracks.append(objectsIn: albumInfo.tracks.compactMap { Model.Track.createTrack(with: $0) })
    }
    
}

extension Model.Track {
    
    static func createTrack(with trackInfo: TrackPresentingProtocol) -> Model.Track? {
        let track = Model.Track()
        track.title = trackInfo.name
        track.rank = Int(trackInfo.number) ?? 0
        
        return track
    }
    
}
