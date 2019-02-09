//
//  RegisterEmailViewController.swift
//  userLoginAndRegistration
//
//  Created by Andre Mashraghi on 12/8/18.
//  Copyright © 2018 Andre Mashraghi. All rights reserved.
//

import UIKit

class RegisterEmailViewController: UIViewController, UITextFieldDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Pop up the keyboard for the first field when the view loads
        self.emailInput.becomeFirstResponder()
        
        let setup = Setup(viewController: self)
        setup.setupButtons(buttonToSetup: self.continueButton)
        setup.setupNavigation()
        
        // Set UIBarButton Item to cancel
        self.navigationItem.setLeftBarButton((UIBarButtonItem(image: UIImage(named:"cancel"), style: .plain, target: self, action: #selector(returnToLoginScreen(sender:)))), animated: false)
        
        // Set the delegate for 'emailInput' UITextField to current instance of this class
        self.emailInput.delegate = self
        
        // Detect when keyboard is shown and hidden
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWasShown(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillDisappear), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    // MARK: Properties
    @IBOutlet weak var emailInput: UITextField!
    @IBOutlet weak var continueButton: UIButton!
    var email: String = ""
    var userInfo = [String: String]()
    lazy var alert: Alert = Alert(currentViewController: self)
    @IBOutlet weak var continueButtonBottomConstraint: NSLayoutConstraint!
    
    // MARK: Actions
    @IBAction func continueButtonTapped(_ sender: Any) {
        
        // Input Fields
        let email = self.emailInput.text!
        
        // Check for empty fields
        if email.isEmpty {
            
            // Display alert message
            alert.alertMessage(title: "Error", message: "Email Address: this field is required")
            return
            
        } else {
            
            // Check if email is valid
            if self.isValidEmail(email: email) {
        
                self.userInfo["email"] = email.trimmingCharacters(in: .whitespacesAndNewlines)
                print(email)
                
            } else {
                
                // Display invalid email message
                alert.alertMessage(title: "Error", message: "Please enter a valid email address.")
                return
                
            }
        }
    }
    
    func isValidEmail(email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }
    

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // Send email text to RegisterPasswordViewController
        let registerPasswordVC = segue.destination as! RegisterPasswordViewController
        registerPasswordVC.userInfo = self.userInfo
        
        NotificationCenter.default.removeObserver(self)
        
    }
    
    // Returns the user the start screen after the cancel button is pressed
    @objc func returnToLoginScreen(sender: AnyObject) {
        
        // Show main screen
        if let startViewController = storyboard?.instantiateViewController(withIdentifier: "StartViewController") {
            
            self.present(startViewController, animated: true, completion: nil)
            
        }
        
    }

}
extension RegisterEmailViewController {
    
    // When return key (done key in our case) is pressed, this function is called
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        // Send touch event to the continue button so that our data validation logic can be used
        self.continueButton.sendActions(for: .touchUpInside)
        return true
        
    }
    
    // Move continue button up above the keyboard and back to it's original position when keyboard disappear
    @objc func keyboardWasShown(notification: NSNotification) {
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
