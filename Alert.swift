//
//  Alert.swift
//  userLoginAndRegistration
//
//  Created by Andre Mashraghi on 12/22/18.
//  Copyright © 2018 Andre Mashraghi. All rights reserved.
//

import UIKit

class Alert {
    
    // MARK: Properties
    var currentViewController: UIViewController?
    
    init(currentViewController viewController: UIViewController) {
        self.currentViewController = viewController
    }
    
    // Displays an alert message with a custom title and message
    func alertMessage(title: String, message: String, handler: ((UIAlertAction) -> Void)? = nil) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let alertAction = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: handler)
        
        // Add action button to alert
        alert.addAction(alertAction)
        if let viewController = self.currentViewController {
            viewController.present(alert, animated: true, completion: nil)
        }
        
    }
    
}
