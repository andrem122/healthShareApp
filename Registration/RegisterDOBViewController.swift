//
//  RegisterEmailViewController.swift
//  userLoginAndRegistration
//
//  Created by Andre Mashraghi on 12/8/18.
//  Copyright © 2018 Andre Mashraghi. All rights reserved.
//

import UIKit
import Foundation

class RegisterDOBViewController: UIViewController, UITextFieldDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        // Pop up the keyboard for the first field when the view loads
        self.DOBInput.becomeFirstResponder()
        
        let setup = Setup(viewController: self)
        setup.setupButtons(buttonToSetup: self.continueButton)
        setup.setupNavigation()
        
        // Set the delegate for 'emailInput' UITextField to current instance of this class
        self.DOBInput.delegate = self
        
        for (key, value) in self.userInfo {
            
            print(key + ": " + value)
            
        }
        
    }
    
    // MARK: Properties
    @IBOutlet weak var DOBInput: UITextField!
    @IBOutlet weak var continueButton: UIButton!
    var userInfo: [String: String] = [:]
    lazy var alert: Alert = Alert(currentViewController: self)
    
    // MARK: Actions
    @IBAction func continueButtonTapped(_ sender: Any) {
        
        // Input Fields
        let dateOfBirth: String = self.DOBInput.text!
        
        if dateOfBirth.isEmpty {
            
            alert.alertMessage(title: "Error", message: "Date of Birth: This field is required.")
            return
            
        } else if !(isVaildBirthDay(birthday: dateOfBirth)) {
            
            alert.alertMessage(title: "Error", message: "Please enter a valid date of birth.")
            return
            
        } else {
            
            // Calculate user's age
            let dateOfBirthArray = dateOfBirth.components(separatedBy: "/")
            let dateOfBirthArrayInt = dateOfBirthArray.map {Int($0)} // Convert the array of strings to integers
            
            let DOB = Calendar.current.date(from: DateComponents(year: dateOfBirthArrayInt[2], month: dateOfBirthArrayInt[0], day: dateOfBirthArrayInt[1]))
            let ageInt = DOB?.age
            let ageString = String(ageInt!)
            
            
            // Add info to 'userInfo' dictionary
            self.userInfo["dateOfBirth"] = dateOfBirth
            self.userInfo["age"] = ageString
            
            // Store data in database
            /*let url: URL = URL(string: "http://burnedoutmd.com/health-share-app/register.php")!
            
            var request: URLRequest = URLRequest(url: url)
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            request.httpMethod = "POST"
            
            let postString: String = "firstName=\(userInfo["firstName"] ?? "Andre")"
            request.httpBody = postString.data(using: .utf8)
            
            let task = URLSession.shared.dataTask(with: request) {
                
                data, response, error in
                
                // Check for fundamental network errors
                guard let data = data, error == nil else {
                    
                    print("Error: \(error!)")
                    return
                    
                }
                
                // Check for HTTP errors
                if let httpStatus = response as? HTTPURLResponse, let response = response, httpStatus.statusCode != 200 {
                    
                    print("HTTP status code is \(httpStatus.statusCode)")
                    print("Response: \(response)")
                    
                }
                
                if let responseString = String(data: data, encoding: .utf8) {
                    
                    print("Response: \(responseString)")
                    
                }
                
            }
            
            task.resume()
            */
        }
        
    }
    
    //MARK: Custom functions
    func isVaildBirthDay(birthday: String) -> Bool {
        
        // Remove '/' characters from the birthday input string
        let unformattedDOB = birthday.replacingOccurrences(of: "/", with: "")
        
        if unformattedDOB.count < 8 {
            
            // Check if the birthday is a valid format
            print("Birthday input is an invalid format because its count is less than 8")
            return false
            
        } else {
            
            // Split string into 3 pieces (month, day, and, year) into an array
            let birthdayArray = birthday.components(separatedBy: "/")
            let month = Int(birthdayArray[0])
            let day = Int(birthdayArray[1])
            let year = Int(birthdayArray[2])
            let currentYear = Calendar.current.component(.year, from: Date())
            
            if !(unformattedDOB.isNumeric) {
                
                // Check if birthday is all numeric
                print("Birthday input is not numeric")
                return false
                
            } else if !((1 ... 12).contains(month!)) {
                
                // Check if month is between 1 and 12
                print("Month is not between 1 and 12")
                return false
                
            } else if !((1 ... 31).contains(day!)) {
                
                // Check if day is between 1 and 31
                print("Day is not between 1 and 31")
                return false
                
            } else if !((1890 ... currentYear).contains(year!)) {
                
                print("Year is not between 1890 and \(currentYear)")
                return false
                
            }
            
        }
        
        return true
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // Send user info to next view
        let validateIdentityVC = segue.destination as! ValidateIdentityViewController
        validateIdentityVC.userInfo = self.userInfo
        
    }
    
    
}
extension RegisterDOBViewController {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == self.DOBInput {
            
            // Count string characters; DD (character count is 2) and DD/MM (character count is 5)
            if self.DOBInput.text?.count == 2 || self.DOBInput.text?.count == 5 {
                
                // Handle backspace being pressed
                if !(string == "") {
    
                    // Append the spacer text of '/'
                    self.DOBInput.text = self.DOBInput.text! + "/"
                    
                }
                
            }
            
            // Make sure the input does not exceed 9 characters
            return !(textField.text!.count > 9 && (string.count) > range.length)
            
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

extension Date {
    
    var age: Int {
        return Calendar.current.dateComponents([.year], from: self, to: Date()).year!
    }
    
}
