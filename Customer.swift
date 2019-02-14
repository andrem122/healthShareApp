//
//  Customer.swift
//  userLoginAndRegistration
//
//  Created by Mojgan on 2/14/19.
//  Copyright © 2019 Andre Mashraghi. All rights reserved.
//

import Foundation

class Customer {
    
    var id: Int
    var firstName: String
    var lastName: String
    var email: String
    var primaryPhone: String
    var dateOfBirth: DateComponents
    var socialSecurityNumber: String
    var address: String
    var usesDrugs: Bool
    var medicalConditions: String
    var planType: PlanType
    var dateJoined: DateComponents
    
    var age: Int {
        get {
            return Calendar.current.date(from: self.dateOfBirth)!.age
        }
    }
    
    var planPrice: NSDecimalNumber {
        get {
            if self.age > 50 {
                return NSDecimalNumber(integerLiteral: self.planType.rawValue + 50)
            }
            
            return NSDecimalNumber(integerLiteral: self.planType.rawValue)
        }
    }
    
    init(id: Int, firstName: String, lastName: String, email: String, primaryPhone: String, dateOfBirth: DateComponents, socialSecurityNumber: String, address: String, usesDrugs: Bool, medicalConditions: String, planType: PlanType, dateJoined: DateComponents) {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.primaryPhone = primaryPhone
        self.dateOfBirth = dateOfBirth
        self.socialSecurityNumber = socialSecurityNumber
        self.address = address
        self.usesDrugs = usesDrugs
        self.medicalConditions = medicalConditions
        self.planType = planType
        self.dateJoined = dateJoined
    }
    
    // Plan prices based on plan type
    enum PlanType: Int {
        case Gold = 100
        case Silver = 75
        case Bronze = 50
    }
    
}

