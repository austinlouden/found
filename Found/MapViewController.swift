//
//  MapViewController.swift
//  Found
//
//  Created by Austin Louden on 3/27/16.
//  Copyright © 2016 Austin Louden. All rights reserved.
//

import UIKit
import GoogleMaps
import SnapKit

class MapViewController: UIViewController {
    
    let mapView = GMSMapView()
    let locationManager = CLLocationManager()
    
    let saveButton = UIButton(type: .System)
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
        saveButton.setTitle("Save this place", forState: .Normal)
        saveButton.addTarget(self, action: #selector(savePressed), forControlEvents: .TouchUpInside)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = mapView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        
        self.view.addSubview(saveButton)
        
        saveButton.snp_makeConstraints { (make) in
            make.bottom.equalTo(self.view.snp_bottom).offset(-20);
            make.height.equalTo(40.0)
            make.width.equalTo(self.view.snp_width)
        }
    }
    
    func savePressed() {
        self.presentViewController(PlaceSelectorViewController(), animated: true, completion: nil)
    }
}

// MARK: - CLLocationManagerDelegate
extension MapViewController: CLLocationManagerDelegate {
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .AuthorizedWhenInUse {
            locationManager.startUpdatingLocation()
            mapView.myLocationEnabled = true
            mapView.settings.myLocationButton = true
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
            locationManager.stopUpdatingLocation()
        }
    }
}
