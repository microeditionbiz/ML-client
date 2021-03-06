//
//  PaymentInfo.swift
//  ML-client
//
//  Created by Pablo Romero on 8/14/17.
//  Copyright © 2017 Pablo Romero. All rights reserved.
//

import Foundation

struct PaymentInfo {
    
    private var amountFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.locale = Locale.current
        return formatter
    }()
    
    var amount = NSNumber(value: 0)
    var formattedAmount: String {
        return amountFormatter.string(from: amount) ?? ""
    }
    
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
    
    mutating func setAmount(string: String) {
        amount = amountFormatter.number(from: string) ?? NSNumber(value: 0)
    }
    
}
