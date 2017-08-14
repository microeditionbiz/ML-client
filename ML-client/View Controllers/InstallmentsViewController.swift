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
    var selectedPayerCost: Installments.PayerCost?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        
        loadData()
    }
    
    // MARK: - Setup
    
    private func setupTableView() {
        // This is to don't have empty cells
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = UIColor.clear
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
    
    // MARK: - Actions
    
    @IBAction func payAction(_ sender: UIBarButtonItem) {
        if selectedPayerCost == nil {
            UIAlertController.presentAlert(message: "Primero debe seleccionar un plan de pagos.", overViewController: self)
        } else {
            completePaymentFlow()
        }
    }
    
    // MARK: - Navigation
    
    fileprivate func completePaymentFlow() {
        UIAlertController.presentQuestion(text: "Proceder con el pago?", okTitle: "Ok", cancelTitle: "Cancelar", overViewController: self) { (pay) in
            if pay {
                self.paymentInfo?.payerCost = self.selectedPayerCost
                self.paymentInfo?.completePaymentFlow()
            }
        }
    }
    
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
        selectedPayerCost = installments?.payerCosts![indexPath.row]
        
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        selectedPayerCost = nil
    }
    
}
