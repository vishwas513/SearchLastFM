//
//  MainSearchViewModel.swift
//  LastFmSearch
//
//  Created by Vishwas Mukund on 9/14/19.
//  Copyright © 2019 Vishwas Mukund. All rights reserved.
//

import UIKit

final class MainSearchViewModel {
    
    var albumList = [Album]()
    var artistList = [Artist]()
    var trackList = [Track]()
    var searchSelectedSegmentIndex = 0
    var networkManager: NetworkManager?
    var albumPage = 1
    var artistPage = 1
    var trackPage = 1
    var pageLimit = 20
    var apiKey: String = {
    guard let apiKey = Bundle.main.infoDictionary?["api_key"] as? String else {
    fatalError("api_key not found in your info.plist")
    }
        return apiKey
    }()
    
    func search(searchTerm: String, completion: @escaping (NetworkError?) -> Void) {
        guard let searchTerm = searchTerm.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else { return }
        searchAlbums(searchTerm: searchTerm, apiKey: apiKey, updatePage: false, completion: {
            error in
            completion(error)
        })
        
        searchArtists(searchTerm: searchTerm, apiKey: apiKey, updatePage: false, completion: {
            error in
            completion(error)
        })
        
        searchTracks(searchTerm: searchTerm, apiKey: apiKey,updatePage: false, completion: {
            error in
            completion(error)
        })
    }
    
    func searchAlbums(searchTerm: String, apiKey: String, updatePage: Bool, completion: @escaping (NetworkError?) -> Void) {
        let path = "?method=album.search&album=\(searchTerm)&limit=\(pageLimit)&page=\(albumPage)&api_key=\(apiKey)&format=json"
        let request = APIRequest.get(withPath: path)
        
        _ =  networkManager?.get(request, completion: { result in
            switch result {
            case let .success(response):
                do {
                    let jsonObject: Any = try JSONSerialization.jsonObject(with: response.body, options: [])
                    guard let responseDictionary = jsonObject as? NSDictionary, let results = responseDictionary["results"] as? NSDictionary, let albumMatches = results["albummatches"] as? NSDictionary, let albumArray = albumMatches["album"] as? NSArray else {
                        completion(.decodingDataFailed)
                        return
                    }
                    
                    if updatePage {
                        self.albumList += albumArray.compactMap {
                            (item) -> Album in
                            guard let albumDictionary = item as? NSDictionary, let imageUrlArray = albumDictionary["image"] as? NSArray, let imageUrl = imageUrlArray[0] as? NSDictionary, let highQualityImageUrl = imageUrlArray.lastObject as? NSDictionary else { return Album() }
                            let album = Album()
                            album.name = albumDictionary["name"] as? String
                            album.artist = albumDictionary["artist"] as? String
                            album.imageUrl = imageUrl["#text"] as? String
                            album.highQualityImageUrl = highQualityImageUrl["#text"] as? String
                            album.link = albumDictionary["url"] as? String
                            return album
                        }
                    } else {
                        self.albumList = albumArray.compactMap {
                            (item) -> Album in
                            guard let albumDictionary = item as? NSDictionary, let imageUrlArray = albumDictionary["image"] as? NSArray, let imageUrl = imageUrlArray[0] as? NSDictionary, let highQualityImageUrl = imageUrlArray.lastObject as? NSDictionary else { return Album() }
                            let album = Album()
                            album.name = albumDictionary["name"] as? String
                            album.artist = albumDictionary["artist"] as? String
                            album.imageUrl = imageUrl["#text"] as? String
                            album.highQualityImageUrl = highQualityImageUrl["#text"] as? String
                            album.link = albumDictionary["url"] as? String
                            return album
                        }
                    }
                    completion(nil)
                } catch {
                    completion(nil)
                }
            case let .failure(error):
                completion(error)
            }
        })
    }
    
