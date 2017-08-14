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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        refreshNextButtonEnabledState()
        amountTextField.becomeFirstResponder()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addKeyboardNotificationsObserver()
        addTextFieldTextDidChangeObserver()
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
        var enabled = false
        if let amount = amountTextField.text {
            enabled = !amount.isEmpty
        }
        
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
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

    }

}

extension AmountViewController: UITextFieldDelegate {
    
    
    
}
