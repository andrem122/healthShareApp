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
        
        // Do any additional setup after loading the view.
        
        // Pop up the keyboard for the first field when the view loads
        self.phoneNumberInput.becomeFirstResponder()
        
        // Make 'continue' button round
        continueButton.layer.cornerRadius = 5
        continueButton.clipsToBounds = true
        
        // Edit back button text
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        for (key, value) in self.userInfo {
            print(key + ": " + value)
        }
        
        // Set the delegate for the phoneNumberInput UITextField to current instance of this class
        self.phoneNumberInput.delegate = self
    }
    
    //MARK: Properties
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var phoneNumberInput: UITextField!
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
        let registerDOBVC = segue.destination as! RegisterDOBViewController
        registerDOBVC.userInfo = self.userInfo
        
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
    
}

extension String {
    
    var isNumeric: Bool {
        
        // Returns false or true if the string is not an integer or if it is
        return Int(self) != nil
        
    }
    
}
