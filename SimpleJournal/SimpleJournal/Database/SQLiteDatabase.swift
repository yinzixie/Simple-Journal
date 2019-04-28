//
//  SQLiteDatabase.swift
//  StrokeRehabilitation
//
//  Created by yinzixie on 4/4/19.
//  Copyright © 2019 Project. All rights reserved.
//
import Foundation
import SQLite3
import UIKit

class SQLiteDatabase
{
    /* This variable is of type OpaquePointer, which is effectively the same as a C pointer (recall the SQLite API is a C-library). The variable is declared as an optional, since it is possible that a database connection is not made successfully, and will be nil until such time as we create the connection.*/
    private var db: OpaquePointer?
    
    /* Change this value whenever you make a change to table structure.
     When a version change is detected, the updateDatabase() function is called,
     which in turn calls the createTables() function.
     
     WARNING: DOING THIS WILL WIPE YOUR DATA, unless you modify how updateDatabase() works.
     */
    private let DATABASE_VERSION = 3
    
    
    
    // Constructor, Initializes a new connection to the database
    /* This code checks for the existence of a file within the application’s document directory with the name <dbName>.sqlite. If the file doesn’t exist, it attempts to create it for us. Since our application has the ability to write into this directory, this should happen the first time that we run the application without fail (it can still possibly fail if the device is out of storage space).
     The remainder of the function checks to see if we are able to open a successful connection to this database file using the sqlite3_open() function. With all of the SQLite functions we will be using, we can check for success by checking for a return value of SQLITE_OK.
     */
    init(databaseName dbName:String)
    {
        //get a file handle somewhere on this device
        //(if it doesn't exist, this should create the file for us)
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("\(dbName).sqlite")
        
        //try and open the file path as a database
        if sqlite3_open(fileURL.path, &db) == SQLITE_OK
        {
            print("Successfully opened connection to database at \(fileURL.path)")
            checkForUpgrade();
        }
        else
        {
            print("Unable to open database at \(fileURL.path)")
            printCurrentSQLErrorMessage(db)
        }
        
    }
    
    deinit
    {
        /* We should clean up our memory usage whenever the object is deinitialized, */
        sqlite3_close(db)
    }
    private func printCurrentSQLErrorMessage(_ db: OpaquePointer?)
    {
        let errorMessage = String.init(cString: sqlite3_errmsg(db))
        print("Error:\(errorMessage)")
    }
    
    private func createTables()
    {
        //INSERT YOUR createTable function calls here
        //e.g. createMovieTable()
        createJournalTable()
        createPicTable()
    }
    
    private func dropTables()
    {
        dropTable(tableName:"Pic")
        dropTable(tableName:"Journal")
        //INSERT YOUR dropTable function calls here
        //e.g. dropTable(tableName:"Movie")
        
    }
    
    /* --------------------------------*/
    /* ----- VERSIONING FUNCTIONS -----*/
    /* --------------------------------*/
    func checkForUpgrade()
    {
        // get the current version number
        let defaults = UserDefaults.standard
        let lastSavedVersion = defaults.integer(forKey: "DATABASE_VERSION")
        
        // detect a version change
        if (DATABASE_VERSION != lastSavedVersion)
        {
            onUpdateDatabase(previousVersion:lastSavedVersion, newVersion: DATABASE_VERSION);
            
            // set the stored version number
            defaults.set(DATABASE_VERSION, forKey: "DATABASE_VERSION")
        }
    }
    
    func onUpdateDatabase(previousVersion : Int, newVersion : Int)
    {
        print("Detected Database Version Change (was:\(previousVersion), now:\(newVersion)")
        
        //handle the change (simple version)
        dropTables()
        createTables()
    }
    
    
    
    /* --------------------------------*/
    /* ------- HELPER FUNCTIONS -------*/
    /* --------------------------------*/
    
