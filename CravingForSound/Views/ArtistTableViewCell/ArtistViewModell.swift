//
//  ArtistViewModel.swift
//  CravingForSound
//
//  Created by Rodion on 10/10/2019.
//  Copyright © 2019 LetsSee. All rights reserved.
//

import Foundation
import Net

protocol ArtistViewPresentingProtocol {
    
    var mdib: String { get }
    var name: String { get }
    var imageUrl: URL? { get }
    
}

struct ArtistViewModel: ArtistViewPresentingProtocol {
    
    let mdib: String
    let name: String
    let imageUrl: URL?
    
    init(with artist: Artist) {
        self.mdib = artist.mbid
        self.name = artist.name
        self.imageUrl = artist.images?.first { $0.size == .large }.flatMap { URL(string: $0.url) }
    }
    
}
