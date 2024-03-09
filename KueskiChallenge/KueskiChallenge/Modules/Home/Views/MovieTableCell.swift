//
//  MovieTableCell.swift
//  KueskiChallenge
//
//  Created by Alexander Coto on 8/3/24.
//

import Foundation
import UIKit

protocol MovieTableCellDelegate {
    func didTapFavoriteOnTable(_ cell:UITableViewCell)
}

class MovieTableCell : UITableViewCell {
    static var CELL_IDENTIFIER = "movie_table_cell"
    static var NIB_NAME = "MovieTableCell"
    static var MARGIN = 10.0
    static var CELL_HEIGHT_WITHOUT_OVERVIEW = 110.0
    static var OVERVIEW_INITIAL_SIZE = 90.0
    
    @IBOutlet weak var titleLabel: UILabel?
    @IBOutlet weak var posterImageView: UIImageView?
    @IBOutlet weak var genresLabel: UILabel?
    @IBOutlet weak var overviewTextView: UITextView?
    @IBOutlet weak var popularityLabel: UILabel?
    @IBOutlet weak var releaseDateLabel: UILabel?
    @IBOutlet weak var languageLabel: UILabel?
    @IBOutlet weak var voteAverageLabel: UILabel?
    @IBOutlet weak var favoriteButton: UIButton?
    
    var delegate: MovieTableCellDelegate? = nil
    var observation: NSKeyValueObservation? = nil
    
    func populateCell(withMovie movie: Movie) {
        self.titleLabel?.text = movie.title
        self.posterImageView?.image = movie.posterImage
        self.favoriteButton?.isSelected = movie.isFavorite
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
    
    @IBAction func tappedFavorite() {
        self.delegate?.didTapFavoriteOnTable(self)
    }
    
    override func removeFromSuperview() {
        super.removeFromSuperview()
        self.observation?.invalidate()
    }
}
