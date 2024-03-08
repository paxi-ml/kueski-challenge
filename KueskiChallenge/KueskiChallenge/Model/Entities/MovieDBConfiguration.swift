//
//  MovieDBConfiguration.swift
//  KueskiChallenge
//
//  Created by Alexander Coto on 7/3/24.
//

import Foundation

class MovieDBConfiguration: Parseable {
    //We only need this one, with more time we would parse more values.
    var baseUrl:URL? = nil
    required init?(fromDictionary dict: NSDictionary) {
        let imagesDict = dict.object(forKey: "images") as? NSDictionary
        self.baseUrl = URL(string: imagesDict?.object(forKey: "secure_base_url") as? String ?? "")
    }
}