    /* Pass this function a CREATE sql string, and a table name, and it will create a table
     You should call this function from createTables()
     */
    private func createTableWithQuery(_ createTableQuery:String, tableName:String)
    {
        /*
         1.    sqlite3_prepare_v2()
         2.    sqlite3_step()
         3.    sqlite3_finalize()
         */
        //prepare the statement
        var createTableStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, createTableQuery, -1, &createTableStatement, nil) == SQLITE_OK
        {
            //execute the statement
            if sqlite3_step(createTableStatement) == SQLITE_DONE
            {
                print("\(tableName) table created.")
            }
            else
            {
                print("\(tableName) table could not be created.")
                printCurrentSQLErrorMessage(db)
            }
        }
        else
        {
            print("CREATE TABLE statement for \(tableName) could not be prepared.")
            printCurrentSQLErrorMessage(db)
        }
        
        //clean up
        sqlite3_finalize(createTableStatement)
        
    }
    /* Pass this function a table name.
     You should call this function from dropTables()
     */
    private func dropTable(tableName:String)
    {
        /*
         1.    sqlite3_prepare_v2()
         2.    sqlite3_step()
         3.    sqlite3_finalize()
         */
        
        //prepare the statement
        let query = "DROP TABLE IF EXISTS \(tableName)"
        var statement: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(db, query, -1, &statement, nil)     == SQLITE_OK
        {
            //run the query
            if sqlite3_step(statement) == SQLITE_DONE {
                print("\(tableName) table deleted.")
            }
        }
        else
        {
            print("\(tableName) table could not be deleted.")
            printCurrentSQLErrorMessage(db)
        }
        
        //clear up
        sqlite3_finalize(statement)
    }
    
    //helper function for handling INSERT statements
    //provide it with a binding function for replacing the ?'s for setting values
    private func insertWithQuery(_ insertStatementQuery : String, bindingFunction:(_ insertStatement: OpaquePointer?)->())->Bool
    {
        /*
         Similar to the CREATE statement, the INSERT statement needs the following SQLite functions to be called (note the addition of the binding function calls):
         1.    sqlite3_prepare_v2()
         2.    sqlite3_bind_***()
         3.    sqlite3_step()
         4.    sqlite3_finalize()
         */
        // First, we prepare the statement, and check that this was successful. The result will be a C-
        // pointer to the statement:
        var flag:Bool
        
        var insertStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, insertStatementQuery, -1, &insertStatement, nil) == SQLITE_OK
        {
            //handle bindings
            bindingFunction(insertStatement)
            
            /* Using the pointer to the statement, we can call the sqlite3_step() function. Again, we only
             step once. We check that this was successful */
            //execute the statement
            if sqlite3_step(insertStatement) == SQLITE_DONE
            {
                flag = true
                print("Successfully inserted row.")
            }
            else
            {
                flag = false
                print("Could not insert row.")
                printCurrentSQLErrorMessage(db)
            }
        }
        else
        {
            flag = false
            print("INSERT statement could not be prepared.")
            printCurrentSQLErrorMessage(db)
        }
        
        //clean up
        sqlite3_finalize(insertStatement)
        return flag
    }
    
    //helper function to run Select statements
    //provide it with a function to do *something* with each returned row
    //(optionally) Provide it with a binding function for replacing the "?"'s in the WHERE clause
    private func selectWithQuery(
        _ selectStatementQuery : String,
        eachRow: (_ rowHandle: OpaquePointer?)->(),
        bindingFunction: ((_ rowHandle: OpaquePointer?)->())? = nil)
    {
        //prepare the statement
        var selectStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, selectStatementQuery, -1, &selectStatement, nil) == SQLITE_OK
        {
            //do bindings, only if we have a bindingFunction set
            //hint, to do selectMovieBy(id:) you will need to set a bindingFunction (if you don't hardcode the id)
            bindingFunction?(selectStatement)
            
            //iterate over the result
            while sqlite3_step(selectStatement) == SQLITE_ROW
            {
                eachRow(selectStatement);
            }
            
        }
        else
        {
            print("SELECT statement could not be prepared.")
            printCurrentSQLErrorMessage(db)
        }
        //clean up
        sqlite3_finalize(selectStatement)
    }
    
    //helper function to run update statements.
    //Provide it with a binding function for replacing the "?"'s in the WHERE clause
    private func updateWithQuery(
        _ updateStatementQuery : String,
        bindingFunction: ((_ rowHandle: OpaquePointer?)->()))->Bool
    {
        var flag:Bool = true
        //prepare the statement
        var updateStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, updateStatementQuery, -1, &updateStatement, nil) == SQLITE_OK
        {
            //do bindings
            bindingFunction(updateStatement)
            
            //execute
            if sqlite3_step(updateStatement) == SQLITE_DONE
            {
                print("Successfully inserted row.")
                flag = true
            }
            else
            {
                print("Could not insert row.")
                printCurrentSQLErrorMessage(db)
                flag = false
            }
        }
        else
        {
            print("UPDATE statement could not be prepared.")
            printCurrentSQLErrorMessage(db)
            flag = false
        }
        //clean up
        sqlite3_finalize(updateStatement)
        return flag
    }
    
    /* --------------------------------*/
    /* --- Creat table ---*/
    /* --------------------------------*/
    
    func createJournalTable(){
        let query = """
            CREATE TABLE Journal(
            ID STRING PRIMARY KEY NOT NULL,
            Title CHAR(255),
            DateString CHAR(255),
            Year INT(5),
            Month INT(2),
            Day INT(2),
            Time CHAR(255),
            Location CHAR(255),
            Mood CHAR(255),
            Weather CHAR(255),
            TextContent TEXT,
            DisplayPic CHAR(255),
            PicsTableID CHAR(255),
            Shared BOOL
            )
        """
        createTableWithQuery(query, tableName: "Journal")
    }
    
    func createPicTable() {
        let query = """
            CREATE TABLE Pic(
            NameID STRING PRIMARY KEY NOT NULL,
            JournalID CHAR(255)
            )
        """
        createTableWithQuery(query, tableName: "Pic")
    }
    
    func insertJournal(journal:Journal)->Bool {
        let query = """
        INSERT INTO Journal (ID,Title,DateString,Year,Month,Day,Time,Location,Mood,Weather,TextContent, DisplayPic,PicsTableID,Shared) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?)
        """
        return insertWithQuery(query, bindingFunction: { (insertStatement) in
            sqlite3_bind_text(insertStatement, 1, NSString(string:journal.ID).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 2, NSString(string:journal.Title).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 3, NSString(string:journal.DateString).utf8String, -1, nil)
            sqlite3_bind_int(insertStatement, 4, Int32(journal.Year))
            sqlite3_bind_int(insertStatement, 5, Int32(journal.Month))
            sqlite3_bind_int(insertStatement, 6, Int32(journal.Day))
            sqlite3_bind_text(insertStatement, 7, NSString(string:journal.Time).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 8, NSString(string:journal.Location).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 9, NSString(string:journal.Mood).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 10, NSString(string:journal.Weather).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 11, NSString(string:journal.TextContent).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 12, NSString(string:journal.DisplayPic).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 13, NSString(string:journal.PicsTableID).utf8String, -1, nil)
            sqlite3_bind_int(insertStatement, 14, Int32(Int(journal.Shared!)))
        })
    }
    
    func deleteJournal(journal:Journal)->Bool {
        let query = """
        DELETE FROM Journal WHERE ID=?
        """
        return insertWithQuery(query, bindingFunction: { (insertStatement) in
            sqlite3_bind_text(insertStatement, 1, NSString(string:journal.ID).utf8String, -1, nil)
        })
    }
    
    func selectAllJournal()->[Journal] {
        var result = [Journal]()
        let selectStatementQuery = "SELECT * FROM Journal ORDER BY Year DESC, Month DESC, Day DESC, Time DESC"
        
        selectWithQuery(selectStatementQuery, eachRow: { (row) in //create a journal object from each result
            let journal = Journal()
            journal.ID = String(cString:sqlite3_column_text(row, 0))
            journal.Title = String(cString:sqlite3_column_text(row, 1))
            journal.DateString = String(cString:sqlite3_column_text(row, 2))
            journal.Year = Int(sqlite3_column_int(row, 3))
            journal.Month = Int(sqlite3_column_int(row, 4))
            journal.Day = Int(sqlite3_column_int(row, 5))
            journal.Time = String(cString:sqlite3_column_text(row, 6))
            journal.Location = String(cString:sqlite3_column_text(row, 7))
            journal.Mood = String(cString:sqlite3_column_text(row, 8))
            journal.Weather = String(cString:sqlite3_column_text(row, 9))
            journal.TextContent = String(cString:sqlite3_column_text(row, 10))
            journal.DisplayPic = String(cString:sqlite3_column_text(row, 11))
            journal.PicsTableID = String(cString:sqlite3_column_text(row, 12))
            journal.Shared = Int(sqlite3_column_int(row, 13))
            
            result += [journal]
        })
        return result
    }
    
    func updateJournal(journal:Journal)->Bool{
        let statement = "UPDATE Journal SET Title = ?,DateString = ?,Year = ?,Month = ?,Day = ?,Time = ?,Location = ?,Mood = ?,Weather = ?,TextContent = ?, DisplayPic = ?,PicsTableID = ?,Shared = ? WHERE ID = ? "
        
        return (updateWithQuery(statement,bindingFunction: {(insertStatement) in
            sqlite3_bind_text(insertStatement, 1, NSString(string:journal.Title).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 2, NSString(string:journal.DateString).utf8String, -1, nil)
            sqlite3_bind_int(insertStatement, 3, Int32(journal.Year))
            sqlite3_bind_int(insertStatement, 4, Int32(journal.Month))
            sqlite3_bind_int(insertStatement, 5, Int32(journal.Day))
            sqlite3_bind_text(insertStatement, 6, NSString(string:journal.Time).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 7, NSString(string:journal.Location).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 8, NSString(string:journal.Mood).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 9, NSString(string:journal.Weather).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 10, NSString(string:journal.TextContent).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 11, NSString(string:journal.DisplayPic).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 12, NSString(string:journal.PicsTableID).utf8String, -1, nil)
            sqlite3_bind_int(insertStatement, 13, Int32(Int(journal.Shared!)))
            sqlite3_bind_text(insertStatement, 14, NSString(string:journal.ID).utf8String, -1, nil)
        }))
    }
    
    func insertPic(journal:Journal) {
        let query = """
        INSERT INTO Pic (JournalID,NameID) VALUES (?,?)
        """
        for pic in journal.PicsList {
            let NameID = pic.accessibilityIdentifier!
            
            if(insertWithQuery(query, bindingFunction: { (insertStatement) in
                sqlite3_bind_text(insertStatement, 1, NSString(string:journal.PicsTableID).utf8String, -1, nil)
                sqlite3_bind_text(insertStatement, 2, NSString(string:NameID).utf8String, -1, nil)
            })) {
                //write into document/picsfolder
                AppFile.saveImage(currentImage: pic, persent: 1, imageName: NameID)
            }
        }
       
    }
    
    func insertPicByImageList(journal:Journal, list:[UIImage]) {
        let query = """
        INSERT INTO Pic (JournalID,NameID) VALUES (?,?)
        """
        for pic in list {
            if(insertWithQuery(query, bindingFunction: { (insertStatement) in
                sqlite3_bind_text(insertStatement, 1, NSString(string:journal.PicsTableID).utf8String, -1, nil)
                sqlite3_bind_text(insertStatement, 2, NSString(string:pic.accessibilityIdentifier!).utf8String, -1, nil)
            })) {
                //write into document/picsfolder
                AppFile.saveImage(currentImage: pic, persent: 1, imageName: pic.accessibilityIdentifier!)
            }
        }
    }
    
    func deletePicsByStringList(journal:Journal,pics:[String]) {
        let query = """
        DELETE FROM Pic WHERE NameID = ?
        """
        
        for name in pics {
            if(insertWithQuery(query, bindingFunction: { (insertStatement) in
                sqlite3_bind_text(insertStatement, 1, NSString(string:name).utf8String, -1, nil)
            })) {
                //delete pics
                AppFile.removefile(folderName: AppFile.ImagesFolderFullPath.appending(name))
            }
        }
    }
    
    func selectPicsByJournal(journal:Journal)->[String] {
        var result = [String]()

        let selectStatementQuery = "SELECT NameID FROM Pic WHERE JournalID = ?"
        
        selectWithQuery(selectStatementQuery, eachRow: { (row) in //create a journal object from each result
            let name = String(cString:sqlite3_column_text(row, 0))
         
            result += [name]
        },bindingFunction: {(insertStatement) in
            sqlite3_bind_text(insertStatement, 1, NSString(string:journal.PicsTableID).utf8String, -1, nil)
        })
        return result
    }
    
    
    
   /* func createPatientTable(){
        let query = """
        CREATE TABLE Patient(
        ID STRING PRIMARY KEY NOT NULL,
        Firstname CHAR(255),
        Givenname CHAR(255),
        Gender CHAR(10),
        Age INTEGER,
        AimMissionTable CHAR(255),
        HistoryMissionTable CHAR(255)
        )
        """
        createTableWithQuery(query, tableName: "Patient")
    }
  
    func insertPatient(patient:Patient)->Bool {
        let query = """
        INSERT INTO Patient (ID,Firstname,Givenname,Gender,Age,AimMissionTable,HistoryMissionTable) VALUES (?,?,?,?,?,?,?)
        """
        return insertWithQuery(query, bindingFunction: { (insertStatement) in
            sqlite3_bind_text(insertStatement, 1, NSString(string:patient.ID).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 2, NSString(string:patient.Firstname).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 3, NSString(string:patient.Givenname).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 4, NSString(string:patient.Gender).utf8String, -1, nil)
            sqlite3_bind_int(insertStatement, 5, Int32(patient.Age))
            sqlite3_bind_text(insertStatement, 6, NSString(string:patient.AimMissionTableName).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 7, NSString(string:patient.HistoryMissionTableName).utf8String, -1, nil)
        })
    }
    
    func deletePatient(patient:Patient)->Bool {
        let query = """
        DELETE FROM Patient WHERE ID=?
        """
        return insertWithQuery(query, bindingFunction: { (insertStatement) in
            sqlite3_bind_text(insertStatement, 1, NSString(string:patient.ID).utf8String, -1, nil)
        })
    }
    
    func deletePatientRelevantTable(patient:Patient) {
        dropTable(tableName: patient.AimMissionTableName)
        dropTable(tableName: patient.HistoryMissionTableName)
    }
    
    func selectAllPatients() -> [Patient] {
        var result = [Patient]()
        let selectStatementQuery = "SELECT ID,Firstname,Givenname,Gender,Age FROM Patient"
        
        selectWithQuery(selectStatementQuery, eachRow: { (row) in //create a patient object from each result
            let patient = Patient(
                id: String(cString:sqlite3_column_text(row, 0)), firstname: String(cString:sqlite3_column_text(row, 1)),
                givenname: String(cString:sqlite3_column_text(row, 2)), sex: String(cString:sqlite3_column_text(row, 3)),
                age:Int(sqlite3_column_int(row, 4)))
            
            result += [patient]
        })
        return result
    }
    
    func selectPatientByID(id:String)->Patient? {
        let selectStatementQuery = "SELECT * FROM Patient WHERE ID=\(id)"
        var result:Patient? = nil
        selectWithQuery(selectStatementQuery, eachRow: { (row) in //create a patient object from each result
            let patient = Patient(
                id: String(cString:sqlite3_column_text(row, 0)), firstname: String(cString:sqlite3_column_text(row, 1)),
                givenname: String(cString:sqlite3_column_text(row, 2)), sex: String(cString:sqlite3_column_text(row, 3)),
                age:Int(sqlite3_column_int(row, 4)))
            result = patient
        })
        print(result?.ID)
        return result
    }*/
    
    
}
