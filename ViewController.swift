//
//  ViewController.swift
//  userLoginAndRegistration
//
//  Created by Andre Mashraghi on 12/7/18.
//  Copyright © 2018 Andre Mashraghi. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, HomeModelProtocol {
    
    // MARK: Properties
    var feedItems: NSArray = NSArray()
    var data: DataModel = DataModel()
    @IBOutlet weak var listTableView: UITableView!
    
    
    // MARK: Methods
    func itemsDownloaded(items: NSArray) {
        feedItems = items
        self.listTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feedItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Get cell
        let cellIdentifier = "BasicCell"
        let myCell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)!
        let item: DataModel = feedItems[indexPath.row] as! DataModel
        myCell.textLabel!.text = item.userEmail
        
        return myCell
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set delegates and initialize 'HomeModel'
        self.listTableView.delegate = self
        self.listTableView.dataSource = self
        
        let homeModel = HomeModel()
        homeModel.delegate = self
        homeModel.downloadItems()
    }
    
    // Redirect to login view if user reaches protected page
    override func viewDidAppear(_ animated: Bool) {
        self.performSegue(withIdentifier: "loginView", sender: self)
    }
    
}

