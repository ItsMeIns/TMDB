//
//  Favorites.swift
//  TMDB Mini
//
//  Created by macbook on 09.02.2023.
//


import RealmSwift

class FavoritesRealm: Object {
    @Persisted(primaryKey: true) var id: Int?
    @Persisted var title = ""
    @Persisted var overview = ""
    @Persisted var rating = 0.0
    @Persisted var posterPath = ""
    @Persisted var trailer = 0
    @Persisted var mediaType = ""
    @Persisted var releaseDate = ""
    @Persisted var backdropPath = ""
    @Persisted var isMovie: Bool
 }



