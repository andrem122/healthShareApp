//
//  ValidateIdentityViewController.swift
//  userLoginAndRegistration
//
//  Created by Andre Mashraghi on 12/8/18.
//  Copyright © 2018 Andre Mashraghi. All rights reserved.
//

import UIKit

class SelectPaymentViewController: UIViewController {
    
    func setupNavigation() {
        // Remove border of navigation bar
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        // Edit back button text
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
        
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

