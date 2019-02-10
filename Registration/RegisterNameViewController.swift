//
//  LoginViewController.swift
//  userLoginAndRegistration
//
//  Created by Andre Mashraghi on 12/8/18.
//  Copyright © 2018 Andre Mashraghi. All rights reserved.
//

import UIKit

class RegisterNameViewController: UIViewController, UITextFieldDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        // Pop up the keyboard for the first field when the view loads
        self.firstNameInput.becomeFirstResponder()
        
        let setup = Setup(viewController: self)
        setup.setupButtons(buttonToSetup: self.continueButton)
        setup.setupNavigation()
        
        // Set bottom constraint of continue button to the 'aboveKeyboardConstraint'
        self.continueButtonBottomConstraint.constant = self.aboveKeyboardConstraint
        
        // Delegates
        self.firstNameInput.delegate = self
        self.lastNameInput.delegate = self
        
        for (key, value) in self.userInfo {
            print(key + ": " + value)
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWasShown(notification:)), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillDisappear), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.continueButtonBottomConstraint.constant = 30
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: Properties
    @IBOutlet weak var firstNameInput: UITextField!
    @IBOutlet weak var lastNameInput: UITextField!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var continueButtonBottomConstraint: NSLayoutConstraint!
    var userInfo: [String: String] = [:]
    var aboveKeyboardConstraint: CGFloat = CGFloat()
    lazy var alert: Alert = Alert(currentViewController: self)
    
    // MARK: Actions
    @IBAction func continueButtonTapped(_ sender: Any) {
        
        // Input Fields
        let firstName = firstNameInput.text!
        let lastName = lastNameInput.text!
        
        if firstName.isEmpty {
            
            alert.alertMessage(title: "Error", message: "First Name: this field is required")
            return
            
        } else if lastName.isEmpty {
            
            alert.alertMessage(title: "Error", message: "Last Name: this field is required")
            return
            
        } else {
            
            // Check if input is letters only
            if firstName.isNotAlpha || lastName.isNotAlpha {
                
                alert.alertMessage(title: "Error", message: "Please enter a valid first and last name.")
                return
                
            } else {
                
                // Pass in text to 'userInfo' dictionary and remove leading and trailing white space
                self.userInfo["firstName"] = firstName.trimmingCharacters(in: .whitespacesAndNewlines)
                self.userInfo["lastName"] = lastName.trimmingCharacters(in: .whitespacesAndNewlines)
                
            }
            
        }
        
    }
    
    // MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // Send user info to RegisterPhoneViewController
        let registerPhoneVC = segue.destination as? RegisterPhoneViewController
        registerPhoneVC?.userInfo = self.userInfo
        registerPhoneVC?.aboveKeyboardConstraint = self.aboveKeyboardConstraint
        
    }
    
}

extension RegisterNameViewController {
    
    // When return key (done key in our case) is pressed, this function is called
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == self.firstNameInput {
            
            // Go to Last Name text field when the Return (Next key in our case) is pressed
            self.lastNameInput.becomeFirstResponder()
            
        } else if textField == self.lastNameInput {
            
            // Send touch event to the continue button so that our data validation logic can be used
            self.continueButton.sendActions(for: .touchUpInside)
            
        }
        
        return true
        
    }
    
    @objc func keyboardWasShown(notification: NSNotification) {
        
        print("Keyboard shown from name view")
        
        guard let info = notification.userInfo else {
            return
        }
        
        guard let keyboardSize = info[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
            return
        }
        
        let keyboardFrame: CGRect = keyboardSize.cgRectValue
        
        UIView.animate(withDuration: 0.1, animations: {
            () -> Void in
            self.continueButtonBottomConstraint.constant = keyboardFrame.size.height + 20
            self.aboveKeyboardConstraint = self.continueButtonBottomConstraint.constant
        })
    }
    
    @objc func keyboardWillDisappear() {
        
        print("Keyboard hidden from name view")
        
        UIView.animate(withDuration: 0.1, animations: {
            () -> Void in
            self.continueButtonBottomConstraint.constant = 30
        })
    }
    
}


extension String {
    
    // Checks a string for alphabetical characters
    var isNotAlpha: Bool {
        return !isEmpty && (self.range(of: "[^a-zA-z\\s]", options: .regularExpression) != nil)
    }
    
}
