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
    var database: OpaquePointer? = nil
    
    // Initialization
    init() {
        self.dbPath = ""
        database = nil
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
        self.database = database
        sqlite3_close(database)
    }
    
    func createNoteTable(){
        var errMsg:UnsafeMutablePointer<Int8>? = nil
        let createNoteTable = "CREATE TABLE IF NOT EXISTS NOTE (ID INTEGER PRIMARY KEY, Title TEXT, SubId INTEGER, Content TEXT, Lat INTEGER, Lon INTEGER, Date TEXT, ImageName TEXT);"
        let result = sqlite3_exec(database, createNoteTable, nil, nil, &errMsg)
        if (result != SQLITE_OK) {
            sqlite3_close(database)
            print("Failed to create table")
            return
        } else {
            print("Table Created")
        }
    }
    
    func createSubjectTable(){
        var errMsg:UnsafeMutablePointer<Int8>? = nil
        let createSubjectTable = "CREATE TABLE IF NOT EXISTS SUBJECT (ID INTEGER PRIMARY KEY, Title TEXT, Description TEXT);"
        let result = sqlite3_exec(database, createSubjectTable, nil, nil, &errMsg)
        if (result != SQLITE_OK) {
            sqlite3_close(database)
            print("Failed to create table")
            return
        } else {
            print("Table Created")
        }
    }
    
    func createTempNoteTable(){
        var errMsg:UnsafeMutablePointer<Int8>? = nil
        let createTempNoteTable = "CREATE TABLE IF NOT EXISTS NOTE (ID INTEGER PRIMARY KEY, Title TEXT, SubId INTEGER, Content TEXT, Lat INTEGER, Lon INTEGER, Date TEXT, ImageName TEXT);"
        let result = sqlite3_exec(database, createTempNoteTable, nil, nil, &errMsg)
        if (result != SQLITE_OK) {
            sqlite3_close(database)
            print("Failed to create table")
            return
        } else {
            print("Table Created")
        }
    }
    
    
    func insertIntoNoteTable(){}
    
}



