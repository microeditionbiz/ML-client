//
//  PaymentMethod.swift
//
//  Created by Pablo Romero on 8/13/17
//  Copyright (c) . All rights reserved.
//

import Foundation
import ObjectMapper

public class PaymentMethod: Mappable {
    
    private struct SerializationKeys {
        static let deferredCapture = "deferred_capture"
        static let name = "name"
        static let thumbnail = "thumbnail"
        static let paymentTypeId = "payment_type_id"
        static let accreditationTime = "accreditation_time"
        static let financialInstitutions = "financial_institutions"
        static let additionalInfoNeeded = "additional_info_needed"
        static let status = "status"
        static let id = "id"
        static let settings = "settings"
        static let maxAllowedAmount = "max_allowed_amount"
        static let minAllowedAmount = "min_allowed_amount"
        static let processingModes = "processing_modes"
        static let secureThumbnail = "secure_thumbnail"
    }
    
    public var deferredCapture: String?
    public var name: String?
    public var thumbnail: String?
    public var paymentTypeId: String?
    public var accreditationTime: Int?
    public var status: String?
    public var id: String?
    public var maxAllowedAmount: NSNumber?
    public var minAllowedAmount: NSNumber?
    public var secureThumbnail: String?
    
    static var numberTransform: TransformOf<NSNumber, Double> = {
        return TransformOf<NSNumber, Double>(fromJSON: { (value: Double?) -> NSNumber? in
            guard let numberDouble = value else {
                return nil
            }
            return NSNumber(value: numberDouble)
        }, toJSON: { (value: NSNumber?) -> Double? in
            if let value = value {
                return value.doubleValue
            }
            return nil
        })
    }()
    
    public required init?(map: Map) {
        
    }
    
    public func mapping(map: Map) {
        
        deferredCapture <- map[SerializationKeys.deferredCapture]
        name <- map[SerializationKeys.name]
        thumbnail <- map[SerializationKeys.thumbnail]
        paymentTypeId <- map[SerializationKeys.paymentTypeId]
        accreditationTime <- map[SerializationKeys.accreditationTime]
        status <- map[SerializationKeys.status]
        id <- map[SerializationKeys.id]
        maxAllowedAmount <- (map[SerializationKeys.maxAllowedAmount], PaymentMethod.numberTransform)
        minAllowedAmount <- (map[SerializationKeys.minAllowedAmount], PaymentMethod.numberTransform)

        secureThumbnail <- map[SerializationKeys.secureThumbnail]
    }

}
