//
//  PaymentMethodsViewController.swift
//  ML-client
//
//  Created by Pablo Romero on 8/13/17.
//  Copyright © 2017 Pablo Romero. All rights reserved.
//

import UIKit

class PaymentMethodsViewController: UIViewController {

    struct CollectionViewDimensions {
        private init() {} // To avoid to create an instance from it
        static let verticalSpace: CGFloat = 20
        static let minHorizontalSpace: CGFloat = 20
        static let cellSize = CGSize(width: 100, height: 100)
    }
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    var paymentInfo: PaymentInfo?
    var paymentMethods: [PaymentMethod]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadData()
    }

    // MARK: - Networking
    
    private func loadData() {
        setLoadingMode(on: true)
        
        MPAPI.sharedInstance.paymentMethods { (paymentMethods, error) in
            
            self.setLoadingMode(on: false)
            
            if let error = error {
                UIAlertController.presentAlert(withError: error, overViewController: self)
            } else {
                self.paymentMethods = paymentMethods?.filter({ (paymentMethod) -> Bool in
                    if let type = paymentMethod.paymentTypeId {
                        return type == "credit_card"
                    } else {
                        return false
                    }
                })
                self.collectionView.reloadData()
            }
        }
    }
    
    // MARK: - Content
    
    private func setLoadingMode(on: Bool) {
        if on {
            activityIndicatorView.startAnimating()
        } else {
            activityIndicatorView.stopAnimating()
        }
        activityIndicatorView.isHidden = !on
        collectionView.isHidden = on
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

// MARK: - Extensions

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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CollectionViewDimensions.cellSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return CollectionViewDimensions.verticalSpace
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        // Center cells
        
        let width = UIScreen.main.bounds.width
        
        let cellByRowWithoutMinSpace = floor(width / CollectionViewDimensions.cellSize.width)
        
        let cellByRow = floor((width - CollectionViewDimensions.minHorizontalSpace * (cellByRowWithoutMinSpace + 1)) / CollectionViewDimensions.cellSize.width)
        
        let horizontalInset = (width - cellByRow * CollectionViewDimensions.cellSize.width) / (cellByRow + 1)
        
        return UIEdgeInsetsMake(CollectionViewDimensions.verticalSpace, horizontalInset, CollectionViewDimensions.verticalSpace, horizontalInset)
    }
    
}
