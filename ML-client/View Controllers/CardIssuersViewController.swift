//
//  CardIssuersViewController.swift
//  ML-client
//
//  Created by Pablo Romero on 8/13/17.
//  Copyright © 2017 Pablo Romero. All rights reserved.
//

import UIKit

class CardIssuersViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    var paymentInfo: PaymentInfo?
    var cardIssuers: [CardIssuer]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadData()
    }
    
    // MARK: - Networking
    
    private func loadData() {
        let paymentMethodId = (paymentInfo?.paymentMethod?.id)!
        
        MLAPI.sharedInstance.cardIssuers(paymentMethodId: paymentMethodId) { (cardIssuers, error) in
            if let error = error {
                UIAlertController.presentAlert(withError: error, overViewController: self)
            } else {
                self.cardIssuers = cardIssuers
                self.collectionView.reloadData()
            }
        }
    }
    
    // MARK: - Navigation
    
    fileprivate func showInstallmentsViewController(withCardIssuer cardIssuer: CardIssuer) {
        paymentInfo?.cardIssuer = cardIssuer
        performSegue(withIdentifier: "ShowInstallments", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let viewController = segue.destination as? InstallmentsViewController {
            viewController.paymentInfo = paymentInfo
        }
    }
    
}

extension CardIssuersViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cardIssuers?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cardIssuer = cardIssuers![indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardIssuerCell", for: indexPath) as! CardIssuerCell
        
        cell.update(withCardIssuer: cardIssuer)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cardIssuer = cardIssuers![indexPath.row]
        showInstallmentsViewController(withCardIssuer: cardIssuer)
    }
    
}
