//
//  PaymentMethodCell.swift
//  ML-client
//
//  Created by Pablo Romero on 8/14/17.
//  Copyright © 2017 Pablo Romero. All rights reserved.
//

import UIKit

class PaymentMethodCell: UICollectionViewCell {
    
    @IBOutlet weak var iconImageView: RemoteImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
      
        
    }
    
    func update(withPaymentMethod paymentMethod: PaymentMethod) {
        if let stringURL = paymentMethod.secureThumbnail, let url = URL(string: stringURL) {
            iconImageView.setContent(url: url)
        } else {
            iconImageView.setContent(url: nil)
        }
        nameLabel.text = paymentMethod.name
    }
    
}
