//
//  Place.swift
//  Found
//
//  Created by Austin Louden on 3/30/16.
//  Copyright © 2016 Austin Louden. All rights reserved.
//

import Foundation
import RealmSwift

class Place: Object {
    dynamic var name = ""
    dynamic var placeID = ""
    dynamic var longitude: Double = 0.0
    dynamic var latitude: Double = 0.0
    dynamic var formattedAddress: String? = nil
    dynamic var website: String? = nil
}
