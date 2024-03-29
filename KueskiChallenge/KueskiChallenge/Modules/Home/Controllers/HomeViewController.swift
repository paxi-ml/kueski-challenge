//
//  ViewController.swift
//  KueskiChallenge
//
//  Created by Alexander Coto on 7/3/24.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var collectionView:UICollectionView?
    @IBOutlet weak var tableView:UITableView?
    @IBOutlet weak var layoutControl:UISegmentedControl?
    @IBOutlet weak var movieModeControl:UISegmentedControl?
    var movieManager: MovieManager = MovieManager() //In more complex navigations we could pass this in dependency injection
    
    let TILES_PER_ROW = 2.0
    let INTER_CELL_SPACING = 10.0
    let TILE_WIDTH_TO_HEIGHT_RATIO = 1.335
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.registerCells()
        self.loadData()
        self.setupRefreshControls()
    }
    
    func setupRefreshControls() {
        let refreshControlForTable = UIRefreshControl()
        refreshControlForTable.addTarget(self, action: #selector(reloadData), for: .valueChanged)
        self.tableView?.refreshControl = refreshControlForTable
        
        let refreshControlForGrid = UIRefreshControl()
        refreshControlForGrid.addTarget(self, action: #selector(reloadData), for: .valueChanged)
        self.collectionView?.refreshControl = refreshControlForGrid
    }
    
    func registerCells() {
        let tableCellNib = UINib(nibName: MovieTableCell.NIB_NAME, bundle: Bundle.main)
        self.tableView?.register(tableCellNib, forCellReuseIdentifier: MovieTableCell.CELL_IDENTIFIER)
        
        let collectionCellNib = UINib(nibName: MovieCollectionCell.NIB_NAME, bundle: Bundle.main)
        self.collectionView?.register(collectionCellNib, forCellWithReuseIdentifier: MovieCollectionCell.CELL_IDENTIFIER)
    }
    
    @IBAction func layoutChanged() {
        self.tableView?.isHidden = self.layoutControl?.selectedSegmentIndex == 0
        self.collectionView?.isHidden = self.layoutControl?.selectedSegmentIndex == 1
    }
    
    @IBAction func tappedOnChangeMovieMode() {
        self.movieManager.mode = self.movieModeControl?.selectedSegmentIndex == 0 ? .mostPopular : .nowPlaying
        self.loadData()
    }
    
    func loadData() {
        self.movieManager.loadData { success in
            self.tableView?.refreshControl?.endRefreshing()
            self.collectionView?.refreshControl?.endRefreshing()
            self.collectionView?.reloadData()
            self.tableView?.reloadData()
            if (!success) {
                ErrorHandler.showNetworkError(inVC: self)
            }
        }
    }
    
    @objc func reloadData() {
        self.movieManager.clearData()
        self.loadData()
    }
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource,  UICollectionViewDelegateFlowLayout{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        self.movieManager.pages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if (section >= self.movieManager.pages.count) {
            //Shouldn't enter here, but it's always nice to add this safeguards for a rock-solid experience.
            //This sometimes happens if updating of the collectionview is done wrong so it's useful.
            return 0
        }
        let page = self.movieManager.pages[section]
        return page.movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCollectionCell.CELL_IDENTIFIER, for: indexPath) as? MovieCollectionCell {
            cell.delegate = self
            //We separate this 2 conditionals to be able to return cell since dequeued cell should crash UICollectionViewCell() does.
            if (indexPath.section < self.movieManager.pages.count) {
                let page = self.movieManager.pages[indexPath.section]
                if indexPath.row < page.movies.count {
                    let movie = page.movies[indexPath.row]
                    DispatchQueue.main.async {
                        cell.populateCell(withMovie: movie)
                    }
                    cell.observation = movie.observe(\Movie.posterImage) { movie, change in
                        UIView.performWithoutAnimation {
                            self.collectionView?.reloadItems(at: [indexPath])
                        }
                    }
                    return cell
                }
            }
            return cell
        }
        return UICollectionViewCell() //Shouldn't get here, this would indeed crash,
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.size.width - ((TILES_PER_ROW) * INTER_CELL_SPACING)) / TILES_PER_ROW
        return CGSize(width: width, height: width * TILE_WIDTH_TO_HEIGHT_RATIO)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.section == movieManager.pages.count - 1 &&
            movieManager.pages.count < movieManager.totalPages {
            let page = movieManager.pages[indexPath.section]
            if (indexPath.row == page.movies.count - 1) {
                self.loadData()
            }
        }
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        self.movieManager.pages.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (section >= self.movieManager.pages.count) {
            //Same as before
            return 0
        }
        let page = self.movieManager.pages[section]
        return page.movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: MovieTableCell.CELL_IDENTIFIER) as? MovieTableCell,
           indexPath.section < self.movieManager.pages.count {
            cell.delegate = self
            let page = self.movieManager.pages[indexPath.section]
            if indexPath.row < page.movies.count {
                let movie = page.movies[indexPath.row]
                DispatchQueue.main.async {
                    cell.populateCell(withMovie: movie)
                }
                cell.observation = movie.observe(\Movie.posterImage) { movie, change in
                    self.tableView?.reloadRows(at: [indexPath], with: .none)
                }
                return cell
            }
        }
        return UITableViewCell() //Shouldn't get here but shouldn't crash we just show empty cell and log it to crashlytics or something.
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let page = self.movieManager.pages[indexPath.section]
        if indexPath.row < page.movies.count {
            let movie = page.movies[indexPath.row]
            let overviewWidth = (self.tableView?.frame.size.width ?? 0.0) - (MovieTableCell.MARGIN * 2.0)
            let overviewHeight = movie.overview.calculateHeight(withFont: UIFont.systemFont(ofSize: 14.0), width: overviewWidth)
            let cellHeight = (MovieTableCell.CELL_HEIGHT_WITHOUT_OVERVIEW + overviewHeight)
            return cellHeight
        }
        return (MovieTableCell.CELL_HEIGHT_WITHOUT_OVERVIEW + MovieTableCell.OVERVIEW_INITIAL_SIZE)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.section == movieManager.pages.count - 1  &&
            movieManager.pages.count < movieManager.totalPages {
            let page = movieManager.pages[indexPath.section]
            if (indexPath.row == page.movies.count - 1) {
                self.loadData()
            }
        }
    }
}

extension HomeViewController: MovieTableCellDelegate, MovieCollectionCellDelegate {
    func didTapFavoriteOnTable(_ cell: UITableViewCell) {
        if let indexPath = tableView?.indexPath(for: cell) {
            let page = self.movieManager.pages[indexPath.section]
            let movie = page.movies[indexPath.row]
            movie.changeFavorite()
            self.tableView?.reloadRows(at: [indexPath], with: .none)
        }
    }
    
    func didTapFavoriteOnCollection(_ cell: UICollectionViewCell) {
        if let indexPath = collectionView?.indexPath(for: cell) {
            let page = self.movieManager.pages[indexPath.section]
            let movie = page.movies[indexPath.row]
            movie.changeFavorite()
            UIView.performWithoutAnimation {
                self.collectionView?.reloadItems(at: [indexPath])
            }
        }
    }
}
