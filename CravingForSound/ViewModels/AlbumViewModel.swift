//
//  AlbumViewModel.swift
//  CravingForSound
//
//  Created by Rodion on 07/10/2019.
//  Copyright © 2019 LetsSee. All rights reserved.
//

import Foundation
import Model
import Net

protocol AlbumPresentingProtocol {
    
    var mbid: String { get }
    var title: String { get }
    var artist: String { get }
    var imageUrl: URL? { get }
    var isSaved: Bool { get }
    
    var tracks: [TrackPresentingProtocol] { get }
    
}

struct AlbumViewModel: AlbumPresentingProtocol {
    
    let mbid: String
    let title: String
    let artist: String
    let imageUrl: URL?
    let isSaved: Bool
    let tracks: [TrackPresentingProtocol]
    
    init(with album: Model.Album) {
        self.mbid = album.mbid
        self.title = album.title
        self.artist = album.artistName
        if let urlString = album.imageUrl {
            self.imageUrl =  URL(string: urlString)
        } else {
            self.imageUrl = nil
        }
        self.isSaved = !album.isDeleted
        
        tracks = album.tracks.map { TrackViewModel(with: $0) }
    }
    
    init(with album: Net.Album) {
        self.mbid = album.mbid
        self.title = album.name
        self.artist = album.artist.name
        self.imageUrl = album.images.first { $0.size == .large }.flatMap { URL(string: $0.url) }
        self.isSaved = false
        
        self.tracks = [TrackPresentingProtocol]()
        
    }
    
    init(with albumDetails: Net.AlbumDetails) {
        self.mbid = albumDetails.mbid ?? "0"
        self.title = albumDetails.name
        self.artist = albumDetails.artist
        self.imageUrl = albumDetails.images.first { $0.size == .large }.flatMap { URL(string: $0.url) }
        self.isSaved = false
        
        self.tracks = albumDetails.tracks.map { TrackViewModel(with: $0) }
    }
    
}
