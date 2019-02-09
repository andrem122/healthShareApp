//
//  RegisterEmailViewController.swift
//  userLoginAndRegistration
//
//  Created by Andre Mashraghi on 12/8/18.
//  Copyright © 2018 Andre Mashraghi. All rights reserved.
//

import UIKit

class RegisterSSNViewController: UIViewController, UITextFieldDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        // Pop up the keyboard for the first field when the view loads
        self.socialSecurityInput.becomeFirstResponder()
        
        let setup = Setup(viewController: self)
        setup.setupButtons(buttonToSetup: self.continueButton)
        setup.setupNavigation()
        
        // Set the delegate for 'emailInput' UITextField to current instance of this class
        self.socialSecurityInput.delegate = self
        
        for (key, value) in self.userInfo {
            
            print(key + ": " + value)
            
        }
        
    }
    
    // MARK: Properties
    @IBOutlet weak var socialSecurityInput: UITextField!
    @IBOutlet weak var continueButton: UIButton!
    var userInfo: [String: String] = [:]
    lazy var alert: Alert = Alert(currentViewController: self)
    
    // MARK: Actions
    @IBAction func continueButtonTapped(_ sender: Any) {
        
        // Input Fields
        let socialSecurityNumber: String = self.socialSecurityInput.text!
        
        if socialSecurityNumber.isEmpty {
            
            alert.alertMessage(title: "Error", message: "Social Security Number: This field is required.")
            
        } else if !(isVaildSocialSecurityNumber(socialSecurityNumber: socialSecurityNumber)) {
            
            alert.alertMessage(title: "Error", message: "Please enter a valid Social Security Number.")
            
        } else {
            
            // Add Social Security Number to 'userInfo' dictionary
            self.userInfo["socialSecurityNumber"] = socialSecurityNumber
            
        }
        
    }
    
    //MARK: Custom functions
    func isVaildSocialSecurityNumber(socialSecurityNumber number: String) -> Bool {
        
        // Remove '-' characters from the Social Security input string
        let unformattedSocialSecurityNumber = number.replacingOccurrences(of: "-", with: "")
        
        if unformattedSocialSecurityNumber.count < 9 {
            
            // Check if the birthday is a valid format
            print("Social Security input is an invalid format because its count is less than 9")
            return false
            
        }
        
        return true
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // Send user info to next view
        let registerAddressVC = segue.destination as! RegisterAddressViewController
        registerAddressVC.userInfo = self.userInfo
        
    }
    
    
}
extension RegisterSSNViewController {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == self.socialSecurityInput {
            
            // Count string characters; DD (character count is 2) and DD/MM (character count is 5)
            if self.socialSecurityInput.text?.count == 3 || self.socialSecurityInput.text?.count == 6 {
                
                // Handle backspace being pressed
                if !(string == "") {
    
                    // Append the spacer text of '/'
                    self.socialSecurityInput.text = self.socialSecurityInput.text! + "-"
                    
                }
                
            }
            
            // Make sure the input does not exceed 9 characters
            return !(textField.text!.count > 10 && (string.count) > range.length)
            
        }
        
        return true
        
    }
    
    // When return key (done key in our case) is pressed, this function is called
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        // Send touch event to the continue button so that our data validation logic can be used
        self.continueButton.sendActions(for: .touchUpInside)
        return true
        
    }
    
}

