//
//  PlaceSelectorViewController.swift
//  Found
//
//  Created by Austin Louden on 3/29/16.
//  Copyright © 2016 Austin Louden. All rights reserved.
//

import GoogleMaps
import GooglePlaces
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
    
    var didSetupConstraints = false
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
        self.title = "Select a place"
        
        let closeButton = UIBarButtonItem(title: "Close", style: .plain, target: self, action: #selector(closePressed))
        closeButton.setTitleTextAttributes(NSAttributedString.navigationButtonAttributes(UIControlState()), for: UIControlState())
        closeButton.setTitleTextAttributes(NSAttributedString.navigationButtonAttributes(.highlighted), for: .highlighted)
        self.navigationItem.leftBarButtonItem = closeButton
        
        let saveButton = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(savePressed))
        saveButton.isEnabled = false
        saveButton.setTitleTextAttributes(NSAttributedString.navigationButtonAttributes(UIControlState()), for: UIControlState())
        saveButton.setTitleTextAttributes(NSAttributedString.navigationButtonAttributes(.highlighted), for: .highlighted)
        self.navigationItem.rightBarButtonItem = saveButton
        
        lists = realm.objects(PlaceList.self).sorted(byProperty: "updatedAt", ascending: false).filter("name != 'All places'")

        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.allowsMultipleSelection = true
        tableView.showsVerticalScrollIndicator = false
        tableView.register(BaseTableViewCell.self, forCellReuseIdentifier: "placeCell")
        tableView.register(ListSelectorTableViewCell.self, forCellReuseIdentifier: "listCell")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        self.view.backgroundColor = UIColor.white
        self.navigationController?.navigationBar.isTranslucent = false
        
        tableView.frame = self.view.frame
        tableView.contentInset = UIEdgeInsetsMake(8, 0, 0, 0)
        self.view.addSubview(tableView)        
        
        placesClient.currentPlace(callback: { (placeLikelihoods, error) -> Void in
            guard error == nil else {
                print("Current Place error: \(error!.localizedDescription)")
                return
            }

            if let placeLikelihoods = placeLikelihoods {
                self.places = placeLikelihoods.likelihoods
                self.tableView.reloadData()
            }
        })
    }
    
    override func updateViewConstraints() {
        if (didSetupConstraints == false) {
            tableView.snp.makeConstraints { (make) in
                make.edges.equalTo(self.view)
            }
            didSetupConstraints = true
        }
        
        super.updateViewConstraints()
    }
    
    func closePressed() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func savePressed() {
        
        var gmsPlace: GMSPlace!
        var listsToSaveTo = [PlaceList]()
        
        if let selectedRows = tableView.indexPathsForSelectedRows {
            for selectedRow in selectedRows {
                if ((selectedRow as NSIndexPath).section == placesSection) {
                    gmsPlace = places[(selectedRow as NSIndexPath).row].place
                } else if ((selectedRow as NSIndexPath).section == listsSection) {
                    // selected row - 1 for create list cell
                    listsToSaveTo.append(lists[selectedRow.row - 1])
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
        
        if let allList = realm.object(ofType: PlaceList.self, forPrimaryKey: "All places" as AnyObject) {
            listsToSaveTo.append(allList)
        }
        
        if (listsToSaveTo.count > 0) {
            let realm = try! Realm()
            try! realm.write {
                for placeList in listsToSaveTo {
                    placeList.places.append(place)
                }
            }
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func seeMorePressed() {
        shouldShowAllPlaceSuggestions = true
        tableView.reloadSections(IndexSet(integer: 0), with: .fade)
    }
    
    func shouldShowSeeMoreFooter(_ section: Int) -> Bool {
        return shouldShowAllPlaceSuggestions == false && self.places.count > maxPlaceCount && section == placesSection
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension PlaceSelectorViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if (section == listsSection) {
            // list count plus create a list cell
            return lists.count + 1
        }
        
        if (shouldShowAllPlaceSuggestions == false && self.places.count >= maxPlaceCount) {
            return maxPlaceCount
        }
        return self.places.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if ((indexPath as NSIndexPath).section == listsSection) {
            if ((indexPath as NSIndexPath).row == 0) {
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
        let place = self.places[(indexPath as NSIndexPath).row].place
        
        cell.primaryString = place.name
        
        if let address = place.formattedAddress {
             cell.secondaryString = address
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Sizes.defaultCellHeight
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        
        if ((indexPath as NSIndexPath).section == listsSection) {
            return indexPath
        }

        if let selectedRows = tableView.indexPathsForSelectedRows {
            for selectedRow in selectedRows {
                if ((selectedRow as NSIndexPath).section == placesSection) {
                    tableView.deselectRow(at: selectedRow, animated: true)
                }
            }
        }
        
        return indexPath
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if ((indexPath as NSIndexPath).section == placesSection) {
            self.navigationItem.rightBarButtonItem?.isEnabled = true
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if (section == listsSection) {
            return ListSelectorHeaderView()
        }
        
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if (section == listsSection) {
            return 0.5
        }
        
        return 0.0
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if (shouldShowSeeMoreFooter(section)) {
            let footerView = PlaceSelectorFooterView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: footerHeight))
            footerView.seeMoreText = String(format: "See %d more suggestions", self.places.count - maxPlaceCount)
            footerView.seeMoreButton.addTarget(self, action: #selector(seeMorePressed), for: .touchUpInside)
            
            return footerView
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if (shouldShowSeeMoreFooter(section)) {
            return footerHeight
        }
        
        return 0
    }
}

extension PlaceSelectorViewController: ListCreatorTableViewCellDelegate {
    func didCreatePlaceList(_ placeListName: String) {
        let placeList = PlaceList()
        placeList.name = placeListName
        placeList.updatedAt = Date()
        
        try! realm.write {
            realm.add(placeList)
        }
        
        tableView.reloadData()
    }
}
