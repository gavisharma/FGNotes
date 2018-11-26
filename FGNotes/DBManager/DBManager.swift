//
//  DBManager.swift
//  FGNotes
//
//  Created by Foram Dadhania on 2018-11-22.
//  Copyright © 2018 Foram Dadhania. All rights reserved.
//

import Foundation
import SQLite3

//DBManager to handle all the database related queries with it's shared Instance

let sharedDatabaseManager = DBManager()

class DBManager {
    // MARK: - Properties
    var dbPath: String
    var database: OpaquePointer? = nil
    
    // Initialization
    init() {
        self.dbPath = ""
        database = nil
        let fileManager = FileManager.default
        let urls = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        // If array of path is empty the document folder not found
        guard urls.count != 0 else {
            return
        }
        let finalDatabaseURL = urls.first?.appendingPathComponent("FGNotesData.sqlite")
        // Check if file reachable, and if reacheble just return path
        do {
            let check = try finalDatabaseURL?.checkResourceIsReachable()
            print(check ?? true)
            print(finalDatabaseURL?.absoluteString)
        } catch {
            //Only executes if the application is opened for the first time
            //Get the path of the bundle folder
            if let bundleURL = Bundle.main.url(forResource: "FGNotesData", withExtension: "sqlite"){
                //Copy the sqlite file from the Bundle to Document Directory
                do {
                    try fileManager.copyItem(at: bundleURL, to: finalDatabaseURL!)
                } catch let error as NSError { // Handle the error
                    print("File copy failed! Error:\(error.localizedDescription)")
                }
                //Directory created for storing images locally
                let writablePath = urls.first?.appendingPathComponent("Images", isDirectory: true)
                do{
                    let dirCreated = try fileManager.createDirectory(at: writablePath!, withIntermediateDirectories: false, attributes: nil)
                    print(dirCreated)
                } catch{
                    print(error.localizedDescription)
                }
            } else {
                print("Our file not exist in bundle folder")
                return
            }
            
        }
        self.dbPath = (finalDatabaseURL?.absoluteString)!
    }
    
    //MARK: Open Connection to the database
    func openDB(){
        var database:OpaquePointer? = nil
        let result = sqlite3_open(dbPath, &database)
        if result != SQLITE_OK {
            sqlite3_close(database)
            print("Failed to open database")
            return
        }
        self.database = database
    }
    
