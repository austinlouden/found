//
//  PlaceListViewController.swift
//  Found
//
//  Created by Austin Louden on 4/23/16.
//  Copyright © 2016 Austin Louden. All rights reserved.
//

import UIKit

class PlaceListViewController: UIViewController {
    
    let tableView = UITableView()
    let placeList: PlaceList

    init(list: PlaceList) {
        placeList = list
        
        super.init(nibName: nil, bundle: nil)
        self.title = placeList.name
        
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
}

extension PlaceListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return placeList.places.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let place = placeList.places[indexPath.row]
        
        let cell = BaseTableViewCell()
        cell.primaryString = place.name
        
        if let address = place.formattedAddress {
            cell.secondaryString = address
        }
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return Sizes.defaultCellHeight
    }
}
