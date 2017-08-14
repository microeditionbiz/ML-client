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

    static func presentAlert(withError error: Error, overViewController vc: UIViewController) {
        UIAlertController.presentAlert(withTitle: "Error", message: error.localizedDescription, overViewController: vc)
    }
    
    static func presentAlert(withTitle title: String? = "", message: String, overViewController vc: UIViewController) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .default))
        vc.present(alertController, animated: true, completion: nil)
    }
    
    static func presentQuestion(withTitle title: String? = "", text: String, okTitle: String, cancelTitle: String, overViewController vc: UIViewController, completion: @escaping ((Bool) -> Void)) {
        
        let alertController = UIAlertController(title: title, message: text, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: okTitle, style: .default) { (action) in
            completion(true)
        }
        
        let cancelAction = UIAlertAction(title: cancelTitle, style: .cancel) { (action) in
            completion(false)
        }
        
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        
        vc.present(alertController, animated: true, completion: nil)
    }

}
