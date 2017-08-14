//
//  PaymentInfo.swift
//  ML-client
//
//  Created by Pablo Romero on 8/14/17.
//  Copyright © 2017 Pablo Romero. All rights reserved.
//

import Foundation

struct PaymentInfo {
    var amount: Double = 0
    var paymentMethod: PaymentMethod?
    var cardIssuer: CardIssuer?
    var payerCost: Installments.PayerCost?
    private let paymentHandler: ((PaymentInfo) -> Void)
    
    init(paymentHandler: @escaping ((PaymentInfo) -> Void)) {
        self.paymentHandler = paymentHandler
    }
    
    func completePaymentFlow() {
        self.paymentHandler(self)
    }
}
