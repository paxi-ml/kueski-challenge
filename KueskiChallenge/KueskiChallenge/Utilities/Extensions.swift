//
//  Extensions.swift
//  KueskiChallenge
//
//  Created by Alexander Coto on 7/3/24.
//

import Foundation

extension NSArray {
    func decodeFromJSON<T: Parseable>() -> [T] {
        compactMap {
            if let dict = $0 as? NSDictionary {
                return T(fromDictionary: dict)
            }
            return nil
        }
    }
}

extension NSDictionary {
    func parseToObj<T: Parseable>() -> T? {
        return T(fromDictionary: self)
    }
}