    //MARK: Create Note table
    func createNoteTable(){
        openDB()
        var errMsg:UnsafeMutablePointer<Int8>? = nil
        let createNoteTable = "CREATE TABLE IF NOT EXISTS NOTE (ID INTEGER PRIMARY KEY, Title TEXT, SubId INTEGER, Content TEXT, Lat TEXT, Lon TEXT, Date TEXT, ImageName TEXT);"
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
    
    //MARK: Create Subject Table
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
    
    //MARK: Create Temporary Notes Table
    //Will be updated on the basis of the subject
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
    
    //MARK: Common method for executing Inser or Update related queries
    func executeQuery(query: OpaquePointer?){
        if sqlite3_step(query) != SQLITE_DONE {
            print("Error updating table")
            sqlite3_close(database)
            return
        }
        sqlite3_finalize(query)
        sqlite3_close(database)
    }
    
    //MARK: Method to insert or create a note in the database
    func insertIntoNoteTable(note: Note){
        openDB()
        let update = "INSERT OR REPLACE INTO NOTE(ID, Title, SubId, Content, Lat, Lon, Date, ImageName) VALUES(?, ?, ?, ?, ?, ?, ?, ?);"
        var statement:OpaquePointer? = nil
        if sqlite3_prepare_v2(database, update, -1, &statement, nil) == SQLITE_OK {
            sqlite3_bind_int(statement, 1, Int32(note.id))
            sqlite3_bind_text(statement, 2, note.title, -1, nil)
            sqlite3_bind_int(statement, 3, Int32(note.subId))
            sqlite3_bind_text(statement, 4, note.content, -1, nil)
            sqlite3_bind_text(statement, 5, "0.47395", -1, nil)
            sqlite3_bind_text(statement, 6, "0.36847", -1, nil)
            sqlite3_bind_text(statement, 7, note.date, -1, nil)
            sqlite3_bind_text(statement, 8, note.image, -1, nil)
            executeQuery(query: statement)
        }
    }
    
    //MARK: Method to insert or update the subject in the database
    func insertSubjectTable(subject: Subject){
        openDB()
        let update = "INSERT OR REPLACE INTO SUBJECT (ID, Title, Description) VALUES(\(subject.id), '\(subject.title)', '\(subject.desc)');"
        var statement:OpaquePointer? = nil
        if sqlite3_prepare_v2(database, update, -1, &statement, nil) == SQLITE_OK {
            executeQuery(query: statement)
        }
    }
    
    //MARK: Method to insert or update a temporary note in the database
    func insertIntoTempNoteTable(note: Note){
        openDB()
        let update = "INSERT OR REPLACE INTO TEMPNOTE(ID, Title, SubId, Content, Lat, Lon, Date, ImageName) VALUES(?, ?, ?, ?, ?, ?, ?, ?);"
        var statement:OpaquePointer? = nil
        if sqlite3_prepare_v2(database, update, -1, &statement, nil) == SQLITE_OK {
            sqlite3_bind_int(statement, 1, Int32(note.id))
            sqlite3_bind_text(statement, 2, note.title, -1, nil)
            sqlite3_bind_int(statement, 3, Int32(note.id))
            sqlite3_bind_text(statement, 4, note.content, -1, nil)
            sqlite3_bind_text(statement, 5, note.lat, -1, nil)
            sqlite3_bind_text(statement, 6, note.lon, -1, nil)
            sqlite3_bind_text(statement, 7, note.date, -1, nil)
            sqlite3_bind_text(statement, 8, note.image, -1, nil)
            executeQuery(query: statement)
        }
    }
    
    //MARK: Method to get the ID for the new note **ID Acts as AutoIncrement key
    func getLastNoteIDFromNotes() -> Int {
        openDB()
        var noteID: Int = 0
        var queryResult: OpaquePointer? = nil
        let queryString = "SELECT MAX(ID), COUNT(ID) FROM NOTE;"
        queryResult = selectQuery(queryString: queryString)
        if sqlite3_step(queryResult) == SQLITE_ROW {
            noteID = Int(sqlite3_column_int(queryResult, 0))
            print("Note DB id is: \(noteID)")
        }
        sqlite3_finalize(queryResult)
        sqlite3_close(database)
        return noteID + 1
    }
    
    //MARK: Method to get the ID for the new temporary note **ID Acts as AutoIncrement key
    func getLastTempNoteIDFromTempNotes() -> Int {
        openDB()
        var noteID: Int = 0
        var queryResult: OpaquePointer? = nil
        let queryString = "SELECT MAX(ID), COUNT(ID) FROM TEMPNOTE;"
        queryResult = selectQuery(queryString: queryString)
        if sqlite3_step(queryResult) == SQLITE_ROW {
            noteID = Int(sqlite3_column_int(queryResult, 0))
            print("Temp DB id is: \(noteID)")
        }
        sqlite3_finalize(queryResult)
        sqlite3_close(database)
        return noteID + 1
    }
    
    //MARK: Method to reteive the list of all the subjects. An array of Subject objects is returned
    func getListOfAllSubjects() -> [Subject]? {
        openDB()
        var queryResult: OpaquePointer? = nil
        let queryString = "SELECT * FROM SUBJECT;"
        var subjectsArray:[Subject] = []
        queryResult = selectQuery(queryString: queryString)
        while sqlite3_step(queryResult) == SQLITE_ROW {
            let sub: Subject = Subject.init()
            sub.id = Int(sqlite3_column_int(queryResult, 0))
            sub.title = String(cString:sqlite3_column_text(queryResult, 1)!)
            sub.desc = String(cString: sqlite3_column_text(queryResult, 2)!)
            subjectsArray.append(sub)
        }
        sqlite3_finalize(queryResult)
        sqlite3_close(database)
        return subjectsArray
    }
    
    //MARK: Method to reteive the list of all the notes created. An array of Note objects is returned
    func getAllNotes() -> [Note]? {
        openDB()
        var queryResult: OpaquePointer? = nil
        let queryString = "SELECT * FROM NOTE;"
        var notesArray:[Note] = []
        queryResult = selectQuery(queryString: queryString)
        while sqlite3_step(queryResult) == SQLITE_ROW {
            let note: Note = Note.init()
            note.id = Int(sqlite3_column_int(queryResult, 0))
            note.title = String(cString:sqlite3_column_text(queryResult, 1)!)
            note.subId = Int(sqlite3_column_int(queryResult, 2))
            note.content = String(cString:sqlite3_column_text(queryResult, 3)!)
            note.lat = String(cString:sqlite3_column_text(queryResult, 4)!)
            note.lon = String(cString:sqlite3_column_text(queryResult, 5)!)
            note.date = String(cString:sqlite3_column_text(queryResult, 6)!)
            note.image = String(cString:sqlite3_column_text(queryResult, 7)!)
            notesArray.append(note)
        }
        sqlite3_finalize(queryResult)
        sqlite3_close(database)
        return notesArray
    }
    
    //MARK: Common method to execute the fetch requests 
    func selectQuery(queryString: String) -> OpaquePointer? {
        var queryStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(database, queryString, -1, &queryStatement, nil) == SQLITE_OK {
            return queryStatement
        } else {
            print("SELECT statement could not be prepared")
        }
        return queryStatement
    }
}