    func searchArtists(searchTerm: String, apiKey: String, updatePage: Bool, completion: @escaping (NetworkError?) -> Void) {
        let path = "?method=artist.search&artist=\(searchTerm)&limit=\(pageLimit)&page=\(artistPage)&api_key=\(apiKey)&format=json"
        let request = APIRequest.get(withPath: path)
        
        _ =  networkManager?.get(request, completion: { result in
            
            switch result {
            case let .success(response):
                do {
                    let jsonObject : Any = try JSONSerialization.jsonObject(with: response.body, options: [])
                    guard let responseDictionary = jsonObject as? NSDictionary, let results = responseDictionary["results"] as? NSDictionary, let artistMatches = results["artistmatches"] as? NSDictionary, let albumArray = artistMatches["artist"] as? NSArray else {
                        completion(.decodingDataFailed)
                        return
                    }
                    
                    if updatePage {
                        self.artistList += albumArray.compactMap {
                            (item) -> Artist in
                            guard let artistDictionary = item as? NSDictionary, let imageUrlArray = artistDictionary["image"] as? NSArray, let imageUrl = imageUrlArray[0] as? NSDictionary, let highQualityImageUrl = imageUrlArray.lastObject as? NSDictionary else { return Artist() }
                            let artist = Artist()
                            artist.name = artistDictionary["name"] as? String
                            artist.listeners = artistDictionary["listeners"] as? String
                            artist.imageUrl = imageUrl["#text"] as? String
                            artist.mbid = artistDictionary["mbid"] as? String
                            artist.highQualityImageUrl = highQualityImageUrl["#text"] as? String
                            artist.link = artistDictionary["url"] as? String
                            return artist
                        }
                    } else {
                        self.artistList = albumArray.compactMap {
                            (item) -> Artist in
                            guard let artistDictionary = item as? NSDictionary, let imageUrlArray = artistDictionary["image"] as? NSArray, let imageUrl = imageUrlArray[0] as? NSDictionary, let highQualityImageUrl = imageUrlArray.lastObject as? NSDictionary else { return Artist() }
                            let artist = Artist()
                            artist.name = artistDictionary["name"] as? String
                            artist.listeners = artistDictionary["listeners"] as? String
                            artist.imageUrl = imageUrl["#text"] as? String
                            artist.mbid = artistDictionary["mbid"] as? String
                            artist.highQualityImageUrl = highQualityImageUrl["#text"] as? String
                            artist.link = artistDictionary["url"] as? String
                            return artist
                        }
                    }
                    completion(nil)
                } catch {
                    completion(nil)
                }
            case let .failure(error):
                completion(error)
            }
        })
    }
    
    func searchTracks(searchTerm: String, apiKey: String, updatePage: Bool, completion: @escaping (NetworkError?) -> Void) {
        let path = "?method=track.search&track=\(searchTerm)&limit=\(pageLimit)&page=\(trackPage)&api_key=\(apiKey)&format=json"
        let request = APIRequest.get(withPath: path)
        
        _ =  networkManager?.get(request, completion: { result in
            
            switch result {
            case let .success(response):
                do {
                    let jsonObject: Any = try JSONSerialization.jsonObject(with: response.body, options: [])
                    guard let responseDictionary = jsonObject as? NSDictionary, let results = responseDictionary["results"] as? NSDictionary, let trackMatches = results["trackmatches"] as? NSDictionary, let trackArray = trackMatches["track"] as? NSArray else {
                        completion(.decodingDataFailed)
                        return
                    }
                    
                    if updatePage {
                        self.trackList += trackArray.compactMap {
                            (item) -> Track in
                            guard let trackDictionary = item as? NSDictionary, let imageUrlArray = trackDictionary["image"] as? NSArray, let imageUrl = imageUrlArray[0] as? NSDictionary, let highQualityImageUrl = imageUrlArray.lastObject as? NSDictionary else { return Track() }
                            let track = Track()
                            track.name = trackDictionary["name"] as? String
                            track.artist = trackDictionary["artist"] as? String
                            track.imageUrl = imageUrl["#text"] as? String
                            track.listeners = trackDictionary["listeners"] as? String
                            track.streamable = trackDictionary["streamable"] as? String
                            track.highQualityImageUrl = highQualityImageUrl["#text"] as? String
                            track.link = trackDictionary["url"] as? String
                            return track
                        }
                    } else {
                        self.trackList = trackArray.compactMap {
                            (item) -> Track in
                            guard let trackDictionary = item as? NSDictionary, let imageUrlArray = trackDictionary["image"] as? NSArray, let imageUrl = imageUrlArray[0] as? NSDictionary, let highQualityImageUrl = imageUrlArray.lastObject as? NSDictionary else { return Track() }
                            let track = Track()
                            track.name = trackDictionary["name"] as? String
                            track.artist = trackDictionary["artist"] as? String
                            track.imageUrl = imageUrl["#text"] as? String
                            track.listeners = trackDictionary["listeners"] as? String
                            track.streamable = trackDictionary["streamable"] as? String
                            track.highQualityImageUrl = highQualityImageUrl["#text"] as? String
                            track.link = trackDictionary["url"] as? String
                            return track
                        }
                    }
                    completion(nil)
                } catch {
                    completion(nil)
                }
            case let .failure(error):
                completion(error)
            }
        })
    }
    
