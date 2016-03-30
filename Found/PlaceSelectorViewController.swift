//
//  PlaceSelectorViewController.swift
//  Found
//
//  Created by Austin Louden on 3/29/16.
//  Copyright © 2016 Austin Louden. All rights reserved.
//

import GoogleMaps

class PlaceSelectorViewController: UIViewController {
    
    let placesClient = GMSPlacesClient()
    let tableView = UITableView()
    
    var places = NSArray()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        tableView.dataSource = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        self.view.backgroundColor = UIColor.whiteColor()
        
        tableView.frame = self.view.frame
        tableView.contentInset = UIEdgeInsetsMake(UIApplication.sharedApplication().statusBarFrame.size.height, 0, 0, 0)
        self.view.addSubview(tableView)

        placesClient.currentPlaceWithCallback({ [weak self]
            (placeLikelihoodList: GMSPlaceLikelihoodList?, error: NSError?) -> Void in

            if let placeLikelihoodList = placeLikelihoodList {
                self?.places = NSArray.init(array: placeLikelihoodList.likelihoods)
                self?.tableView.reloadData()
            }
        })
    }
}

// MARK: - UITableViewDatasource
extension PlaceSelectorViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.places.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = places.objectAtIndex(indexPath.row).place.name
        return cell
    }
}
