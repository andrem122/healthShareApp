//
//  RegisterEmailViewController.swift
//  userLoginAndRegistration
//
//  Created by Andre Mashraghi on 12/8/18.
//  Copyright © 2018 Andre Mashraghi. All rights reserved.
//

import UIKit
import GooglePlaces

var resultsViewController: GMSAutocompleteResultsViewController?
var searchController: UISearchController?

class RegisterAddressViewController: UIViewController, UITextFieldDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        // Pop up the keyboard for the first field when the view loads
        self.addressInput.becomeFirstResponder()
        
        // Make 'continue' button round
        self.continueButton.layer.cornerRadius = 5
        self.continueButton.clipsToBounds = true
        
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
    @IBOutlet weak var addressInput: UITextField!
    @IBOutlet weak var continueButton: UIButton!
    var userInfo = [String: String]()
    lazy var alert: Alert = Alert(currentViewController: self)
    
    // MARK: Actions
    @IBAction func continueButtonTapped(_ sender: Any) {
        
        // Input Fields
        let address: String = self.addressInput.text!
        
        if address.isEmpty {
            
            alert.alertMessage(title: "Error", message: " Residential Address: This field is required.")
            
        } else {
            
            // Add DOB to 'userInfo' dictionary
            self.userInfo["address"] = address
            
        }
        
    }
    
    
    @IBAction func addressInputEditingChanged(_ sender: UITextField) {
        
        // Input Fields
        let address: String = self.addressInput.text!
        
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        self.present(autocompleteController, animated: true, completion: {
            let views = autocompleteController.view.subviews
            let subviewsOfSubview = views.first!.subviews
            let subOfNavTransitionView = subviewsOfSubview[1].subviews
            let subOfContentView = subOfNavTransitionView[2].subviews
            let searchBar = subOfContentView[0] as! UISearchBar
            searchBar.text = address
            searchBar.delegate?.searchBar?(searchBar, textDidChange: address)
        })
        
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // Send user info to next view
        let getToKnowYouVC = segue.destination as! GetToKnowYouViewController
        getToKnowYouVC.userInfo = self.userInfo
        
    }
    
}

extension RegisterAddressViewController: GMSAutocompleteViewControllerDelegate {
    
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        
        self.dismiss(animated: true, completion: {
            // Set address input text to what the user selected in the search results container
            self.addressInput.text = place.formattedAddress
            self.userInfo["address"] = place.formattedAddress
        })
        
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
}
