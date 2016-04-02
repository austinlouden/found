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
    var places = [GMSPlaceLikelihood]()
    let tableView = UITableView()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        tableView.dataSource = self
        tableView.delegate = self
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
                self?.places = placeLikelihoodList.likelihoods
                self?.tableView.reloadData()
            }
        })
    }
}

// MARK: - UITableViewDatasource
extension PlaceSelectorViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.places.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = places[indexPath.row].place.name
        return cell
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
        
    }
}
