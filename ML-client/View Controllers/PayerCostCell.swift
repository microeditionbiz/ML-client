//
//  PayerCostCell.swift
//  ML-client
//
//  Created by Pablo Romero on 8/14/17.
//  Copyright © 2017 Pablo Romero. All rights reserved.
//

import UIKit

class PayerCostCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()

    }
    
    func update(withPayerCost payerCost: Installments.PayerCost) {
        textLabel?.text = payerCost.recommendedMessage
    }

}
