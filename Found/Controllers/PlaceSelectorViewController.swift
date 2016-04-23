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
    let realm = try! Realm()
    let tableView = UITableView()
    
    let maxPlaceCount = 3
    let footerHeight: CGFloat = 42
    let placesSection = 0
    let listsSection = 1
    
    var shouldShowAllPlaceSuggestions = false
    var places = [GMSPlaceLikelihood]()
    var lists: Results<PlaceList>!
    
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
        self.title = "Select a place"
        
        let closeButton = UIBarButtonItem(title: "Close", style: .Plain, target: self, action: #selector(closePressed))
        closeButton.setTitleTextAttributes(NSAttributedString.navigationSecondaryButtonAttributes(.Normal), forState: .Normal)
        closeButton.setTitleTextAttributes(NSAttributedString.navigationSecondaryButtonAttributes(.Highlighted), forState: .Highlighted)
        self.navigationItem.leftBarButtonItem = closeButton
        
        let saveButton = UIBarButtonItem(title: "Save", style: .Plain, target: self, action: #selector(savePressed))
        saveButton.enabled = false
        saveButton.setTitleTextAttributes(NSAttributedString.navigationPrimaryButtonAttributes(.Normal), forState: .Normal)
        saveButton.setTitleTextAttributes(NSAttributedString.navigationPrimaryButtonAttributes(.Highlighted), forState: .Highlighted)
        self.navigationItem.rightBarButtonItem = saveButton
        
        lists = realm.objects(PlaceList).sorted("updatedAt", ascending: false)

        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .None
        tableView.allowsMultipleSelection = true
        tableView.showsVerticalScrollIndicator = false
        tableView.registerClass(BaseTableViewCell.self, forCellReuseIdentifier: "placeCell")
        tableView.registerClass(ListSelectorTableViewCell.self, forCellReuseIdentifier: "listCell")
        
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
    
    func savePressed() {
        
        var gmsPlace: GMSPlace!
        var listsToSaveTo = [PlaceList]()
        
        if let selectedRows = tableView.indexPathsForSelectedRows {
            for selectedRow in selectedRows {
                if (selectedRow.section == placesSection) {
                    gmsPlace = places[selectedRow.row].place
                } else if (selectedRow.section == listsSection) {
                    listsToSaveTo.append(lists[selectedRow.row])
                }
            }
        }
        
        let place = Place()
        place.name = gmsPlace.name
        place.placeID = gmsPlace.placeID
        place.longitude = gmsPlace.coordinate.longitude
        place.latitude = gmsPlace.coordinate.latitude
        place.formattedAddress = gmsPlace.formattedAddress
        place.website = gmsPlace.website?.absoluteString
        
        if (listsToSaveTo.count > 0) {
            let realm = try! Realm()
            try! realm.write {
                for placeList in listsToSaveTo {
                    placeList.places.append(place)
                }
            }
        }
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func seeMorePressed() {
        shouldShowAllPlaceSuggestions = true
        tableView.reloadSections(NSIndexSet(index: 0), withRowAnimation: .Fade)
    }
    
    func shouldShowSeeMoreFooter(section: Int) -> Bool {
        return shouldShowAllPlaceSuggestions == false && self.places.count > maxPlaceCount && section == placesSection
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension PlaceSelectorViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if (section == listsSection) {
            // list count plus create a list cell
            return lists.count + 1
        }
        
        if (shouldShowAllPlaceSuggestions == false && self.places.count >= maxPlaceCount) {
            return maxPlaceCount
        }
        return self.places.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if (indexPath.section == listsSection) {
            if (indexPath.row == 0) {
                let cell = ListCreatorTableViewCell()
                cell.delegate = self
                return cell
            } else {
                let cell = ListSelectorTableViewCell()
                // use indexpath.row - 1 to exclude the creator cell
                cell.name = lists[indexPath.row - 1].name
                return cell
            }
        }
        
        let cell = BaseTableViewCell()
        let place = self.places[indexPath.row].place
        
        cell.primaryString = place.name
        
        if let address = place.formattedAddress {
             cell.secondaryString = address
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return Sizes.defaultCellHeight
    }
    
    func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        
        if (indexPath.section == listsSection) {
            return indexPath
        }

        if let selectedRows = tableView.indexPathsForSelectedRows {
            for selectedRow in selectedRows {
                if (selectedRow.section == placesSection) {
                    tableView.deselectRowAtIndexPath(selectedRow, animated: true)
                }
            }
        }
        
        return indexPath
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if (indexPath.section == placesSection) {
            self.navigationItem.rightBarButtonItem?.enabled = true
        }
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if (section == listsSection) {
            return ListSelectorHeaderView()
        }
        
        return nil
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if (section == listsSection) {
            return 0.5
        }
        
        return 0.0
    }
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if (shouldShowSeeMoreFooter(section)) {
            let footerView = PlaceSelectorFooterView(frame: CGRectMake(0, 0, tableView.frame.size.width, footerHeight))
            footerView.seeMoreText = String(format: "See %d more suggestions", self.places.count - maxPlaceCount)
            footerView.seeMoreButton.addTarget(self, action: #selector(seeMorePressed), forControlEvents: .TouchUpInside)
            
            return footerView
        }
        return nil
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if (shouldShowSeeMoreFooter(section)) {
            return footerHeight
        }
        
        return 0
    }
}

extension PlaceSelectorViewController: ListCreatorTableViewCellDelegate {
    func didCreatePlaceList(placeListName: String) {
        let placeList = PlaceList()
        placeList.name = placeListName
        placeList.updatedAt = NSDate()
        
        try! realm.write {
            realm.add(placeList)
        }
        
        tableView.reloadData()
    }
}
