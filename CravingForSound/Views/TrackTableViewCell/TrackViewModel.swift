//
//  TrackViewModel.swift
//  CravingForSound
//
//  Created by Rodion on 13/10/2019.
//  Copyright © 2019 LetsSee. All rights reserved.
//

import Net

protocol TrackViewPresentingProtocol {
    
    var name: String { get }
    var number: String { get }
    
}

struct TrackViewModel: TrackViewPresentingProtocol {
    
    let name: String
    let number: String
    
    init(with track: Net.Track) {
        self.name = track.name
        self.number = "\(track.rank)"
    }
    
}
