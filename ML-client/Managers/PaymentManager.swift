//
//  PaymentManager.swift
//  ML-client
//
//  Created by Pablo Romero on 8/13/17.
//  Copyright © 2017 Pablo Romero. All rights reserved.
//

import UIKit

class PaymentManager: NSObject {
    
    lazy var controller: PaymentController = {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        return storyboard.instantiateInitialViewController() as! PaymentController
    }()
    
    public var amount: Double?
    public var paymentMethod: PaymentMethod?
    public var cardIssuer: CardIssuer?
    public var installment: Installment?
}
