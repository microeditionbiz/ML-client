//
//  CardIssuerCell.swift
//  ML-client
//
//  Created by Pablo Romero on 8/14/17.
//  Copyright © 2017 Pablo Romero. All rights reserved.
//

import UIKit

class CardIssuerCell: UICollectionViewCell {
    
    @IBOutlet weak var iconImageView: RemoteImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func update(withCardIssuer cardIssuer: CardIssuer) {
        if let stringURL = cardIssuer.secureThumbnail, let url = URL(string: stringURL) {
            iconImageView.setContent(url: url)
        } else {
            iconImageView.setContent(url: nil)
        }
        nameLabel.text = cardIssuer.name
    }
    
}
