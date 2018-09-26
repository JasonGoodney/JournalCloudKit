//
//  EntryController.swift
//  JournalCloudKit2
//
//  Created by Jason Goodney on 9/22/18.
//  Copyright © 2018 Jason Goodney. All rights reserved.
//

import Foundation
import CloudKit

let updateEntriesNotification = Notification.Name("updateEntries")

class EntryController {
    
    let ckManager = CloudKitManager()
    static let shared = EntryController(); private init() {}
    
    var entries: [Entry] = [] {
        didSet {
            NotificationCenter.default.post(name: updateEntriesNotification, object: nil)
        }
    }
    
    func save(entry: Entry, completion: @escaping (Bool) -> Void) {
        let record = CKRecord(entry: entry)
        
        CKContainer.default().privateCloudDatabase.save(record) { (record, error) in
            if let error = error {
                print("Error saving to database: \(error)")
                completion(false)
            } else if let record = record {
                guard let entry = Entry(record: record) else { return }
                self.entries.append(entry)
                completion(true)
            }
        }
    }
    
    func addEntry(withTitle title: String, body: String, completion: @escaping (Bool) -> Void) {
        let entry = Entry(title: title, body: body)
    
        save(entry: entry) { (success) in
            if success {
                completion(true)
            } else {
                completion(false)
            }
        }
    }
    
    func fetchRecords(database: CKDatabase, completion: @escaping (Bool) -> Void) {
        
        ckManager.fetchRecords(ofType: Keys.entryKey, database: database) { (records, error) in
            if let error = error {
                print("Error fetching records", error)
            }
            
            guard let records = records else { return }
            self.entries = records.compactMap { Entry(record: $0) }
        }
    }
    
    func deleteRecord(entry: Entry, completion: @escaping (Bool) -> Void) {
        let database = CKContainer.default().privateCloudDatabase
            
        let recordID = entry.ckRecordID
        guard let index = self.entries.firstIndex(of: entry) else { return }
        self.entries.remove(at: index)
        print(recordID)
        database.delete(withRecordID: recordID) { (recordID, error) in
            if let error = error {
                print("Error deleting record from database: \(error)")
                completion(false)
            } else {
                completion(true)
            }
            
        }
    }
    
}
