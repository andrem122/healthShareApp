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

        // Do any additional setup after loading the view.
        
        // Pop up the keyboard for the first field when the view loads
        self.emailInput.becomeFirstResponder()
        
        // Make 'continue' button round
        continueButton.layer.cornerRadius = 5
        continueButton.clipsToBounds = true
        
        // Remove border of navigation bar
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        // Set the delegate for 'emailInput' UITextField to current instance of this class
        self.emailInput.delegate = self
        
        // Set UIBarButton Item
        self.navigationItem.setLeftBarButton((UIBarButtonItem(image: UIImage(named:"cancel"), style: .plain, target: self, action: #selector(returnToLoginScreen(sender:)))), animated: false)
        
    }
    
    // MARK: Properties
    @IBOutlet weak var emailInput: UITextField!
    @IBOutlet weak var continueButton: UIButton!
    var email: String = ""
    var userInfo = [String: String]()
    lazy var alert: Alert = Alert(currentViewController: self)
    
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
    
    func keyboardWasShown(notification: NSNotification) {
        let info = notification.userInfo!
        let keyboardFrame: CGRect = (info[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        
        UIView.animate(withDuration: 0.1, animations: { () -> Void in
            self.continueButton.constraints
        })
    }
    
}
