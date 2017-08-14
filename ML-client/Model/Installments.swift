//
//  Installments.swift
//
//  Created by Pablo Romero on 8/13/17
//  Copyright (c) . All rights reserved.
//

import Foundation
import ObjectMapper

public class Installments: Mappable {

    public class Issuer: Mappable {
        
        private struct SerializationKeys {
            static let name = "name"
            static let id = "id"
            static let thumbnail = "thumbnail"
            static let secureThumbnail = "secure_thumbnail"
        }
        
        public var name: String?
        public var id: String?
        public var thumbnail: String?
        public var secureThumbnail: String?
        
        public required init?(map: Map) {
            
        }
        
        public func mapping(map: Map) {
            name <- map[SerializationKeys.name]
            id <- map[SerializationKeys.id]
            thumbnail <- map[SerializationKeys.thumbnail]
            secureThumbnail <- map[SerializationKeys.secureThumbnail]
        }
        
    }
    
    public class PayerCost: Mappable {
        
        private struct SerializationKeys {
            static let discountRate = "discount_rate"
            static let labels = "labels"
            static let installmentRate = "installment_rate"
            static let installmentAmount = "installment_amount"
            static let minAllowedAmount = "min_allowed_amount"
            static let installmentRateCollector = "installment_rate_collector"
            static let totalAmount = "total_amount"
            static let maxAllowedAmount = "max_allowed_amount"
            static let recommendedMessage = "recommended_message"
            static let installments = "installments"
        }
        
        public var discountRate: Int?
        public var labels: [String]?
        public var installmentRate: Float?
        public var installmentAmount: Float?
        public var minAllowedAmount: Int?
        public var installmentRateCollector: [String]?
        public var totalAmount: Float?
        public var maxAllowedAmount: Int?
        public var recommendedMessage: String?
        public var installments: Int?
        
        public required init?(map: Map) {
            
        }
        
        public func mapping(map: Map) {
            discountRate <- map[SerializationKeys.discountRate]
            labels <- map[SerializationKeys.labels]
            installmentRate <- map[SerializationKeys.installmentRate]
            installmentAmount <- map[SerializationKeys.installmentAmount]
            minAllowedAmount <- map[SerializationKeys.minAllowedAmount]
            installmentRateCollector <- map[SerializationKeys.installmentRateCollector]
            totalAmount <- map[SerializationKeys.totalAmount]
            maxAllowedAmount <- map[SerializationKeys.maxAllowedAmount]
            recommendedMessage <- map[SerializationKeys.recommendedMessage]
            installments <- map[SerializationKeys.installments]
        }
        
    }
    
    private struct SerializationKeys {
        static let issuer = "issuer"
        static let paymentMethodId = "payment_method_id"
        static let paymentTypeId = "payment_type_id"
        static let processingMode = "processing_mode"
        static let payerCosts = "payer_costs"
    }
    
    public var issuer: Issuer?
    public var paymentMethodId: String?
    public var paymentTypeId: String?
    public var processingMode: String?
    public var payerCosts: [PayerCost]?
    
    public required init?(map: Map) {
        
    }
    
    public func mapping(map: Map) {
        issuer <- map[SerializationKeys.issuer]
        paymentMethodId <- map[SerializationKeys.paymentMethodId]
        paymentTypeId <- map[SerializationKeys.paymentTypeId]
        processingMode <- map[SerializationKeys.processingMode]
        payerCosts <- map[SerializationKeys.payerCosts]
    }

}
