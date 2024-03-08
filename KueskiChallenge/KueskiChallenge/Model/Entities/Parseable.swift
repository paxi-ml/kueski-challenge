//
//  Parseable.swift
//  KueskiChallenge
//
//  Created by Alexander Coto on 7/3/24.
//

import Foundation

protocol Parseable {
    init?(fromDictionary dict: NSDictionary)
}
