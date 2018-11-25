//
//  Subject.swift
//  FGNotes
//
//  Created by Foram Dadhania on 2018-11-24.
//  Copyright © 2018 Foram Dadhania. All rights reserved.
//

import Foundation

class Subject: NSObject {
    var id:Int = 0
    var title:String = ""
    var desc:String = ""
    
    override init() {
        super.init()
        self.id = 0
        self.title = ""
        self.desc = ""
    }
    
    func sub(id:Int, name:String, desc:String) -> Subject {
        self.id = id
        self.title = name
        self.desc = desc
        return self
    }
}
