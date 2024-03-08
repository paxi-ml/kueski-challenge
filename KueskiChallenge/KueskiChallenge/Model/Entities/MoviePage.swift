//
//  MoviePage.swift
//  KueskiChallenge
//
//  Created by Alexander Coto on 7/3/24.
//

import Foundation

class MoviePage : Parseable {
    var totalPages:Int = 0
    var totalObjs:Int = 0
    var currentPage:Int = 0
    var movies:[Movie] = []
    required init?(fromDictionary dict: NSDictionary) {
        self.totalPages = dict.object(forKey: "total_pages") as? Int ?? 0
        self.totalObjs = dict.object(forKey: "total_results") as? Int ?? 0
        self.currentPage = dict.object(forKey: "page") as? Int ?? 0
        
        if let rawObjs = dict.object(forKey: "results") as? NSArray {
            var outputArray:[Movie] = []
            for dict in rawObjs {
                if let castedDict = dict as? NSDictionary,
                   let movie : Movie = castedDict.parseToObj(),
                   movie.id != INVALID_MOVIE_ID {
                    outputArray.append(movie)
                }
            }
            self.movies = outputArray
        }
    }
}
