//
//  NetworkService.swift
//  NetworkService
//
//  Created by Rodion on 09/10/2019.
//  Copyright © 2019 LetsSee. All rights reserved.
//

import Foundation
import RxSwift
import RxAlamofire
import Common

enum NetworkServiceError: Error, LocalizedError {
    
    case unreachable, badBaseUrl, badMethodUrl, badFormat, networkError
    
    public var errorDescription: String? {
        switch self {
        case .unreachable:
            return R.string.common.checkConnection()
        default:
            return R.string.common.somethingGoesWrong()
        }
    }
    
}

public protocol NetworkServiceProtocol {
    
    func artistSearch(by name: String) -> Single<[Artist]>
    func topAlbums(by mbid: String) -> Single<[Album]>
    func albumInfo(by mbid: String?, name: String) -> Single<AlbumDetails>
    
}

public final class NetworkService: NetworkServiceProtocol {
    
    private let baseUrl = "https://ws.audioscrobbler.com"
    private let key = "2517064002e4339a110838c56b0d7d3d"
    
    public init() { }
    
    public func artistSearch(by name: String) -> Single<[Artist]> {
        let string = "/2.0/?method=artist.search&artist=\(name)&api_key=\(key)&format=json"
        
        NetworkMonitor.shared.requestStarted()
        
        guard NetworkMonitor.shared.isNetworkReachable else {
            return .error(NetworkServiceError.unreachable)
        }
        
        guard let baseUrl = URL(string: baseUrl) else {
            return .error(NetworkServiceError.badBaseUrl)
        }
        
        guard let url = URL(string: string, relativeTo: baseUrl) else {
            return .error(NetworkServiceError.badMethodUrl)
        }
        
        if debug { print("loading: \(url.absoluteString)") }
        
        return Single<[Artist]>.create { observer in
            data(.get, url)
                .observeOn(MainScheduler.instance)
                .subscribe(onNext: { data in
                    NetworkMonitor.shared.requestFinished()
                    do {
                        let decoder = JSONDecoder()
                        let result = try decoder.decode(ArtistsResponse.self, from: data)
                        observer(.success(result.artists))
                    } catch {
                        observer(.error(NetworkServiceError.badFormat))
                    }
                }, onError: { error in
                    observer(.error(NetworkServiceError.networkError))
                })
        }
    }
    
    public func topAlbums(by mbid: String) -> Single<[Album]> {
        let string = "/2.0/?method=artist.gettopalbums&mbid=\(mbid)&api_key=\(key)&format=json"
        
        NetworkMonitor.shared.requestStarted()
        
        guard NetworkMonitor.shared.isNetworkReachable else {
            return .error(NetworkServiceError.unreachable)
        }
        
        guard let baseUrl = URL(string: baseUrl) else {
            return .error(NetworkServiceError.badBaseUrl)
        }
        
        guard let url = URL(string: string, relativeTo: baseUrl) else {
            return .error(NetworkServiceError.badMethodUrl)
        }
        
        if debug { print("loading: \(url.absoluteString)") }
        
        return Single<[Album]>.create { observer in
            data(.get, url)
                .observeOn(MainScheduler.instance)
                .subscribe(onNext: { data in
                    NetworkMonitor.shared.requestFinished()
                    do {
                        let decoder = JSONDecoder()
                        let result = try decoder.decode(AlbumsResponse.self, from: data)
                        observer(.success(result.albums.filter { $0.mbid != nil }))
                    } catch {
                        observer(.error(NetworkServiceError.badFormat))
                    }
                }, onError: { error in
                    observer(.error(NetworkServiceError.networkError))
                })
        }
    }
    
    public func albumInfo(by mbid: String?, name: String) -> Single<AlbumDetails> {
        let name = name.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let mbid = mbid ?? ""
        let string = "/2.0/?method=album.getinfo&mbid=\(mbid)&artist=\(name)&api_key=\(key)&format=json"
        
        NetworkMonitor.shared.requestStarted()
        
        guard NetworkMonitor.shared.isNetworkReachable else {
            return .error(NetworkServiceError.unreachable)
        }
        
        guard let baseUrl = URL(string: baseUrl) else {
            return .error(NetworkServiceError.badBaseUrl)
        }
        
        guard let url = URL(string: string, relativeTo: baseUrl) else {
            return .error(NetworkServiceError.badMethodUrl)
        }
        
        if debug { print("loading: \(url.absoluteString)") }
        
        return Single<AlbumDetails>.create { observer in
            data(.get, url)
                .observeOn(MainScheduler.instance)
                .subscribe(onNext: { data in
                    NetworkMonitor.shared.requestFinished()
                    do {
                        let decoder = JSONDecoder()
                        let result = try decoder.decode(AlbumResponse.self, from: data)
                        observer(.success(result.album))
                    } catch {
                        observer(.error(NetworkServiceError.badFormat))
                    }
                }, onError: { error in
                    observer(.error(NetworkServiceError.networkError))
                })
        }
    }
    
}
