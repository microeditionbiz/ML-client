//
//  UIAlertController+Simplified.swift
//  ML-client
//
//  Created by Pablo Romero on 8/14/17.
//  Copyright © 2017 Pablo Romero. All rights reserved.
//

import Foundation
import UIKit

extension UIAlertController {

    static func presentAlert(withError error: Error,
                             overViewController vc: UIViewController) {
        let alertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        vc.present(alertController, animated: true, completion: nil)
    }

}
