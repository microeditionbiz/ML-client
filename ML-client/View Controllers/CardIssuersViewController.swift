//
//  CardIssuersViewController.swift
//  ML-client
//
//  Created by Pablo Romero on 8/13/17.
//  Copyright © 2017 Pablo Romero. All rights reserved.
//

import UIKit

class CardIssuersViewController: UIViewController {

    struct CollectionViewDimensions {
        private init() {} // To avoid to create an instance from it
        static let verticalSpace: CGFloat = 20
        static let minHorizontalSpace: CGFloat = 20
        static let cellSize = CGSize(width: 100, height: 100)
    }
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var noDataLabel: UILabel!
    
    var paymentInfo: PaymentInfo!
    var cardIssuers: [CardIssuer]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadData()
    }
    
    // MARK: - Networking
    
    private func loadData() {
        guard let paymentMethodId = paymentInfo?.paymentMethod?.id else {
            assertionFailure("Missing Required info")
            return
        }
        
        setNoDataMode(on: false)
        setLoadingMode(on: true)
        
        MPAPI.sharedInstance.cardIssuers(paymentMethodId: paymentMethodId) { (cardIssuers, error) in
            
            self.setLoadingMode(on: false)
            
            if let error = error {
                UIAlertController.presentAlert(withError: error, overViewController: self)
            } else {
                self.cardIssuers = cardIssuers
                let isEmpty = cardIssuers?.count == 0
                if !isEmpty {
                    self.collectionView.reloadData()
                }
                self.setNoDataMode(on: isEmpty)
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
    
    private func setNoDataMode(on: Bool) {
        noDataLabel.isHidden = !on
        collectionView.isHidden = on
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

// MARK: - Extensions

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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CollectionViewDimensions.cellSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return CollectionViewDimensions.verticalSpace
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        // Center cells
        
        let width = collectionView.bounds.width
        
        let cellByRow = floor((width - CollectionViewDimensions.minHorizontalSpace * 2.0) / CollectionViewDimensions.cellSize.width)
        
        let horizontalInset = (width - cellByRow * CollectionViewDimensions.cellSize.width) / (cellByRow + 1)
        
        return UIEdgeInsetsMake(CollectionViewDimensions.verticalSpace, horizontalInset, CollectionViewDimensions.verticalSpace, horizontalInset)
    }
    
}
