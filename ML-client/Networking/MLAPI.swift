//
//  RedditAPI.swift
//  ML-client
//
//  Created by Pablo Romero on 8/12/17.
//  Copyright © 2017 Pablo Romero. All rights reserved.
//

import UIKit

class MLAPI: NSObject {

    public static let sharedInstance: MLAPI = MLAPI()
    
    private let baseURL = "https://api.mercadopago.com/v1"
    private let publicKey = "444a9ef5-8a6b-429f-abdf-587639155d88"
    private let networking = NetworkingHelper.sharedInstance
    
    public func paymentMethods(completion: @escaping (([PaymentMethod]?, Error?) -> Void)) {
        
        let params = ["public_key": publicKey]
        
        networking.get(baseURL: baseURL, path: "payment_methods", params: params) { (response, error) in
            
            var paymentMethods: [PaymentMethod]?
            
            if let response = response as? [JSON], error == nil {
                paymentMethods = response.map({ (json) -> PaymentMethod in
                    return PaymentMethod(JSON: json)!
                })
            }
          
            DispatchQueue.main.async {
                completion(paymentMethods, error)
            }
        }
    }
    
    public func cardIssuers(paymentMethodId: String, completion: @escaping (([CardIssuer]?, Error?) -> Void)) {
        
        let params = ["public_key": publicKey,
                      "payment_method_id": paymentMethodId]
        
        networking.get(baseURL: baseURL, path: "payment_methods/card_issuers", params: params) { (response, error) in
            
            var cardIssuers: [CardIssuer]?
            
            if let response = response as? [JSON], error == nil {
                cardIssuers = response.map({ (json) -> CardIssuer in
                    return CardIssuer(JSON: json)!
                })
            }
            
            DispatchQueue.main.async {
                completion(cardIssuers, error)
            }
        }
    }
    
    public func installments(paymentMethodId: String, issuerId: String, amount: Double, completion: @escaping (([Installment]?, Error?) -> Void)) {
        
        let params = ["public_key": publicKey,
                      "payment_method_id": paymentMethodId,
                      "issuer.id": issuerId,
                      "amount": "\(amount)"]
        
        networking.get(baseURL: baseURL, path: "payment_methods/installments", params: params) { (response, error) in
            
            var installments: [Installment]?
            
            if let response = response as? [JSON], error == nil {
                installments = response.map({ (json) -> Installment in
                    return Installment(JSON: json)!
                })
            }
            
            DispatchQueue.main.async {
                completion(installments, error)
            }
        }
    }
    
}
