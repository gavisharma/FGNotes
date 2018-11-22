//
//  DBManager.swift
//  FGNotes
//
//  Created by Foram Dadhania on 2018-11-22.
//  Copyright © 2018 Foram Dadhania. All rights reserved.
//

import Foundation
import SQLite3

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
    
    func openDBConnection(){
        
    }
    
    func setUpDatabase(){
        var database:OpaquePointer? = nil
        var errMsg:UnsafeMutablePointer<Int8>? = nil
        var result = sqlite3_open(dataFilePath(), &database)
        if result != SQLITE_OK {
            sqlite3_close(database)
            print("Failed to open database")
            return
        }
        
        let createNoteTable = "CREATE TABLE IF NOT EXISTS NOTE (ID INTEGER PRIMARY KEY, Title TEXT, SubId INTEGER, Content TEXT, Lat INTEGER, Lon INTEGER, Date TEXT, ImageName TEXT);"
        result = sqlite3_exec(database, createNoteTable, nil, nil, &errMsg)
        if (result != SQLITE_OK) {
            sqlite3_close(database)
            print("Failed to create table")
            return
        }
        
        let createSubjectTable = "CREATE TABLE IF NOT EXISTS SUBJECT (ID INTEGER PRIMARY KEY, Title TEXT, Description TEXT);"
        result = sqlite3_exec(database, createSubjectTable, nil, nil, &errMsg)
        if (result != SQLITE_OK) {
            sqlite3_close(database)
            print("Failed to create table")
            return
        }
        
        let createTempNoteTable = "CREATE TABLE IF NOT EXISTS TEMPNOTE (ID INTEGER PRIMARY KEY, Title TEXT, SubId INTEGER, Content TEXT, Lat INTEGER, Lon INTEGER, Date TEXT, Image TEXT);"
        result = sqlite3_exec(database, createTempNoteTable, nil, nil, &errMsg)
        if (result != SQLITE_OK) {
            sqlite3_close(database)
            print("Failed to create table")
            return
        }
        
        sqlite3_close(database)
    }
    
}



