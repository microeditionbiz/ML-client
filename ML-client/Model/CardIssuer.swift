//
//  CardIssuer.swift
//
//  Created by Pablo Romero on 8/13/17
//  Copyright (c) . All rights reserved.
//

import Foundation
import ObjectMapper

public class CardIssuer: Mappable {

    private struct SerializationKeys {
        static let name = "name"
        static let processingMode = "processing_mode"
        static let id = "id"
        static let merchantAccountId = "merchant_account_id"
        static let thumbnail = "thumbnail"
        static let secureThumbnail = "secure_thumbnail"
    }
    
    public var name: String?
    public var processingMode: String?
    public var id: String?
    public var merchantAccountId: String?
    public var thumbnail: String?
    public var secureThumbnail: String?
    
    public required init?(map: Map) {
        
    }
    
    public func mapping(map: Map) {
        name <- map[SerializationKeys.name]
        processingMode <- map[SerializationKeys.processingMode]
        id <- map[SerializationKeys.id]
        merchantAccountId <- map[SerializationKeys.merchantAccountId]
        thumbnail <- map[SerializationKeys.thumbnail]
        secureThumbnail <- map[SerializationKeys.secureThumbnail]
    }

}
