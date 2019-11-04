//
//  TrackViewModel.swift
//  CravingForSound
//
//  Created by Rodion on 13/10/2019.
//  Copyright © 2019 LetsSee. All rights reserved.
//

import Net
import Model

protocol TrackPresentingProtocol {
    
    var name: String { get }
    var number: String { get }
    
}

struct TrackViewModel: TrackPresentingProtocol {
    
    let name: String
    let number: String
    
    init(with track: Net.Track) {
        self.name = track.name
        self.number = "\(track.rank)"
    }
    
    init(with track: Model.Track) {
        self.name = track.title
        self.number = "\(track.rank)"
    }
    
}
