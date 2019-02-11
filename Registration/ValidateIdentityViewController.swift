//
//  ValidateIdentityViewController.swift
//  userLoginAndRegistration
//
//  Created by Andre Mashraghi on 12/8/18.
//  Copyright © 2018 Andre Mashraghi. All rights reserved.
//

import UIKit

class ValidateIdentityViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let setup = Setup(viewController: self)
        setup.setupButtons(buttonToSetup: self.continueButton)
        setup.setupNavigation()
        
        for (key, value) in self.userInfo {
            print(key + ": " + value)
        }
        
    }
    
    // MARK: Properties
    @IBOutlet weak var continueButton: UIButton!
    var aboveKeyboardConstraint: CGFloat = CGFloat()
    var userInfo: [String: String] = [:]
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // Send user info to next view
        let registerSocialSecurityVC = segue.destination as? RegisterSSNViewController
        registerSocialSecurityVC?.userInfo = self.userInfo
        registerSocialSecurityVC?.aboveKeyboardConstraint = self.aboveKeyboardConstraint
        
    }
    
}

