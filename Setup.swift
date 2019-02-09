//
//  Setup.swift
//  userLoginAndRegistration
//
//  Created by Mojgan on 2/7/19.
//  Copyright © 2019 Andre Mashraghi. All rights reserved.
//
import UIKit

class Setup {
    var viewController: UIViewController
    
    init(viewController: UIViewController) {
        self.viewController = viewController
    }
    
    // Setup Buttons
    func setupButtons(buttonToSetup button: UIButton) {
        // Make 'continue' button round
        button.layer.cornerRadius = 5
        button.clipsToBounds = true
    }
    
    // Setup Navigation
    func setupNavigation() {
        // Remove border of navigation bar
        self.viewController.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.viewController.navigationController?.navigationBar.shadowImage = UIImage()
        
        // Edit back button text
        self.viewController.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
    }
    
}
