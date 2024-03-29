//
//  MovieCollectionCell.swift
//  KueskiChallenge
//
//  Created by Alexander Coto on 8/3/24.
//

import Foundation
import UIKit

protocol MovieCollectionCellDelegate {
    func didTapFavoriteOnCollection(_ cell:UICollectionViewCell)
}

class MovieCollectionCell : UICollectionViewCell {
    static var CELL_IDENTIFIER = "movie_collection_cell"
    static var NIB_NAME = "MovieCollectionCell"
    
    @IBOutlet weak var titleLabel: UILabel?
    @IBOutlet weak var posterImageView: UIImageView?
    @IBOutlet weak var genresLabel: UILabel?
    @IBOutlet weak var overviewTextView: UITextView?
    @IBOutlet weak var popularityLabel: UILabel?
    @IBOutlet weak var releaseDateLabel: UILabel?
    @IBOutlet weak var languageLabel: UILabel?
    @IBOutlet weak var voteAverageLabel: UILabel?
    @IBOutlet weak var favoriteButton: UIButton?
    
    var delegate: MovieCollectionCellDelegate? = nil
    var observation: NSKeyValueObservation? = nil
    
    func populateCell(withMovie movie: Movie) {
        // So far this is the same as MovieTableCell, normally this is not recommended since replicating code can lead to bugs, however is not common for the grid and table to have the same info, so I'll leave it like this since the tendency is for those layout to drift apart in real projects.
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
        self.delegate?.didTapFavoriteOnCollection(self)
    }
    
    override func removeFromSuperview() {
        super.removeFromSuperview()
        self.observation?.invalidate()
    }
}
