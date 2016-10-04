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
    var lists: Results<PlaceList>!
    let realm = try! Realm()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        self.title = "Saved"
        
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        lists = realm.objects(PlaceList.self)
        tableView.reloadData()
    }
}

// MARK: - UITableViewDatasource
extension ProfileViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let placeList = lists[indexPath.row]
        
        let cell = BaseTableViewCell()
        cell.primaryString = placeList.name
        cell.secondaryString = String(format: "%d places", placeList.places.count)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let list = lists[indexPath.row]
        self.navigationController?.pushViewController(PlaceListViewController(list: list), animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Sizes.defaultCellHeight
    }
}
