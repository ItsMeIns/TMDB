//
//  NetworkManager.swift
//  TMDB Mini
//
//  Created by macbook on 25.02.2023.
//

import Foundation
import Alamofire

import Alamofire

class NetworkManager {
    
    static let shared = NetworkManager()
    private init() {}
    
    private let baseUrl = "https://api.themoviedb.org/3"
    private let apiKey = "2368b11859ef2d8f5266667d3a7eefed"
    
    private var language: String {
        if Locale.current.language.languageCode?.identifier == "uk" {
            return "uk-UA"
        } else {
            return "en-US"
        }
    }
    
    func getTrendingMedia(mediaType: String, page: Int, language: String, completion: @escaping (Result<MovieAndSerialsModel, Error>) -> Void) {
        let url = "\(baseUrl)/trending/\(mediaType)/day"
        let parameters: [String: Any] = [
            "api_key": apiKey,
            "language": language,
            "page": page
        ]
        AF.request(url, parameters: parameters)
            .validate()
            .responseDecodable(of: MovieAndSerialsModel.self) { response in
                switch response.result {
                case .success(let model):
                    completion(.success(model))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    
    func searchMedia(mediaType: String, query: String, language: String, completion: @escaping (Result<MovieAndSerialsModel, Error>) -> Void) {
        let url = "\(baseUrl)/search/\(mediaType)"
        let parameters: [String: Any] = [
            "api_key": apiKey,
            "language": language,
            "query": query,
            "page": 1,
            "include_adult": false
        ]
        AF.request(url, parameters: parameters)
            .validate()
            .responseDecodable(of: MovieAndSerialsModel.self) { response in
                switch response.result {
                case .success(let model):
                    completion(.success(model))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    
    
    func getTrailerMovie(movieId: Int, completion: @escaping([TrailerResult]) -> Void) {
        let url = "https://api.themoviedb.org/3/movie/\(movieId)/videos?api_key=2368b11859ef2d8f5266667d3a7eefed&language=en-US"
        AF.request(url).responseDecodable(of: TrailerModel.self) { response in
            let data = response.value?.results ?? []
            completion(data)
        }
    }
    
    func getTrailerTv(movieId: Int, completion: @escaping([TrailerResult]) -> Void) {
        let url = "https://api.themoviedb.org/3/tv/\(movieId)/videos?api_key=2368b11859ef2d8f5266667d3a7eefed&language=en-US"
        AF.request(url).responseDecodable(of: TrailerModel.self) { response in
            let data = response.value?.results ?? []
            completion(data)
        }
    }
}
