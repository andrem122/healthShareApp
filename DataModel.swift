//
//  LocationModel.swift
//  userLoginAndRegistration
//
//  Created by Andre Mashraghi on 12/11/18.
//  Copyright © 2018 Andre Mashraghi. All rights reserved.
//

import Foundation

class DataModel: NSObject {
    
    // MARK: Properties
    var userEmail: String?
    var userPassword: String?
    var userPhoneNumber: String?
    
    // Empty Constructor
    override init() {
        
    }
    
    init(userEmail: String, userPassword: String, userPhoneNumber: String) {
        self.userEmail = userEmail
        self.userPassword = userPassword
        self.userPhoneNumber = userPhoneNumber
    }
    
    override var description: String {
        return "Email: \(userEmail!), Password: \(userPassword!), Phone: \(userPhoneNumber!)"
    }
}
