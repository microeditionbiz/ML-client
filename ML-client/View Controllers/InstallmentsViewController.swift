//
//  InstallmentsViewController.swift
//  ML-client
//
//  Created by Pablo Romero on 8/13/17.
//  Copyright © 2017 Pablo Romero. All rights reserved.
//

import UIKit

class InstallmentsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var paymentInfo: PaymentInfo?
    var installments: Installments?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadData()
    }
    
    // MARK: - Networking
    
    private func loadData() {
        guard let paymentMethodId = paymentInfo?.paymentMethod?.id, let cardIssuerId = paymentInfo?.cardIssuer?.id, let amount = paymentInfo?.amount else {
            assertionFailure("Missing required info")
            return
        }
        
        MPAPI.sharedInstance.installments(paymentMethodId: paymentMethodId, issuerId: cardIssuerId, amount: amount) { (installments, error) in
            if let error = error {
                UIAlertController.presentAlert(withError: error, overViewController: self)
            } else {
                self.installments = installments
                self.tableView.reloadData()
            }
        }
    }
    
    // MARK: - Navigation
    
//    fileprivate func showInstallmentsViewController(withCardIssuer cardIssuer: CardIssuer) {
//        paymentInfo?.cardIssuer = cardIssuer
//        performSegue(withIdentifier: "ShowInstallments", sender: nil)
//    }
//    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if let viewController = segue.destination as? InstallmentsViewController {
//            viewController.paymentInfo = paymentInfo
//        }
//    }
    
}

extension InstallmentsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return installments?.payerCosts?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
  
        let payerCost = installments!.payerCosts![indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "PayerCostCell", for: indexPath) as! PayerCostCell
        
        cell.update(withPayerCost: payerCost)
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let payerCost = installments?.payerCosts![indexPath.row]
//        showInstallmentsViewController(withCardIssuer: cardIssuer)
    }
    
}
