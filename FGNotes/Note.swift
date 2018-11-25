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
    var location: CLLocationCoordinate2D? = nil
    var date: String = ""
    var image: String = ""
    
    override init() {
        super.init()
        self.id = 0
        self.title = ""
        self.subId = 0
        self.content = ""
        self.location = nil
        self.date = ""
        self.image = ""
    }
    
    func create(id: Int, title: String, subID: Int, content: String, location: CLLocationCoordinate2D, date: String, image: String) -> Note {
        self.id = id
        self.title = title
        self.subId = subID
        self.location = location
        self.date = date
        self.image = image
        return self
    }
}
