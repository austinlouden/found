//
//  MapViewController.swift
//  Found
//
//  Created by Austin Louden on 3/27/16.
//  Copyright © 2016 Austin Louden. All rights reserved.
//

import GoogleMaps
import RealmSwift
import SnapKit
import UIKit

class MapViewController: UIViewController {
    
    var didSetupConstraints = false
    
    let mapView = GMSMapView()
    let locationManager = CLLocationManager()
    let realm = try! Realm()
    let saveButton = UIButton(type: .system)
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = mapView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        saveButton.setTitle("Save this place", for: UIControlState())
        saveButton.setAttributedTitle(NSAttributedString.attributedStringWithFont(UIFont.mediumBoldFont(), string: "Save this place", color: UIColor.white), for: UIControlState())
        saveButton.backgroundColor = UIColor.foundBlueColor()
        saveButton.addTarget(self, action: #selector(savePressed), for: .touchUpInside)
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        
        view.addSubview(saveButton)
        view.setNeedsUpdateConstraints()
        
        // create the default, "All places" list if it hasn't been created yet
        if (realm.object(ofType: PlaceList.self, forPrimaryKey: "All places" as AnyObject) == nil) {
            let placeList = PlaceList()
            placeList.name = "All places"
            placeList.updatedAt = Date()
            
            try! realm.write {
                realm.add(placeList)
            }
        }
    }
    
    override func updateViewConstraints() {
        if (didSetupConstraints == false) {
            saveButton.snp.makeConstraints { (make) in
                guard let height = self.tabBarController?.tabBar.frame.size.height else { return }
                make.bottom.equalTo(self.view.snp.bottom).inset(height)
                make.height.equalTo(height)
                make.width.equalTo(self.view.snp.width)
            }
            
            didSetupConstraints = true
        }
        
        super.updateViewConstraints()
    }
    
    func savePressed() {
        let navigationController = UINavigationController(rootViewController: PlaceSelectorViewController())
        navigationController.navigationBar.titleTextAttributes = NSAttributedString.navigationTitleAttributes()
        self.present(navigationController, animated: true, completion: nil)
    }
}

// MARK: - CLLocationManagerDelegate
extension MapViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.startUpdatingLocation()
            mapView.isMyLocationEnabled = true
            mapView.settings.myLocationButton = true
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
            locationManager.stopUpdatingLocation()
        }
    }
}
