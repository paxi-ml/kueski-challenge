//
//  MovieManager.swift
//  KueskiChallenge
//
//  Created by Alexander Coto on 7/3/24.
//

import Foundation

enum MovieMode :String {
    case nowPlaying
    case mostPopular
}

class MovieManager {
    var pages:[MoviePage] = []
    var currentPage = 1
    var totalPages = 0
    var mode:MovieMode = .mostPopular {
        didSet {
            currentPage = 1
            totalPages = 0
            pages = []
        }
    }
    
    //We could store both most recent and now playing to avoid data consumption and time loading, but this will depend on what's more important for us and our users, less memory allocated by the app or less data consumption.
    func loadMovies(completion: @escaping () -> Void) {
        if (self.mode == .mostPopular) {
            MovieService.shared.fetchMostPopular(page: self.currentPage, completion: { moviePage in
                //this means the mode changed while this responded.
                if (self.mode != .mostPopular) {
                    return
                }
                if let page = moviePage,
                   page.currentPage > self.pages.count { // This one can be removed, it's to give us clues if pages repeat
                    self.currentPage = self.currentPage + 1
                    self.totalPages = page.totalPages
                    self.pages.append(page)
                    completion()
                }
            })
        } else {
            MovieService.shared.fetchNowPlaying(page: self.currentPage, completion: { moviePage in
                //this means the mode changed while this responded.
                if (self.mode != .nowPlaying) {
                    return
                }
                if let page = moviePage,
                   page.currentPage > self.pages.count { // This one can be removed, it's to give us clues if pages repeat
                    self.currentPage = self.currentPage + 1
                    self.totalPages = page.totalPages
                    self.pages.append(page)
                    completion()
                }
            })
        }
    }
    
    func loadData(completion: @escaping () -> Void) {
        MovieService.shared.fetchConfiguration {
            self.loadMovies(completion: completion)
        }
    }
}
