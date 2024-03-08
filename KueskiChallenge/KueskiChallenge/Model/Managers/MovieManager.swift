//
//  MovieManager.swift
//  KueskiChallenge
//
//  Created by Alexander Coto on 7/3/24.
//

import Foundation

class MovieManager {
    var pages:[MoviePage] = []
    var currentPage = 0
    var totalPages = 0
    
    func loadData(completion: @escaping () -> Void) {
        MovieService.shared.fetchConfiguration {
            MovieService.shared.fetchMostPopular { moviePage in
                if let page = moviePage,
                   page.currentPage > self.pages.count { // This one can be removed, it's to give us clues if pages repeat
                    self.currentPage = self.currentPage + 1
                    self.totalPages = page.totalPages
                    self.pages.append(page)
                    completion()
                }
            }
        }
    }
}
