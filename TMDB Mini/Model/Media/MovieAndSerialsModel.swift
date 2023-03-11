//
//  ViewController.swift
//  TMDB Mini
//
//  Created by macbook on 13.01.2023.
//


import Foundation
struct MovieAndSerialsModel : Codable {
    let page : Int?
    let results : [MovieAndSerials]?
    let total_pages : Int?
    let total_results : Int?
    
    enum CodingKeys: String, CodingKey {
        case page = "page"
        case results = "results"
        case total_pages = "total_pages"
        case total_results = "total_results"
    }
}

struct MovieAndSerials : Codable, Hashable {
    let adult : Bool?
    let backdrop_path : String?
    let id : Int?
    let title : String?
    let name : String?
    let original_language : String?
    let original_title : String?
    let original_name : String?
    let overview : String?
    let posterPath : String?
    var media_type : String?
    let genre_ids : [Int]?
    let popularity : Double?
    let first_air_date : String?
    let release_date : String?
    let video : Bool?
    let vote_average : Double?
    let vote_count : Int?
    let origin_country : [String]?
    
    enum CodingKeys: String, CodingKey {
        case adult = "adult"
        case backdrop_path = "backdrop_path"
        case id = "id"
        case title = "title"
        case name = "name"
        case original_language = "original_language"
        case original_title = "original_title"
        case original_name = "original_name"
        case overview = "overview"
        case posterPath = "poster_path"
        case media_type = "media_type"
        case genre_ids = "genre_ids"
        case popularity = "popularity"
        case release_date = "release_date"
        case first_air_date = "first_air_date"
        case video = "video"
        case vote_average = "vote_average"
        case vote_count = "vote_count"
        case origin_country = "origin_country"
    }
}














