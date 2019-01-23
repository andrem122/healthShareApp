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
    @IBOutlet weak var medicalConditionsTable: UITableView!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var continueButton: UIButton!
    var userInfo = [String: String]()
    lazy var alert: Alert = Alert(currentViewController: self)
    let medicalConditions: [MedicalCondition] = [
        MedicalCondition(condition: medicalConditionNames.Achondroplasia.rawValue),
        MedicalCondition(condition: medicalConditionNames.AIDS.rawValue),
        MedicalCondition(condition: medicalConditionNames.ARDS.rawValue),
        MedicalCondition(condition: medicalConditionNames.Alzheimer.rawValue),
        MedicalCondition(condition: medicalConditionNames.BrainTumor.rawValue),
        MedicalCondition(condition: medicalConditionNames.Hypertension.rawValue),
        MedicalCondition(condition: medicalConditionNames.Melanoma.rawValue),
        MedicalCondition(condition: medicalConditionNames.HeartDisease.rawValue),
    ]
    
    enum medicalConditionNames: String {
        case Achondroplasia = "Achondroplasia"
        case AIDS = "Acquired Immune Deficiency Syndrome (AIDS)"
        case ARDS = "Acute Respiratory Distress Syndrome (ARDS)"
        case Alzheimer = "Alzheimer’s Disease"
        case BrainTumor = "Brain Tumors"
        case Hypertension = "Hypertension"
        case Melanoma = "Melanoma"
        case HeartDisease = "Heart Disease"
    }
    
    //MARK: Actions
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return medicalConditions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let medicalConditionCell = tableView.dequeueReusableCell(withIdentifier: "medicalConditionCell", for: indexPath) as! MedicalConditionCell
        
        // Set text of each cell to the corresponding element's 'condition' property in the medicalConditions array
        medicalConditionCell.medicalConditionLabel.text = medicalConditions[indexPath.row].condition
        
        // Set background image of the medicalCondition cell checkbox to the checked image if 'checked' property is true
        if medicalConditions[indexPath.row].checked == true {
            let checkBoxFilledImage = UIImage(named: "checkBoxFILLED")
            medicalConditionCell.checkBox.setImage(checkBoxFilledImage, for: .normal)
        } else {
            let checkBoxOutlineImage = UIImage(named: "checkBoxOUTLINE")
            medicalConditionCell.checkBox.setImage(checkBoxOutlineImage, for: .normal)
        }
        
        return medicalConditionCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let medicalConditionCell = tableView.dequeueReusableCell(withIdentifier: "medicalConditionCell", for: indexPath) as! MedicalConditionCell
        
        // If an item is already checked and the user taps on it, set 'checked' property to false and change image to outline checkbox
        if medicalConditions[indexPath.row].checked == true {
            medicalConditions[indexPath.row].checked = false
            let checkBoxOutlineImage = UIImage(named: "checkBoxOUTLINE")
            medicalConditionCell.checkBox.setImage(checkBoxOutlineImage, for: .normal)
        } else {
            medicalConditions[indexPath.row].checked = true
            let checkBoxFilledImage = UIImage(named: "checkBoxFILLED")
            medicalConditionCell.checkBox.setImage(checkBoxFilledImage, for: .normal)
        }
        
        self.medicalConditionsTable.reloadData()
        
    }
    
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get medical conditions selected by the user
        let selectedMedicalConditions = medicalConditions.filter {$0.checked == true}
        let selectedMedicalConditionsString = selectedMedicalConditions.map {$0.condition}.joined(separator: ", ")
        self.userInfo["medicalConditions"] = selectedMedicalConditionsString
        
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
