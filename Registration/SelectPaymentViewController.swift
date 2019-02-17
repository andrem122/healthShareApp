//
//  ValidateIdentityViewController.swift
//  userLoginAndRegistration
//
//  Created by Andre Mashraghi on 12/8/18.
//  Copyright © 2018 Andre Mashraghi. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class SelectPaymentViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let setup = Setup(viewController: self)
        setup.setupNavigation()
        
        print(self.userInfo)
        
        var loginInfo = [String: String]()
        loginInfo["email"] = self.userInfo["email"]
        loginInfo["password"] = self.userInfo["password"]
        loginInfo["PHPAuthenticationUsername"] = self.userInfo["PHPAuthenticationUsername"]
        loginInfo["PHPAuthenticationPassword"] = self.userInfo["PHPAuthenticationPassword"]
        
        Timer.scheduledTimer(withTimeInterval: 2.0, repeats: false, block: {
            timer in
            // Get data from database
            let url: URL = URL(string: "http://burnedoutmd.com/health-share-app/login.php")!
            AF.request(url, method: .post, parameters: loginInfo).responseString {
                response in
                print(response)
                
                // Get status code
                if let status = response.response?.statusCode {
                    switch status {
                    case 200:
                        print("POST request has succeeded!")
                    default:
                        print("Error: \(status)")
                    }
                }
                
                // Parse JSON return value
                if let json = response.result.value {
                    if let userData = json.data(using: .utf8) {
                        do {
                            if let userInfo = try JSONSerialization.jsonObject(with: userData, options: .allowFragments) as? [String: Any] {
                                // Input values into customer object
                                let id = userInfo["id"] as! Int
                                let firstName = userInfo["firstName"] as! String
                                let lastName = userInfo["lastName"] as! String
                                let email = userInfo["email"] as! String
                                let primaryPhone = userInfo["primaryPhone"] as! String
                                let dateOfBirthList = (userInfo["dateOfBirth"] as! String).components(separatedBy: "-").map{Int($0)}
                                let dateOfBirth = DateComponents(year: dateOfBirthList[0], month: dateOfBirthList[1], day: dateOfBirthList[2])
                                let socialSecurityNumber = userInfo["socialSecurityNumber"] as! String
                                let address = userInfo["address"] as! String
                                let usesDrugs = false
                                let medicalConditions = (userInfo["medicalConditions"] as! String).components(separatedBy: ", ")
                                // Convert date string to date component type
                                let dateJoinedString = userInfo["dateJoined"] as! String
                                
                                //Create Customer object with values from JSON
                                let customer = Customer(id: id, firstName: firstName, lastName: lastName, email: email, primaryPhone: primaryPhone, dateOfBirth: dateOfBirth, socialSecurityNumber: socialSecurityNumber, address: address, usesDrugs: usesDrugs, medicalConditions: medicalConditions, planType: .Gold, dateJoined: dateJoinedString)
                                
                            } else {
                                print("Bad JSON")
                            }
                        } catch let error as NSError {
                            print(error)
                        }
                    }
                }
                
            }
        })
        
    }
    
    // MARK: Properties
    var userInfo = [String: String]()
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
    }
    
}

