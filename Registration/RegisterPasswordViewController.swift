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
        
        // Do any additional setup after loading the view.
        
        // Pop up the keyboard for the first field when the view loads
        self.passwordInput.becomeFirstResponder()
        
        // Make 'continue' button round
        continueButton.layer.cornerRadius = 5
        continueButton.clipsToBounds = true
        
        // Edit back button text
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        // Remove border of navigation bar
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        if let email = userInfo["email"] {
            print(email)
        }
        
        // Set the delegate for 'passowrdInput' UITextField to current instance of this class
        self.passwordInput.delegate = self
        
    }
    
    // MARK: Properties
    @IBOutlet weak var passwordInput: UITextField!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var helpText: UILabel!
    var userInfo = [String: String]()
    lazy var alert: Alert = Alert(currentViewController: self)
    
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
    
}
