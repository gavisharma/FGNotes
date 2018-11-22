//
//  DBManager.swift
//  FGNotes
//
//  Created by Foram Dadhania on 2018-11-22.
//  Copyright © 2018 Foram Dadhania. All rights reserved.
//

import Foundation
//DBManager to handle all the database related queries
//Table Creation
//Updation, deletion, insertion and/or selection of table rows
//All DB queires have been modularised

//Implementation will begin from here
//Create a singelton class here and then create methods for creating database
//Creating tables
//Inserting data into them
//Retreiving that data

let sharedDatabaseManager = DBManager()

class DBManager {
    // MARK: - Properties
    let dbPath: String
    
    // Initialization
    init() {
        self.dbPath = ""
    }
    
    //MARK: SQLite data file path
    func dataFilePath() -> String {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        print(urls)
        var url: String?
        url = ""
        do {
            try url = urls.first?.appendingPathComponent("FGNotesData.sqlite").path
        } catch {
            print("Error is \(error)")
        }
        return url!
    }
    
}



