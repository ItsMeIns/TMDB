//
//  ResultTrailer.swift
//  TMDB Mini
//
//  Created by macbook on 06.02.2023.
//

import Foundation

struct TrailerModel: Codable {
    let id: Int
    let results: [TrailerResult]
}

// MARK: - TrailerResult
struct TrailerResult: Codable {
    let iso639_1: ISO639_1
    let iso3166_1: ISO3166_1
    let name, key: String
    let site: Site
    let size: Int
    let type: String
    let official: Bool
    let publishedAt, id: String
    
    enum CodingKeys: String, CodingKey {
        case iso639_1 = "iso_639_1"
        case iso3166_1 = "iso_3166_1"
        case name = "name"
        case key = "key"
        case site = "site"
        case size = "size"
        case type = "type"
        case official = "official"
        case publishedAt = "published_at"
        case id = "id"
    }
}

enum ISO3166_1: String, Codable {
    case us = "US"
}

enum ISO639_1: String, Codable {
    case en = "en"
}

enum Site: String, Codable {
    case youTube = "YouTube"
}


//enum TypeResult: String, Codable {
//    case behindTheScenes = "Behind the Scenes"
//    case featurettes = "Featurettes"
//    case teasers = "Teasers"
//    case trailers = "Trailers"
//    case clips = "Clips"
// }
