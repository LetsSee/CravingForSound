//
//  AlbumCollectionViewModel.swift
//  CravingForSound
//
//  Created by Rodion on 07/10/2019.
//  Copyright © 2019 LetsSee. All rights reserved.
//

import Foundation
import Model
import Net

protocol AlbumCollectionViewPresentingProtocol {
    
    var mbid: String? { get }
    var title: String { get }
    var artist: String { get }
    var imageUrl: URL? { get }
    
}

struct AlbumCollectionViewModel: AlbumCollectionViewPresentingProtocol {
    
    let mbid: String?
    let title: String
    let artist: String
    let imageUrl: URL?
    
    init(with album: Model.Album) {
        self.mbid = album.mbid
        self.title = album.title
        self.artist = album.artistName
        self.imageUrl = URL(string: album.imageUrl)
    }
    
    init(net album: Net.Album) {
        self.mbid = album.mbid
        self.title = album.name
        self.artist = album.artist.name
        self.imageUrl = album.images.first { $0.size == .large }.flatMap { URL(string: $0.url) }
    }
    
}