    func getDescriptionForEntity(mode: SearchResultType, entityName: String, artistName: String? = nil, completion: @escaping (String?) -> Void) {
        var path = ""
        guard let entityName = entityName.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else { return }
        switch mode {
        case .artist:
            path = "?method=artist.getinfo&artist=\(entityName)&api_key=\(apiKey)&format=json"
        case .track:
            guard let artist = artistName?.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else { return }
            path = "?method=track.getInfo&api_key=\(apiKey)&artist=\(artist)&track=\(entityName)&format=json"
        default:
            guard let artist = artistName?.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else { return }
            path = "?method=album.getinfo&api_key=\(apiKey)&artist=\(artist)&album=\(entityName)&format=json"
        }
        
        let request = APIRequest.get(withPath: path)
        
         _ =  networkManager?.get(request, completion: { result in
            switch(result) {
            case let .success(response) :
                do {
                    let jsonObject: Any = try JSONSerialization.jsonObject(with: response.body, options: [])
                    
                    switch mode {
                    case .artist:
                        guard let responseDictionary = jsonObject as? NSDictionary, let artist = responseDictionary["artist"] as? NSDictionary, let bio = artist["bio"] as? NSDictionary, let content = bio["content"] as? String else {
                            completion("")
                            return
                        }
                        completion(content)
                    case .track:
                        guard let responseDictionary = jsonObject as? NSDictionary, let track = responseDictionary["track"] as? NSDictionary, let wiki = track["wiki"] as? NSDictionary, let content = wiki["content"] as? String else {
                            completion("")
                            return
                        }
                        completion(content)
                    default:
                        guard let responseDictionary = jsonObject as? NSDictionary, let album = responseDictionary["album"] as? NSDictionary, let wiki = album["wiki"] as? NSDictionary, let content = wiki["content"] as? String else {
                            completion("")
                            return
                        }
                        completion(content)
                    }
                } catch {
                    completion(nil)
                }
                
            default:
                completion(nil)
            }
        })
    }
    
    func getArtistInfo(artistName: String, completion: @escaping (Artist?) -> Void) {
        guard let artistName = artistName.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else { return }
        let path = "?method=artist.getinfo&artist=\(artistName)&api_key=\(apiKey)&format=json"
        let request = APIRequest.get(withPath: path)
        
        _ =  networkManager?.get(request, completion: { result in
            switch(result) {
            case let .success(response) :
                do {
                    let jsonObject: Any = try JSONSerialization.jsonObject(with: response.body, options: [])
                    guard let responseDictionary = jsonObject as? NSDictionary, let artist = responseDictionary["artist"] as? NSDictionary, let imageUrlArray = artist["image"] as? NSArray, let imageUrl = imageUrlArray[0] as? NSDictionary, let highQualityImageUrl = imageUrlArray.lastObject as? NSDictionary, let bio = artist["bio"] as? NSDictionary, let content = bio["content"] as? String, let stats = artist["stats"] as? NSDictionary, let listeners = stats["listeners"] as? String  else {
                        completion(nil)
                        return
                    }
                    let artistObject = Artist()
                    artistObject.name = artist["name"] as? String
                    artistObject.link = artist["url"] as? String
                    artistObject.imageUrl = imageUrl["#text"] as? String
                    artistObject.highQualityImageUrl = highQualityImageUrl["#text"] as? String
                    artistObject.bio = content
                    artistObject.listeners = listeners
                    
                    completion(artistObject)
                    
                } catch {
                    completion(nil)
                }
                
            default:
                completion(nil)
            }
        })
    }
}
