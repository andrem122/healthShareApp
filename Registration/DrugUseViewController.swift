//
//  RegisterEmailViewController.swift
//  userLoginAndRegistration
//
//  Created by Andre Mashraghi on 12/8/18.
//  Copyright © 2018 Andre Mashraghi. All rights reserved.
//

import UIKit

class DrugUseViewController: UIViewController, UITextFieldDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        // Make buttons round
        self.continueButton.layer.cornerRadius = 5
        self.continueButton.clipsToBounds = true
        
        self.yesButton.layer.cornerRadius = 5
        self.yesButton.clipsToBounds = true
        
        self.noButton.layer.cornerRadius = 5
        self.noButton.clipsToBounds = true
        
        // Remove border of navigation bar
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        // Edit back button text
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        // Print user info
        for (value, key) in self.userInfo {
            print(key + ": " + value)
        }
        
    }
    
    // MARK: Properties
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var yesButton: UIButton!
    @IBOutlet weak var noButton: UIButton!
    @IBOutlet weak var continueButton: UIButton!
    var userInfo = [String: String]()
    lazy var alert: Alert = Alert(currentViewController: self)
    
    // MARK: Actions
    @IBAction func buttonTapped(_ sender: UIButton) {
        
        switch sender.tag {
            case 0:
                print("'No' button pressed")
                self.userInfo["usesDrugs"] = "No"
                showContinueButton()
            case 1:
                print("'Yes' button pressed")
                self.userInfo["usesDrugs"] = "Yes"
                showContinueButton()
            case 2:
                print("'Continue' button pressed")
            default:
                print("No buttons were pressed")
        }
        
    }
    
    //MARK: Custom Methods
    func showContinueButton() {
        self.yesButton.isHidden = true
        self.noButton.isHidden = true
        self.continueButton.isHidden = false
        
        questionLabel.text = "Please press the button to continue."
        print(self.userInfo)
        
    }
    
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // Send user info to next view
        let medicalConditionsVC = segue.destination as! MedicalConditionsViewController
        medicalConditionsVC.userInfo = self.userInfo
        
    }
    
}
