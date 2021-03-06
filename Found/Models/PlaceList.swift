//
//  PlaceList.swift
//  Found
//
//  Created by Austin Louden on 4/2/16.
//  Copyright © 2016 Austin Louden. All rights reserved.
//

import Foundation
import RealmSwift

class PlaceList: Object {
    dynamic var name = ""
    dynamic var descriptionText: String? = nil
    dynamic var updatedAt = Date()
    let places = List<Place>()
    
    override static func primaryKey() -> String? {
        return "name"
    }
}
