//
//  AmountViewController.swift
//  ML-client
//
//  Created by Pablo Romero on 8/13/17.
//  Copyright © 2017 Pablo Romero. All rights reserved.
//

import UIKit

class AmountViewController: UIViewController {
    
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var nextButtonBottomConstraint: NSLayoutConstraint!
    
    lazy var paymentInfo: PaymentInfo = {
        return PaymentInfo(paymentHandler: { [unowned self] paymentInfo in
            self.completePaymentFlow(withPaymentInfo: paymentInfo)
        })
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        refreshNextButtonEnabledState()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addKeyboardNotificationsObserver()
        amountTextField.becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        amountTextField.resignFirstResponder()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        removeKeyboardNotificatiosObserver()
    }
    
    // MARK: - Action
    
    @IBAction func nextAction(sender: UIButton) {
        showPaymentMethodViewController()
    }
    
    // MARK: - Next button
    
    fileprivate func refreshNextButtonEnabledState() {
        let enabled = paymentInfo.amount.compare(NSNumber(value: 0)) == .orderedDescending
        nextButton.isEnabled = enabled
        nextButton.backgroundColor = enabled ? UIColor.mpBlue : UIColor.lightGray.withAlphaComponent(0.25)
    }
    
    // MARK: - Keyboard
    
    private func addKeyboardNotificationsObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(AmountViewController.keyboardWillShow(_:)), name: Notification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(AmountViewController.keyboardWillHide(_:)), name: Notification.Name.UIKeyboardWillHide, object: nil)
    }
    
    private func removeKeyboardNotificatiosObserver() {
        NotificationCenter.default.removeObserver(self, name: Notification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: Notification.Name.UIKeyboardWillHide, object: nil)
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        
        let keyBoardInfo = notification.userInfo!
        let keyboardFrame = keyBoardInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue
        let duration = keyBoardInfo[UIKeyboardAnimationDurationUserInfoKey] as! Double
        let curve = keyBoardInfo[UIKeyboardAnimationCurveUserInfoKey] as! Int
            
        nextButtonBottomConstraint.constant = keyboardFrame.cgRectValue.size.height
        
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(duration)
        UIView.setAnimationCurve(UIViewAnimationCurve(rawValue: curve)!)
        
        self.view.layoutIfNeeded()
        UIView.commitAnimations()
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        
        let keyBoardInfo = notification.userInfo!
        let duration = keyBoardInfo[UIKeyboardAnimationDurationUserInfoKey] as! Double
        let curve = keyBoardInfo[UIKeyboardAnimationCurveUserInfoKey] as! Int
        
        nextButtonBottomConstraint.constant = 0
        
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(duration)
        UIView.setAnimationCurve(UIViewAnimationCurve(rawValue: curve)!)
        
        self.view.layoutIfNeeded()
        UIView.commitAnimations()
    }
    
    // MARK: - Navigation

    func showPaymentMethodViewController() {
        performSegue(withIdentifier: "ShowPaymentMethods", sender: nil)
    }

    func completePaymentFlow(withPaymentInfo paymentInfo: PaymentInfo) {
        self.navigationController?.popToRootViewController(animated: true)
        guard let paymentMethodName = paymentInfo.paymentMethod?.name, let cardIssuerName = paymentInfo.cardIssuer?.name, let recommendedMessage = paymentInfo.payerCost?.recommendedMessage else {
            assertionFailure("Missing required info")
            return
        }
        
        amountTextField.text = ""
        
        let message = "Usted pagó \(recommendedMessage) con el medio de pago \(paymentMethodName) del banco \(cardIssuerName)."
        
        UIAlertController.presentAlert(withTitle: "Pago", message: message, overViewController: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let viewController = segue.destination as? PaymentMethodsViewController {
            viewController.paymentInfo = paymentInfo
        }
    }

}

extension AmountViewController: UITextFieldDelegate {

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        var newValue = (textField.text as NSString?)?.replacingCharacters(in: range, with: string)
        newValue = newValue?.components(separatedBy: NSCharacterSet.decimalDigits.inverted).joined()
        paymentInfo.setAmount(string: newValue!)
        textField.text = paymentInfo.formattedAmount
        refreshNextButtonEnabledState()
        
        return false
    }

}
