//
//  MovieServiceMock.swift
//  KueskiChallengeTests
//
//  Created by Alexander Coto on 8/3/24.
//

import Foundation

class MovieServiceMock {
    static let shared = MovieServiceMock()
    
    var configurationBaseUrl:URL? = nil
    
    //MARK: Requests
    func fetchConfiguration(completion: @escaping () -> Void) {
        if let path = Bundle.main.path(forResource: "mock_configuration", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let result = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                if let dict = result as? NSDictionary,
                   let config:MovieDBConfiguration = dict.parseToObj() {
                    self.configurationBaseUrl = config.baseUrl
                    completion()
                }
              } catch {
                   completion()
              }
        }
    }
    
    func fetchNowPlaying (completion: @escaping (MoviePage?) -> Void) {
        if let path = Bundle.main.path(forResource: "mock_moviePage", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let result = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                if let dict = result as? NSDictionary,
                   let page : MoviePage = dict.parseToObj() {
                    completion(page)
                }
              } catch {
                   completion(nil)
              }
        }
    }
    
    func fetchMostPopular (completion: @escaping (MoviePage?) -> Void) {
        if let path = Bundle.main.path(forResource: "mock_moviePage", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let result = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                if let dict = result as? NSDictionary,
                   let page : MoviePage = dict.parseToObj() {
                    completion(page)
                }
              } catch {
                   completion(nil)
              }
        }
    }
}
