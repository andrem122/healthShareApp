//
//  HomeModel.swift
//  userLoginAndRegistration
//
//  Created by Andre Mashraghi on 12/11/18.
//  Copyright © 2018 Andre Mashraghi. All rights reserved.
//

import Foundation

protocol HomeModelProtocol: class {
    func itemsDownloaded(items: NSArray)
}

class HomeModel: NSObject, URLSessionDataDelegate {
    
    // Properties
    weak var delegate: HomeModelProtocol!
    var data = Data()
    let urlPath: String = "http://burnedoutmd.com/health-share-app/service.php"
    
    // Methods
    func parseJSON(data: Data) {
        var jsonResult = NSArray()
        
        do {
            jsonResult = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as! NSArray
        } catch let error as NSError {
            print(error)
        }
        
        var jsonElement = NSDictionary()
        let userDetailsMulti = NSMutableArray()
        
        for i in 0 ..< jsonResult.count {
            jsonElement = jsonResult[i] as! NSDictionary
            let userDetails: DataModel = DataModel()
            
            if let userEmail = jsonElement["email"] as? String,
                let userPassword = jsonElement["password"] as? String,
                let userPhoneNumber = jsonElement["primaryPhone"] as? String {
                
                userDetails.userEmail = userEmail
                userDetails.userPassword = userPassword
                userDetails.userPhoneNumber = userPhoneNumber
                
            }
            
            userDetailsMulti.add(userDetails)
        }
        
        DispatchQueue.main.async(execute: {
            () -> Void in
            self.delegate.itemsDownloaded(items: userDetailsMulti)
        })
    }
    
    func downloadItems() {
        let url: URL = URL(string: urlPath)!
        let defaultSession = Foundation.URLSession(configuration: URLSessionConfiguration.default)
        
        
        
        let task = defaultSession.dataTask(with: url) {
            (data, response, error) in
            if error != nil {
                print("Failed to download data.")
            } else {
                print("Data has been downloaded.")
                self.parseJSON(data: data!)
            }
        }
        
        task.resume()
    }
}
