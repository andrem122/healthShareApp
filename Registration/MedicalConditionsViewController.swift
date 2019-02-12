//
//  RegisterEmailViewController.swift
//  userLoginAndRegistration
//
//  Created by Andre Mashraghi on 12/8/18.
//  Copyright © 2018 Andre Mashraghi. All rights reserved.
//

import UIKit
import Alamofire

class MedicalConditionsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let setup = Setup(viewController: self)
        setup.setupButtons(buttonToSetup: self.continueButton)
        setup.setupNavigation()
        
        // Print user info
        for (key, value) in self.userInfo {
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
        MedicalCondition(condition: MedicalConditionNames.Achondroplasia.rawValue),
        MedicalCondition(condition: MedicalConditionNames.AIDS.rawValue),
        MedicalCondition(condition: MedicalConditionNames.ARDS.rawValue),
        MedicalCondition(condition: MedicalConditionNames.Arthritis.rawValue),
        MedicalCondition(condition: MedicalConditionNames.Alzheimer.rawValue),
        MedicalCondition(condition: MedicalConditionNames.BrainTumor.rawValue),
        MedicalCondition(condition: MedicalConditionNames.Cancer.rawValue),
        MedicalCondition(condition: MedicalConditionNames.Diabetes.rawValue),
        MedicalCondition(condition: MedicalConditionNames.HeartDisease.rawValue),
        MedicalCondition(condition: MedicalConditionNames.Hypertension.rawValue),
        MedicalCondition(condition: MedicalConditionNames.Melanoma.rawValue),
        MedicalCondition(condition: MedicalConditionNames.Obesity.rawValue),
    ]
    
    enum MedicalConditionNames: String {
        case Achondroplasia = "Achondroplasia"
        case AIDS = "Acquired Immune Deficiency Syndrome"
        case ARDS = "Acute Respiratory Distress Syndrome"
        case Arthritis = "Arthritis"
        case Alzheimer = "Alzheimer’s Disease"
        case BrainTumor = "Brain Tumors"
        case Cancer = "Cancer"
        case Diabetes = "Diabetes"
        case HeartDisease = "Heart Disease"
        case Hypertension = "Hypertension"
        case Melanoma = "Melanoma"
        case Obesity = "Obesity"
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return medicalConditions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let medicalConditionCell = tableView.dequeueReusableCell(withIdentifier: "medicalConditionCell", for: indexPath) as! MedicalConditionCell
        
        // Set text of each cell to the corresponding element's 'condition' property in the medicalConditions array
        medicalConditionCell.medicalConditionLabel.text = medicalConditions[indexPath.row].condition
        
        // Set background image of the medicalCondition cell checkbox to the checked image if 'checked' property is true
        if medicalConditions[indexPath.row].checked == true {
            let checkBoxFilledImage = UIImage(named: "heartChecked")
            medicalConditionCell.checkBox.setImage(checkBoxFilledImage, for: .normal)
        } else {
            let checkBoxOutlineImage = UIImage(named: "heartUnchecked")
            medicalConditionCell.checkBox.setImage(checkBoxOutlineImage, for: .normal)
        }
        
        return medicalConditionCell
    }
    
    // This function is called when a row in the table view is tapped on or selected
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let medicalConditionCell = tableView.dequeueReusableCell(withIdentifier: "medicalConditionCell", for: indexPath) as! MedicalConditionCell
        
        // If an item is already checked and the user taps on it, set 'checked' property to false and change image to outline checkbox
        if medicalConditions[indexPath.row].checked == true {
            medicalConditions[indexPath.row].checked = false
            let checkBoxOutlineImage = UIImage(named: "heartUnchecked")
            medicalConditionCell.checkBox.setImage(checkBoxOutlineImage, for: .normal)
        } else {
            medicalConditions[indexPath.row].checked = true
            let checkBoxFilledImage = UIImage(named: "heartChecked")
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
        let selectPaymentTypeVC = segue.destination as? SelectPaymentViewController
        selectPaymentTypeVC?.userInfo = self.userInfo
        
        // Add PHP authentication credentials to userInfo dictionary
        let phpAuthenticationCredentials = PHPAuthenticationCredentials()
        self.userInfo["PHPAuthenticationUsername"] = phpAuthenticationCredentials.username
        self.userInfo["PHPAuthenticationPassword"] = phpAuthenticationCredentials.password
        
        // Send data to database
        let url: URL = URL(string: "http://burnedoutmd.com/health-share-app/register.php")!
        AF.request(url, method: .post, parameters: self.userInfo).responseString {
            response in
            print(response)
        }
        
    }
    
}

class MedicalCondition {
    var condition: String
    var checked = false
    
    init(condition: String) {
        self.condition = condition
    }
}
