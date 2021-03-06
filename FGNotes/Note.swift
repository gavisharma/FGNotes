//
//  Note.swift
//  FGNotes
//
//  Created by Foram Dadhania on 2018-11-24.
//  Copyright © 2018 Foram Dadhania. All rights reserved.
//

import Foundation
import CoreLocation

class Note: NSObject {
    var id: Int = 0
    var title: String = ""
    var subId: Int = 0
    var content: String = ""
    var lat: String = ""
    var lon: String = ""
    var date: Date = Date()
    var image: String = ""
    var isLocationEnabled: Int = 0
    
    override init() {
        super.init()
        self.id = 0
        self.title = ""
        self.subId = 0
        self.content = ""
        self.lat = ""
        self.lon = ""
        self.date = Date()
        self.image = ""
        self.isLocationEnabled = 0
    }
    
    func create(id: Int, title: String, subID: Int, content: String, lat: String, lon: String, date: Date, image: String) -> Note {
        self.id = id
        self.title = title
        self.subId = subID
        self.lat = lat
        self.lon = lon
        self.date = date
        self.image = image
        return self
    }
}
