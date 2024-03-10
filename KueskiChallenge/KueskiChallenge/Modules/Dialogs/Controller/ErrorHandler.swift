//
//  ErrorHandler.swift
//  KueskiChallenge
//
//  Created by Alexander Coto on 9/3/24.
//

import Foundation
import UIKit

enum ErrorMessages: String {
    case networkFailure = "There was an error loading the data, please try again later"
}

class ErrorHandler {
    static func showNetworkError(inVC vc: UIViewController) {
        let alertController = UIAlertController(title: nil, message: ErrorMessages.networkFailure.rawValue, preferredStyle: .alert)
        alertController.addAction(
            UIAlertAction(
                title: "OK", style: .cancel,
                handler: { _ in
                    alertController.dismiss(animated: true)
                }
            ))
        vc.present(alertController, animated: true, completion: nil)
    }
}
