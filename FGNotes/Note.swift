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
    var date: Date? = nil
    var image: String = ""
    
    override init() {
        super.init()
        self.id = 0
        self.title = ""
        self.subId = 0
        self.content = ""
        self.location = nil
        self.date = nil
        self.image = ""
    }
    
    func create(note: Note) -> Note {
        self.id = note.id
        self.title = note.title
        self.subId = note.subId
        self.location = note.location
        self.date = note.date
        self.image = note.image
        return self
    }
}
