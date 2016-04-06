//
//  PlaceSelectorViewController.swift
//  Found
//
//  Created by Austin Louden on 3/29/16.
//  Copyright © 2016 Austin Louden. All rights reserved.
//

import GoogleMaps
import RealmSwift

class PlaceSelectorViewController: UIViewController {
    
    let placesClient = GMSPlacesClient()
    let tableView = UITableView()
    let tableViewCellHeight: CGFloat = 60.0
    
    var places = [GMSPlaceLikelihood]()
    
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
        self.title = "Save this place"

        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .None
        tableView.registerClass(PlaceSelectorTableViewCell.self, forCellReuseIdentifier: "placeCell")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        self.view.backgroundColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.translucent = false
        
        let closeButton = UIBarButtonItem(title: "Close", style: .Plain, target: self, action: #selector(closePressed))
        closeButton.setTitleTextAttributes(NSAttributedString.navigationButtonAttributes(), forState: .Normal)
        self.navigationItem.leftBarButtonItem = closeButton
        
        tableView.frame = self.view.frame
        tableView.contentInset = UIEdgeInsetsMake(16, 0, 0, 0)
        self.view.addSubview(tableView)

        placesClient.currentPlaceWithCallback({ [weak self]
            (placeLikelihoodList: GMSPlaceLikelihoodList?, error: NSError?) -> Void in

            if let placeLikelihoodList = placeLikelihoodList {
                self?.places = placeLikelihoodList.likelihoods
                self?.tableView.reloadData()
            }
        })
    }
    
    func closePressed() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}

// MARK: - UITableViewDatasource
extension PlaceSelectorViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.places.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = PlaceSelectorTableViewCell()
        let place = self.places[indexPath.row].place
        
        cell.nameLabel.attributedText = NSAttributedString.attributedStringWithFont(UIFont.largeBoldFont(), string: place.name, color: UIColor.foundDarkGrayColor())
        
        if let address = place.formattedAddress {
             cell.addressLabel.attributedText = NSAttributedString.attributedStringWithFont(UIFont.smallRegularFont(), string: address, color: UIColor.foundLightGrayColor())
        } else {
            cell.addressLabel.attributedText = NSAttributedString.attributedStringWithFont(UIFont.smallRegularFont(), string: "No address available", color: UIColor.foundLightGrayColor())
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return tableViewCellHeight
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let gmsPlace : GMSPlace = places[indexPath.row].place
        
        let place = Place()
        place.name = gmsPlace.name
        place.placeID = gmsPlace.placeID
        place.longitude = gmsPlace.coordinate.longitude
        place.latitude = gmsPlace.coordinate.latitude
        place.formattedAddress = gmsPlace.formattedAddress
        place.website = gmsPlace.website?.absoluteString
        
        let realm = try! Realm()
        try! realm.write {
            realm.add(place)
        }
        
        self.closePressed()
    }
}
