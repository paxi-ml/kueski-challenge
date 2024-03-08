//
//  Extensions.swift
//  KueskiChallenge
//
//  Created by Alexander Coto on 7/3/24.
//

import Foundation
import UIKit

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

extension String {
    //This is troublesome, there are always scenarios where bounding rect is not 100% accurate, I've found this method to be pretty useful since we can adjust it according to dynamic text sizing and other factors.
    func calculateNumOfLines(withFont font: UIFont, width: CGFloat) -> Int {
        let maxSize = CGSize(width: width, height: CGFloat(Float.infinity))
        let charSize = font.lineHeight
        // swiftformat:disable:next all
        let textSize = self.boundingRect(with: maxSize, options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: [NSAttributedString.Key.font: font], context: nil)
        let linesRoundedUp = Int(ceil(textSize.height / charSize))
        return linesRoundedUp
    }
    
    func calculateHeight(withFont font:UIFont, width: CGFloat) -> Double {
        let LINE_HEIGHT_ADJUST = 2.0
        return Double(calculateNumOfLines(withFont: font, width: width)) * (font.lineHeight + LINE_HEIGHT_ADJUST) + 20.0
    }
}
