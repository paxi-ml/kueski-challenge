//
//  MovieTableCell.swift
//  KueskiChallenge
//
//  Created by Alexander Coto on 8/3/24.
//

import Foundation
import UIKit

class MovieTableCell : UITableViewCell {
    static var CELL_IDENTIFIER = "movie_table_cell"
    static var NIB_NAME = "MovieTableCell"
    static var MARGIN = 10.0
    static var CELL_HEIGHT_WITHOUT_OVERVIEW = 110.0
    static var OVERVIEW_INITIAL_SIZE = 90.0
    
    @IBOutlet var titleLabel: UILabel?
    @IBOutlet var posterImageView: UIImageView?
    @IBOutlet var genresLabel: UILabel?
    @IBOutlet var overviewTextView: UITextView?
    @IBOutlet var popularityLabel: UILabel?
    @IBOutlet var releaseDateLabel: UILabel?
    @IBOutlet var languageLabel: UILabel?
    @IBOutlet var voteAverageLabel: UILabel?
    @IBOutlet var statusIcon: UIImageView?
    
    func populateCell(withMovie movie: Movie) {
        self.titleLabel?.text = movie.title
        self.posterImageView?.image = movie.posterImage
        self.statusIcon?.isHidden = !movie.isFavorite
        self.overviewTextView?.text = movie.overview
        self.popularityLabel?.text = "\(movie.popularity)"
        self.languageLabel?.text = movie.originalLanguage
        self.releaseDateLabel?.text = movie.releaseDateString
        self.voteAverageLabel?.text = "\(movie.voteAverage)"
        self.genresLabel?.text = ""
        if let genres = movie.genreIds {
            for genre in genres {
                self.genresLabel?.text?.append("\(genre),")
            }
        }
    }
}
