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
        
        let setup = Setup(viewController: self)
        setup.setupButtons(buttonToSetup: self.continueButton)
        setup.setupNavigation()
        
        // Print user info
        for (key, value) in self.userInfo {
            print(key + ": " + value)
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWasShown(notification:)), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillDisappear), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.continueButtonBottomConstraint.constant = 30
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: Properties
    @IBOutlet weak var addressInput: UITextField!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var continueButtonBottomConstraint: NSLayoutConstraint!
    var aboveKeyboardConstraint: CGFloat = CGFloat()
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

extension RegisterAddressViewController {
    
    @objc func keyboardWasShown(notification: NSNotification) {
        
        print("Keyboard shown from address view")
        
        guard let info = notification.userInfo else {
            return
        }
        
        guard let keyboardSize = info[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
            return
        }
        
        let keyboardFrame: CGRect = keyboardSize.cgRectValue
        
        UIView.animate(withDuration: 0.1, animations: {
            () -> Void in
            self.continueButtonBottomConstraint.constant = keyboardFrame.size.height + 20
            self.aboveKeyboardConstraint = self.continueButtonBottomConstraint.constant
        })
    }
    
    @objc func keyboardWillDisappear() {
        
        print("Keyboard hidden from address view")
        
        UIView.animate(withDuration: 0.1, animations: {
            () -> Void in
            self.continueButtonBottomConstraint.constant = 30
        })
    }
    
}
