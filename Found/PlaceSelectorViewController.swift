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
    
    let maxPlaceCount = 3
    let footerHeight: CGFloat = 32
    var shouldShowAllPlaceSuggestions = false
    
    var places = [GMSPlaceLikelihood]()
    
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
        self.title = "Save this place"

        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .None
        tableView.showsVerticalScrollIndicator = false
        tableView.registerClass(PlaceSelectorTableViewCell.self, forCellReuseIdentifier: "placeCell")
        
        tableView.snp_makeConstraints { (make) in
            make.edges.equalTo(self.view)
        }
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
        tableView.contentInset = UIEdgeInsetsMake(8, 0, 0, 0)
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
    
    func seeMorePressed() {
        shouldShowAllPlaceSuggestions = true
        tableView.reloadSections(NSIndexSet(index: 0), withRowAnimation: .Fade)
    }
}

// MARK: - UITableViewDatasource
extension PlaceSelectorViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (shouldShowAllPlaceSuggestions == false && self.places.count >= maxPlaceCount) {
            return maxPlaceCount
        }
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
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if (shouldShowAllPlaceSuggestions == false && self.places.count > maxPlaceCount) {
            let footerView = PlaceSelectorFooterView(frame: CGRectMake(0, 0, tableView.frame.size.width, footerHeight))
            let seeMoreText = String(format: "See %d more suggestions", self.places.count - maxPlaceCount)
            
            footerView.seeMoreButton.setAttributedTitle(NSAttributedString.attributedStringWithFont(UIFont.mediumBoldFont(), string: seeMoreText, color: UIColor.foundDarkGrayColor()), forState: .Normal)
            footerView.seeMoreButton.addTarget(self, action: #selector(seeMorePressed), forControlEvents: .TouchUpInside)
            
            return footerView
        }
        return nil
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if (shouldShowAllPlaceSuggestions == false && self.places.count > maxPlaceCount) {
            return footerHeight
        }
        
        return 0
    }
}
