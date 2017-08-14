//
//  PaymentMethodsViewController.swift
//  ML-client
//
//  Created by Pablo Romero on 8/13/17.
//  Copyright © 2017 Pablo Romero. All rights reserved.
//

import UIKit

class PaymentMethodsViewController: UIViewController {

//    struct CollectionViewDimensions {
//        private init() {} // To avoid to create an instance from it
//        static let horizontalSpace: CGFloat = 0
//        static let verticalSpace: CGFloat = 5
//        static let sectionHeaderHeight: CGFloat = 30
//        static let sectionFooterHeight: CGFloat = 28
//    }
    
    @IBOutlet weak var collectionView: UICollectionView!
    var paymentInfo: PaymentInfo?
    var paymentMethods: [PaymentMethod]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadData()
    }

    // MARK: - Networking
    
    private func loadData() {
        MLAPI.sharedInstance.paymentMethods { (paymentMethods, error) in
            if let error = error {
                UIAlertController.presentAlert(withError: error, overViewController: self)
            } else {
                self.paymentMethods = paymentMethods
                self.collectionView.reloadData()
            }
        }
    }
    
    // MARK: - Navigation

    fileprivate func showCardIssuersViewController(withPaymentMethod paymentMethod: PaymentMethod) {
        paymentInfo?.paymentMethod = paymentMethod
        performSegue(withIdentifier: "ShowCardIssuers", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let viewController = segue.destination as? CardIssuersViewController {
            viewController.paymentInfo = paymentInfo
        }
    }

}

extension PaymentMethodsViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return paymentMethods?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let paymentMethod = paymentMethods![indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PaymentMethodCell", for: indexPath) as! PaymentMethodCell
        
        cell.update(withPaymentMethod: paymentMethod)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let paymentMethod = paymentMethods![indexPath.row]
        showCardIssuersViewController(withPaymentMethod: paymentMethod)
    }
    
}
