//
//  CardIssuerCell.swift
//  ML-client
//
//  Created by Pablo Romero on 8/14/17.
//  Copyright © 2017 Pablo Romero. All rights reserved.
//

import UIKit

class CardIssuerCell: UICollectionViewCell {
    
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var iconImageView: RemoteImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        cardView.layer.cornerRadius = 10
        cardView.clipsToBounds = true
        
        self.clipsToBounds = false
        self.layer.shadowOffset = CGSize.zero
        self.layer.shadowRadius = 3.0
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.2
        
        self.layer.rasterizationScale = UIScreen.main.scale
        self.layer.shouldRasterize = true;
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
