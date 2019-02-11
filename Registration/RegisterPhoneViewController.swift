//
//  RegisterPhoneViewController.swift
//  userLoginAndRegistration
//
//  Created by Andre Mashraghi on 12/20/18.
//  Copyright © 2018 Andre Mashraghi. All rights reserved.
//

import UIKit

class RegisterPhoneViewController: UIViewController, UITextFieldDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Pop up the keyboard for the first field when the view loads
        self.phoneNumberInput.becomeFirstResponder()
        
        let setup = Setup(viewController: self)
        setup.setupButtons(buttonToSetup: self.continueButton)
        setup.setupNavigation()
        
        // Set the delegate for the phoneNumberInput UITextField to current instance of this class
        self.phoneNumberInput.delegate = self
        
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
    
    //MARK: Properties
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var phoneNumberInput: UITextField!
    @IBOutlet weak var continueButtonBottomConstraint: NSLayoutConstraint!
    var aboveKeyboardConstraint: CGFloat = CGFloat()
    var userInfo = [String: String]()
    var phoneNumber: String = ""
    lazy var alert: Alert = Alert(currentViewController: self)
    
    //MARK: Actions
    @IBAction func continueButtonTapped(_ sender: Any) {
        
        // Input fields
        let phoneNumber = phoneNumberInput.text!
        let unformattedPhoneNumber = phoneNumber.replacingOccurrences(of: "[\\(\\)\\s-]", with: "", options: .regularExpression, range: nil)
        
        // Check for empty fields
        if phoneNumber.isEmpty {
            
            alert.alertMessage(title: "Error", message: "Phone Number: this field is required")
            return
            
        } else if !(unformattedPhoneNumber.isNumeric) || unformattedPhoneNumber.count < 10 {
            
            // Check if input is only numbers and at least 10 characters
            alert.alertMessage(title: "Error", message: "Please enter a valid phone number.")
            return
            
        } else {
            
            // If all checks pass, add phoneNumber to the userInfo dictionary
            self.userInfo["phoneNumber"] = phoneNumber
            
        }
        
        
    }
    
    //MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // Send user info to RegisterPhoneViewController
        let registerDOBVC = segue.destination as? RegisterDOBViewController
        registerDOBVC?.userInfo = self.userInfo
        registerDOBVC?.aboveKeyboardConstraint = self.aboveKeyboardConstraint
        
    }
        
}

extension RegisterPhoneViewController {
    
    // The function provided by the delegator, UITextField
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var fullString = textField.text ?? ""
        fullString.append(string)
        if range.length == 1 {
            textField.text = format(phoneNumber: fullString, shouldRemoveLastDigit: true)
        } else {
            textField.text = format(phoneNumber: fullString)
        }
        return false
    }
    
    // Formats the live input into the text field into the format (555) 555-5555
    func format(phoneNumber: String, shouldRemoveLastDigit: Bool = false) -> String {
        guard !phoneNumber.isEmpty else { return "" }
        guard let regex = try? NSRegularExpression(pattern: "[\\s-\\(\\)]", options: .caseInsensitive) else { return "" }
        let r = NSString(string: phoneNumber).range(of: phoneNumber)
        var number = regex.stringByReplacingMatches(in: phoneNumber, options: .init(rawValue: 0), range: r, withTemplate: "")
        
        if number.count > 10 {
            let tenthDigitIndex = number.index(number.startIndex, offsetBy: 10)
            number = String(number[number.startIndex..<tenthDigitIndex])
        }
        
        if shouldRemoveLastDigit {
            let end = number.index(number.startIndex, offsetBy: number.count-1)
            number = String(number[number.startIndex..<end])
        }
        
        if number.count < 7 {
            let end = number.index(number.startIndex, offsetBy: number.count)
            let range = number.startIndex..<end
            number = number.replacingOccurrences(of: "(\\d{3})(\\d+)", with: "($1) $2", options: .regularExpression, range: range)
            
        } else {
            let end = number.index(number.startIndex, offsetBy: number.count)
            let range = number.startIndex..<end
            number = number.replacingOccurrences(of: "(\\d{3})(\\d{3})(\\d+)", with: "($1) $2-$3", options: .regularExpression, range: range)
        }
        
        return number
    }
    
    @objc func keyboardWasShown(notification: NSNotification) {
        
        print("Keyboard shown from phone view")
        
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
        
        print("Keyboard hidden from phone view")
        
        UIView.animate(withDuration: 0.1, animations: {
            () -> Void in
            self.continueButtonBottomConstraint.constant = 30
        })
    }
    
}

extension String {
    
    var isNumeric: Bool {
        
        // Returns false or true if the string is not an integer or if it is
        return Int(self) != nil
        
    }
    
}
