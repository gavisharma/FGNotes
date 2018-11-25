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
    var dbPath: String
    var database: OpaquePointer? = nil
    
    // Initialization
    init() {
        self.dbPath = ""
        database = nil
        openDB()
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
        self.dbPath = url!
        print(self.dbPath)
        return url!
    }
    
    func openDBConnection(){
        
    }
    
    func openDB(){
        var database:OpaquePointer? = nil
        let result = sqlite3_open(dataFilePath(), &database)
        if result != SQLITE_OK {
            sqlite3_close(database)
            print("Failed to open database")
            return
        }
        self.database = database
    }
    
    func createNoteTable(){
        openDB()
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
        sqlite3_close(database)
    }
    
    func createSubjectTable(){
        openDB()
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
        sqlite3_close(database)
    }
    
    func createTempNoteTable(){
        openDB()
        var errMsg:UnsafeMutablePointer<Int8>? = nil
        let createTempNoteTable = "CREATE TABLE IF NOT EXISTS TEMPNOTE (ID INTEGER PRIMARY KEY, Title TEXT, SubId INTEGER, Content TEXT, Lat INTEGER, Lon INTEGER, Date TEXT, ImageName TEXT);"
        let result = sqlite3_exec(database, createTempNoteTable, nil, nil, &errMsg)
        if (result != SQLITE_OK) {
            sqlite3_close(database)
            print("Failed to create table")
            return
        } else {
            print("Table Created")
        }
        sqlite3_close(database)
    }
    
    func executeQuery(query: OpaquePointer?){
        openDB()
        if sqlite3_step(query) != SQLITE_DONE {
            print("Error updating table")
            sqlite3_close(database)
            return
        }
        sqlite3_finalize(query)
        sqlite3_close(database)
    }
    
    func insertIntoNoteTable(note: Note){
        let update = "INSERT OR REPLACE INTO NOTE(ID, Title, SubId, Content, Lat, Lon, Date, ImageName) VALUES(?, ?, ?, ?, ?, ?, ?, ?);"
        var statement:OpaquePointer? = nil
        if sqlite3_prepare_v2(database, update, -1, &statement, nil) == SQLITE_OK {
            sqlite3_bind_int(statement, 1, Int32(note.id))
            sqlite3_bind_text(statement, 2, note.title, -1, nil)
            sqlite3_bind_int(statement, 3, Int32(note.id))
            sqlite3_bind_text(statement, 4, note.content, -1, nil)
            sqlite3_bind_double(statement, 5, Double(0.0000))
            sqlite3_bind_double(statement, 6, Double(0.0000))
            sqlite3_bind_text(statement, 7, note.date, -1, nil)
            sqlite3_bind_text(statement, 8, note.image, -1, nil)
            executeQuery(query: statement)
        }
    }
    
    func insertSubjectTable(subject: Subject){
        let update = "INSERT OR REPLACE INTO SUBJECT (ID, Title, Description) VALUES(\(subject.id), '\(subject.title)', '\(subject.desc)');"
        var statement:OpaquePointer? = nil
        if sqlite3_prepare_v2(database, update, -1, &statement, nil) == SQLITE_OK {
            executeQuery(query: statement)
        }
    }
    
    func insertIntoTempNoteTable(note: Note){
        let update = "INSERT OR REPLACE INTO TEMPNOTE(ID, Title, SubId, Content, Lat, Lon, Date, ImageName) VALUES(?, ?, ?, ?, ?, ?, ?, ?);"
        var statement:OpaquePointer? = nil
        if sqlite3_prepare_v2(database, update, -1, &statement, nil) == SQLITE_OK {
            sqlite3_bind_int(statement, 1, Int32(note.id))
            sqlite3_bind_text(statement, 2, note.title, -1, nil)
            sqlite3_bind_int(statement, 3, Int32(note.id))
            sqlite3_bind_text(statement, 4, note.content, -1, nil)
            sqlite3_bind_double(statement, 5, Double((note.location?.latitude)!))
            sqlite3_bind_double(statement, 6, Double((note.location?.longitude)!))
            sqlite3_bind_text(statement, 7, note.date, -1, nil)
            sqlite3_bind_text(statement, 8, note.image, -1, nil)
            executeQuery(query: statement)
        }
    }
    
    func getLastNoteIDFromNotes(){
        var queryString = "SELECT MAX(ID) FROM NOTE;"
        selectQuery(queryString: queryString)
    }
    
    
    func selectQuery(queryString: String) {
        openDB()
        var queryStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(database, queryString, -1, &queryStatement, nil) == SQLITE_OK {
            if sqlite3_step(queryStatement) == SQLITE_ROW {
//                let id = sqlite3_column_int(queryStatement, 0)
//                print("Query Result:")
//
            } else {
                print("Query returned no results")
            }
        } else {
            print("SELECT statement could not be prepared")
        }
        sqlite3_finalize(queryStatement)
    }
    
    
}



