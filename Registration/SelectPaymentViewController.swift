//
//  ValidateIdentityViewController.swift
//  userLoginAndRegistration
//
//  Created by Andre Mashraghi on 12/8/18.
//  Copyright © 2018 Andre Mashraghi. All rights reserved.
//

import UIKit

class SelectPaymentViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let setup = Setup(viewController: self)
        setup.setupNavigation()
        
        for (key, value) in self.userInfo {
            print(key + ": " + value)
        }
        
    }
    
    // MARK: Properties
    var userInfo = [String: String]()
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // Send user info to next view
        let drugUseVC = segue.destination as! DrugUseViewController
        drugUseVC.userInfo = self.userInfo
        
    }
    
}

