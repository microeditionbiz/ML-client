//
//  PaymentInfo.swift
//  ML-client
//
//  Created by Pablo Romero on 8/14/17.
//  Copyright © 2017 Pablo Romero. All rights reserved.
//

import Foundation

struct PaymentInfo {
    var amount: Double
    var paymentMethod: PaymentMethod?
    var cardIssuer: CardIssuer?
    var installment: Installment?

    init(amount: Double) {
        self.amount = amount
    }
}
