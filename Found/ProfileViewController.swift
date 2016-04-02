//
//  ProfileViewController.swift
//  Found
//
//  Created by Austin Louden on 3/30/16.
//  Copyright © 2016 Austin Louden. All rights reserved.
//

import UIKit
import RealmSwift

class ProfileViewController: UIViewController {
    
    let tableView = UITableView()
    var places: Results<Place>!
    
    init() {
        super.init(nibName: nil, bundle: nil)
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.whiteColor()
        
        tableView.frame = self.view.frame
        tableView.contentInset = UIEdgeInsetsMake(UIApplication.sharedApplication().statusBarFrame.size.height, 0, 0, 0)
        self.view.addSubview(tableView)
        
        let realm = try! Realm()
        places = realm.objects(Place)
        
    }
}

// MARK: - UITableViewDatasource
extension ProfileViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return places.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = places[indexPath.row].name
        return cell
    }
}
