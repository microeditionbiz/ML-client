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
    
    var currentAmount: Double {
        if let text = amountTextField.text, let amount = Double(text) {
            return amount
        } else {
            return 0
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        refreshNextButtonEnabledState()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addKeyboardNotificationsObserver()
        addTextFieldTextDidChangeObserver()
        amountTextField.becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        amountTextField.resignFirstResponder()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        removeKeyboardNotificatiosObserver()
        removeTextFieldTextDidChangeObserver()
    }
    
    // MARK: - Action
    
    @IBAction func nextAction(sender: UIButton) {
        showPaymentMethodViewController()
    }

    // MARK: - Amount text field
    
    private func addTextFieldTextDidChangeObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(AmountViewController.textFieldTextDidChange(_:)), name: Notification.Name.UITextFieldTextDidChange, object: nil)
    }
    
    private func removeTextFieldTextDidChangeObserver() {
        NotificationCenter.default.removeObserver(self, name: Notification.Name.UITextFieldTextDidChange, object: nil)
    }
    
    @objc private func textFieldTextDidChange(_ notification: Notification) {
        refreshNextButtonEnabledState()
    }
    
    // MARK: - Next button
    
    private func refreshNextButtonEnabledState() {
        let enabled = currentAmount > 0
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
        paymentInfo.amount = currentAmount
        performSegue(withIdentifier: "ShowPaymentMethods", sender: nil)
    }

    func completePaymentFlow(withPaymentInfo paymentInfo: PaymentInfo) {
        self.navigationController?.popToRootViewController(animated: true)
        guard let paymentMethodName = paymentInfo.paymentMethod?.name, let cardIssuerName = paymentInfo.cardIssuer?.name, let recommendedMessage = paymentInfo.payerCost?.recommendedMessage else {
            assertionFailure("Missing required info")
            return
        }
        
        amountTextField.text = ""
        
        let message = "Esta por pagar \(recommendedMessage) con el medio de pago \(paymentMethodName) del banco \(cardIssuerName)."
        
        UIAlertController.presentAlert(withTitle: "Pago", message: message, overViewController: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let viewController = segue.destination as? PaymentMethodsViewController {
            viewController.paymentInfo = paymentInfo
        }
    }

}
