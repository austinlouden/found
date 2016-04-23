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
    
    let tableViewCellHeight: CGFloat = 60.0
    
    let tableView = UITableView()
    var lists: Results<PlaceList>!
    let realm = try! Realm()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        self.title = "Saved"
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .None
        tableView.registerClass(BaseTableViewCell.self, forCellReuseIdentifier: "listCell")
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
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        lists = realm.objects(PlaceList)
        tableView.reloadData()
    }
}

// MARK: - UITableViewDatasource
extension ProfileViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lists.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let placeList = lists[indexPath.row]
        
        let cell = BaseTableViewCell()
        cell.primaryString = placeList.name
        cell.secondaryString = String(format: "%d places", placeList.places.count)
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let list = lists[indexPath.row]
        print(list.places)
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return tableViewCellHeight
    }
}
