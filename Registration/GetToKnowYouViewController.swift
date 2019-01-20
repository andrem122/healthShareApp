//
//  ValidateIdentityViewController.swift
//  userLoginAndRegistration
//
//  Created by Andre Mashraghi on 12/8/18.
//  Copyright © 2018 Andre Mashraghi. All rights reserved.
//

import UIKit

class GetToKnowYouViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        // Make 'continue' button round
        self.continueButton.layer.cornerRadius = 5
        self.continueButton.clipsToBounds = true
        
        // Remove border of navigation bar
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        // Edit back button text
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        for (key, value) in self.userInfo {
            print(key + ": " + value)
        }
        
    }
    
    // MARK: Properties
    @IBOutlet weak var continueButton: UIButton!
    var userInfo = [String: String]()
    
    // MARK: - Navigation
    /*override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // Send user info to next view
        let registerSocialSecurityVC = segue.destination as! RegisterSSNViewController
        registerSocialSecurityVC.userInfo = self.userInfo
        
    }*/
    
}

