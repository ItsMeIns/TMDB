//
//  DataManager.swift
//  TMDB Mini
//
//  Created by macbook on 14.02.2023.
//

import RealmSwift

final class DataManager {
    static let shared = DataManager()
    private let realm = try? Realm()
    private init() {}
    
    func saveMedia(movie: MovieAndSerials?, isMovie: Bool) {
        let favoritesRealm = FavoritesRealm()
        guard let movie = movie else { return }
        
        if let title = movie.title, !title.isEmpty {
            favoritesRealm.title = title
        } else if let title = movie.name {
            favoritesRealm.title = title
        }
        
        if let overview = movie.overview {
            favoritesRealm.overview = overview
        }
        
        if let rating = movie.vote_average {
            favoritesRealm.rating = rating
        }
        
        if let posterPath = movie.posterPath {
            favoritesRealm.posterPath = posterPath
        }
        
        if let trailer = movie.id {
            favoritesRealm.trailer = trailer
        }
        
        if let mediaType = movie.media_type {
            favoritesRealm.mediaType = mediaType
        }
        
        if let releaseDate = movie.release_date {
            favoritesRealm.releaseDate = releaseDate
        } else if let releaseDate = movie.first_air_date {
            favoritesRealm.releaseDate = releaseDate
        }
        
        if let backdropPath = movie.backdrop_path {
            favoritesRealm.backdropPath = backdropPath
        }
        
        if let id = movie.id {
            favoritesRealm.id = id
        }
        
        if isMovie == true {
            favoritesRealm.isMovie = true
        } else {
            favoritesRealm.isMovie = false
        }
        
        try? realm?.write {
            realm?.add(favoritesRealm, update: .all)
        }

    }
    
    func deleteMedia(movie: FavoritesRealm) {
        if let movie = realm?.object(ofType: FavoritesRealm.self, forPrimaryKey: movie.id) {
            try? realm?.write {
                realm?.delete(movie)
            }
        }
    }
    
    
    func getMedia() -> [FavoritesRealm] {
        realm?.objects(FavoritesRealm.self).map { $0 } ?? []
    }
    
    func isMovieInRealm(movie: MovieAndSerials?) -> Bool {
        if ((realm?.object(ofType: FavoritesRealm.self, forPrimaryKey: movie?.id)) != nil) {
            return true
        } else {
           return false
        }
    }
    
    func getFilm(media: MovieAndSerials) -> FavoritesRealm {
        let movie = (realm?.object(ofType: FavoritesRealm.self, forPrimaryKey: media.id))!
        return movie
    }
    
}
