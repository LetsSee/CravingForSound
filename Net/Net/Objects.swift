//
//  Objects.swift
//  NetworkService
//
//  Created by Rodion on 10/10/2019.
//  Copyright © 2019 LetsSee. All rights reserved.
//

import Foundation

public enum ImageSize: String, Decodable {
    case extralarge, mega, large, medium, small
}

public struct Image: Decodable {
    
    public let url: String
    public let size: ImageSize
    
    enum CodingKeys: String, CodingKey {
        case url = "#text"
        case size
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        url = try container.decode(String.self, forKey: .url)
        let sizeString = try container.decode(String.self, forKey: .size)
        size = ImageSize(rawValue: sizeString) ?? .large
    }
    
}

public struct Track: Decodable {
    
    public let rank: Int
    public let name: String
    public let duration: Int?
    
    enum CodingKeys: String, CodingKey {
        case attr = "@attr"
        case name, duration, rank
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        let durationString = try container.decode(String.self, forKey: .duration)
        duration = Int(durationString)
        let rankContainer = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .attr)
        let rankString = try rankContainer.decode(String.self, forKey: .rank)
        rank = Int(rankString) ?? 0
    }
    
}

public struct Artist: Decodable {
    
    public let mbid: String
    public let name: String
    public let images: [Image]?
    
    let url: String
    
    enum CodingKeys: String, CodingKey {
        case images = "image"
        case name, mbid, url
    }
    
}

public struct Album: Decodable {
    
    public let mbid: String?
    public let name: String
    public let artist: Artist
    public let images: [Image]
    let url: String
    
    enum CodingKeys: String, CodingKey {
        case images = "image"
        case name, mbid, url, artist
    }
    
}

public struct AlbumDetails: Decodable {
    
    public let mbid: String?
    public let name: String
    public let artist: String
    public let images: [Image]
    let url: String
    
    public let tracks: [Track]
    
    enum CodingKeys: String, CodingKey {
        case images = "image", tracks, track
        case name, mbid, url, artist
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        mbid = try container.decode(String.self, forKey: .mbid)
        name = try container.decode(String.self, forKey: .name)
        artist = try container.decode(String.self, forKey: .artist)
        images = try container.decode([Image].self, forKey: .images)
        url = try container.decode(String.self, forKey: .url)
        
        let tracksContainer = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .tracks)
        tracks = try tracksContainer.decode([Track].self, forKey: .track)
    }
    
}

struct ArtistsResponse: Decodable {
    
    let artists: [Artist]
    
    enum CodingKeys: String, CodingKey {
        case results
        case artistmatches
        case artist
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let results = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .results)
        let artistmatches = try results.nestedContainer(keyedBy: CodingKeys.self, forKey: .artistmatches)
        artists = try artistmatches.decode([Artist].self, forKey: .artist)
    }
    
}

struct AlbumsResponse: Decodable {
    
    let albums: [Album]
    
    enum CodingKeys: String, CodingKey {
        case topalbums
        case album
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let topalbums = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .topalbums)
        albums = try topalbums.decode([Album].self, forKey: .album)
    }
    
}

struct AlbumResponse: Decodable {
    
    let album: AlbumDetails
    
}
