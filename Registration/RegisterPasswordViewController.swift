//
//  LoginViewController.swift
//  userLoginAndRegistration
//
//  Created by Andre Mashraghi on 12/8/18.
//  Copyright © 2018 Andre Mashraghi. All rights reserved.
//

import UIKit

class RegisterPasswordViewController: UIViewController, UITextFieldDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Pop up the keyboard for the first field when the view loads
        self.passwordInput.becomeFirstResponder()
        
        let setup = Setup(viewController: self)
        setup.setupButtons(buttonToSetup: self.continueButton)
        setup.setupNavigation()
        
        if let email = userInfo["email"] {
            print(email)
        }
        
        // Set the delegate for 'passowrdInput' UITextField to current instance of this class
        self.passwordInput.delegate = self
        
        // Detect when keyboard is shown and hidden
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWasShown(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillDisappear), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    // MARK: Properties
    @IBOutlet weak var passwordInput: UITextField!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var helpText: UILabel!
    var userInfo = [String: String]()
    lazy var alert: Alert = Alert(currentViewController: self)
    @IBOutlet weak var continueButtonBottomConstraint: NSLayoutConstraint!
    
    // MARK: Actions
    @IBAction func continueButtonTapped(_ sender: Any) {
        
        // Input fields
        let password = passwordInput.text!
        
        // Check for empty fields
        if password.isEmpty {
            
            alert.alertMessage(title: "Error", message: "Password: this field is required")
            return
            
        } else {
            
            // Password must be 10 characters long
            if password.count < 10 {
                
                alert.alertMessage(title: "Error", message: "Your password must be at least 10 characters.")
                return
                
            } else {
                
                self.userInfo["password"] = password
                
            }
            
        }
        
    }
    
    @IBAction func passwordInputEdit(_ sender: Any) {
        
        // Input fields
        let password = passwordInput.text!
        
        if password.count < 10 {
            helpText.isHidden = false
            helpText.text = "Password must be at least 10 characters."
        } else {
            helpText.isHidden = true
        }
        
    }
    
     // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // Send dictionary to RegisterNameViewController
        let registerNameVC = segue.destination as! RegisterNameViewController
        registerNameVC.userInfo = self.userInfo
        
    }
    
}

extension RegisterPasswordViewController {
    
    // When return key (done key in our case) is pressed, this function is called
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        // Send touch event to the continue button so that our data validation logic can be used
        self.continueButton.sendActions(for: .touchUpInside)
        return true
        
    }
    
    // Move continue button up above the keyboard and back to it's original position when keyboard disappear
    @objc func keyboardWasShown(notification: NSNotification) {
        print("keyboard shown!")
        let info = notification.userInfo!
        let keyboardFrame: CGRect = (info[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        
        UIView.animate(withDuration: 0.1, animations: {
            () -> Void in
            self.continueButtonBottomConstraint.constant = keyboardFrame.size.height + 20
        })
    }
    
    @objc func keyboardWillDisappear() {
        
        UIView.animate(withDuration: 0.1, animations: {
            () -> Void in
            self.continueButtonBottomConstraint.constant = 30
        })
    }
    
}
