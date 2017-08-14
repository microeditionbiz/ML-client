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
        tintColor = UIColor.mpBlue
        selectionStyle = .none
    }
    
    func update(withPayerCost payerCost: Installments.PayerCost) {
        textLabel?.text = payerCost.recommendedMessage
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        accessoryType = selected ? .checkmark : .none
    }

}
