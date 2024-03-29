//
//  MovieService.swift
//  KueskiChallenge
//
//  Created by Alexander Coto on 7/3/24.
//

import Foundation
import Alamofire
import AlamofireImage

protocol API {
    static var host : URL { get }
}

enum MovieDB : String, API {
    static let host = URL(string: "https://api.themoviedb.org")!
    
    case movieDiscovery = "/3/discover/movie"
    case configuration = "/3/configuration"
}

class MovieService {
    static let shared = MovieService()
    
    let sessionManager = Alamofire.SessionManager()
    let imageDownloader = AlamofireImage.ImageDownloader(imageCache: nil)
    
    var configurationBaseUrl:URL? = nil
    
    //MARK: Parse
    func parseResponseToArray(response: Alamofire.DataResponse<Any>) -> NSArray? {
        switch response.result {
        case let .success(value):
            if let dict = value as? NSArray {
                return dict
            }
            return nil

        case .failure(_):
            return nil
        }
    }
    
    func parseResponseToDict(response: Alamofire.DataResponse<Any>) -> NSDictionary? {
        switch response.result {
        case let .success(value):
            if let dict = value as? NSDictionary {
                return dict
            }
            return nil

        case .failure(_):
            return nil
        }
    }
    
    //MARK: Requests
    func fetchConfiguration(completion: @escaping () -> Void) {
        if self.configurationBaseUrl != nil {
            completion()
            return
        }
        
        let headers:HTTPHeaders = ["Authorization":"Bearer \(Bundle.main.infoDictionary?["MOVIE_DB_API_TOKEN"] as? String ?? "")"]
        
        if let url = URL(string: "\(MovieDB.configuration.rawValue)", relativeTo: MovieDB.host) {
            sessionManager.request(url, headers: headers).responseJSON { response in
                if let dict = self.parseResponseToDict(response: response),
                   let config:MovieDBConfiguration = dict.parseToObj() {
                    self.configurationBaseUrl = config.baseUrl
                }
                completion()
            }
        }
    }
    
    func fetchNowPlaying (page:Int, completion: @escaping (MoviePage?) -> Void) {
        var urlParameters:[String:String] = [:]
        urlParameters["include_adult"] = "false"
        urlParameters["include_video"] = "false"
        urlParameters["language"] = "en-US"
        urlParameters["sort_by"] = "popularity.desc"
        urlParameters["with_release_type"] = "2|3"
        urlParameters["release_date.gte"] = "2023-06-01"
        urlParameters["release_date.lte"] = "2024-02-28"
        urlParameters["page"] = "\(page)"
        
        let headers:HTTPHeaders = ["Authorization":"Bearer \(Bundle.main.infoDictionary?["MOVIE_DB_API_TOKEN"] as? String ?? "")"]
        
        if let url = URL(string: "\(MovieDB.movieDiscovery.rawValue)", relativeTo: MovieDB.host) {
            sessionManager.request(url, parameters: urlParameters, headers: headers).responseJSON { response in
                if let dict = self.parseResponseToDict(response: response),
                   let page : MoviePage = dict.parseToObj() {
                    _ = page.movies.compactMap { movie in
                        self.fetchImage(fromPath:movie.posterPath, completion: { image in
                            movie.posterImage = image
                        })
                    }
                    completion(page)
                } else {
                    completion(nil)
                }
            }
        }
    }
    
    func fetchMostPopular (page:Int, completion: @escaping (MoviePage?) -> Void) {
        var urlParameters:[String:String] = [:]
        urlParameters["include_adult"] = "false"
        urlParameters["include_video"] = "false"
        urlParameters["language"] = "en-US"
        urlParameters["sort_by"] = "popularity.desc"
        urlParameters["page"] = "\(page)"
        
        let headers:HTTPHeaders = ["Authorization":"Bearer \(Bundle.main.infoDictionary?["MOVIE_DB_API_TOKEN"] as? String ?? "")"]
        
        if let url = URL(string: "\(MovieDB.movieDiscovery.rawValue)", relativeTo: MovieDB.host) {
            sessionManager.request(url, parameters: urlParameters, headers: headers).responseJSON { response in
                if let dict = self.parseResponseToDict(response: response),
                   let page : MoviePage = dict.parseToObj() {
                    _ = page.movies.compactMap { movie in
                        self.fetchImage(fromPath:movie.posterPath, completion: { image in
                            movie.posterImage = image
                        })
                    }
                    completion(page)
                } else {
                    completion(nil)
                }
            }
        }
    }
    
    func fetchImage(fromPath path:String, completion: @escaping (UIImage?) -> Void) {
        if let url = URL(string: "\(Constants.MOVIE_IMAGE_SIZE)\(path)", relativeTo: self.configurationBaseUrl) {
            let apiKey = URLQueryItem(name: "api_key", value: Bundle.main.infoDictionary?["MOVIE_DB_API_KEY"] as? String ?? "")
            let fullUrl = url.appending(queryItems: [apiKey])
            let urlRequest = URLRequest(url: fullUrl, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)
            self.imageDownloader.download(urlRequest) { dataResponse in
                switch dataResponse.result {
                case let .success(image):
                    completion(image)
                    break
                case .failure:
                    completion(nil)
                    break
                }
            }
        }
    }
}
