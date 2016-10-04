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
        tableView.separatorStyle = .none
        tableView.register(BaseTableViewCell.self, forCellReuseIdentifier: "listCell")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        
        tableView.frame = self.view.frame
        tableView.contentInset = UIEdgeInsetsMake(UIApplication.shared.statusBarFrame.size.height, 0, 0, 0)
        self.view.addSubview(tableView)
    }
}

extension PlaceListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return placeList.places.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let place = placeList.places[indexPath.row]
        
        let cell = BaseTableViewCell()
        cell.primaryString = place.name
        
        if let address = place.formattedAddress {
            cell.secondaryString = address
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Sizes.defaultCellHeight
    }
}
