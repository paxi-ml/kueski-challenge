//
//  Movie.swift
//  KueskiChallenge
//
//  Created by Alexander Coto on 7/3/24.
//

import Foundation
import UIKit

let INVALID_MOVIE_ID = -1

class Movie : NSObject, Parseable {
    // We could also use nil but it's better to keep as non-optional to reduce unwrapping, and type can be inferred too.
    var genreIds:NSArray? = nil
    var isAdult = false
    var isFavorite = false
    var id = INVALID_MOVIE_ID
    var originalTitle = ""
    var title = ""
    var voteAverage = 0.0
    var voteCount = 0
    var popularity = 0.0
    var posterPath = ""
    @objc dynamic var posterImage:UIImage? = nil
    var overview = ""
    var originalLanguage = ""
    var releaseDateString: String = "" // We don't do date operations so to avoid the dateformatter overhead, let's keep it string
    
    var favoriteKey : String {
        return "favorited_\(id)"
    }
    
    required init?(fromDictionary dict: NSDictionary) {
        super.init()
        // We are abusing a bit of unwrapping and casting, but the idea is to have clean data on the next layer, so if some id or field is empty we should not use that object, is a more recommended approach than taking care of a lot of optionals or uncasted values on next layer.
        self.genreIds = dict.object(forKey: "genre_ids") as? NSArray
        self.isAdult = dict.object(forKey: "adult") as? Bool ?? false
        self.id = dict.object(forKey: "id") as? Int ?? -1
        self.originalTitle = dict.object(forKey: "original_title") as? String ?? ""
        self.title = dict.object(forKey: "title") as? String ?? ""
        self.voteAverage = dict.object(forKey: "vote_average") as? Double ?? 0.0
        self.popularity = dict.object(forKey: "vote_average") as? Double ?? 0.0
        self.posterPath = dict.object(forKey: "poster_path") as? String ?? ""
        self.overview = dict.object(forKey: "overview") as? String ?? ""
        self.originalLanguage = dict.object(forKey: "original_language") as? String ?? ""
        self.voteCount = dict.object(forKey: "vote_count") as? Int ?? 0
        self.releaseDateString = dict.object(forKey: "release_date") as? String ?? ""
        self.isFavorite = UserDefaults.standard.object(forKey: self.favoriteKey) as? Bool ?? false
    }
    
    func changeFavorite() {
        let defaults = UserDefaults.standard
        if let _ = defaults.object(forKey: self.favoriteKey) as? Bool {
            self.isFavorite = false
            defaults.removeObject(forKey: self.favoriteKey)
        } else {
            self.isFavorite = true
            defaults.setValue(true, forKey: self.favoriteKey)
        }
    }
}
