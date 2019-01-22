//
//  RegisterEmailViewController.swift
//  userLoginAndRegistration
//
//  Created by Andre Mashraghi on 12/8/18.
//  Copyright © 2018 Andre Mashraghi. All rights reserved.
//

import UIKit

class MedicalConditionsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    func setupButtons() {
        
        // Make buttons round
        self.continueButton.layer.cornerRadius = 5
        self.continueButton.clipsToBounds = true
        
    }
    
    func setupNavigation() {
        
        // Remove border of navigation bar
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        // Edit back button text
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupButtons()
        setupNavigation()
        
        // Print user info
        for (value, key) in self.userInfo {
            print(key + ": " + value)
        }
        
    }
    
    // MARK: Properties
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var continueButton: UIButton!
    var userInfo = [String: String]()
    lazy var alert: Alert = Alert(currentViewController: self)
    var medicalConditions: [MedicalCondition] = [
        MedicalCondition(condition: medicalConditionNames.Achondroplasia.rawValue),
        MedicalCondition(condition: medicalConditionNames.AIDS.rawValue),
        MedicalCondition(condition: medicalConditionNames.ARDS.rawValue),
        MedicalCondition(condition: medicalConditionNames.Alzheimer.rawValue),
        MedicalCondition(condition: medicalConditionNames.BrainTumor.rawValue),
        MedicalCondition(condition: medicalConditionNames.Hypertension.rawValue),
        MedicalCondition(condition: medicalConditionNames.Melanoma.rawValue),
    ]
    
    enum medicalConditionNames: String {
        case Achondroplasia = "Achondroplasia"
        case AIDS = "Acquired Immune Deficiency Syndrome (AIDS)"
        case ARDS = "Acute Respiratory Distress Syndrome (ARDS)"
        case Alzheimer = "Alzheimer’s Disease"
        case BrainTumor = "Brain Tumors"
        case Hypertension = "Hypertension"
        case Melanoma = "Melanoma"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return medicalConditions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let medicalConditionCell = tableView.dequeueReusableCell(withIdentifier: "medicalConditionCell", for: indexPath) as! MedicalConditionCell
        
        // Set text of each cell to the corresponding element's 'condition' property in the medicalConditions array
        medicalConditionCell.medicalConditionLabel.text = medicalConditions[indexPath.row].condition
        
        // Set background image of the medicalCondition cell checkbox to the checked image if 'checked' property is true
        if medicalConditions[indexPath.row].checked {
            let checkBoxFilledImage = UIImage(contentsOfFile: "checkBoxFILLED.png")
            medicalConditionCell.checkBox.setImage(checkBoxFilledImage, for: .normal)
        } else {
            let checkBoxOutlineImage = UIImage(contentsOfFile: "checkBoxOUTLINE.png")
            medicalConditionCell.checkBox.setImage(checkBoxOutlineImage, for: .normal)
        }
        
        return medicalConditionCell
    }
    
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // Send user info to next view
        let getToKnowYouVC = segue.destination as! GetToKnowYouViewController
        getToKnowYouVC.userInfo = self.userInfo
        
    }
    
}

class MedicalCondition {
    var condition: String
    var checked = false
    
    init(condition: String) {
        self.condition = condition
    }
}
