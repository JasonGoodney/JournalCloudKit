//
//  CloudKitManager.swift
//  JournalCloudKit2
//
//  Created by Jason Goodney on 9/22/18.
//  Copyright © 2018 Jason Goodney. All rights reserved.
//

import Foundation
import CloudKit

class CloudKitManager {
    
    func saveRecordsToCloudKit(record: CKRecord, database: CKDatabase, completion: @escaping (Error?) -> Void = { _ in }) {
        
        
        database.save(record) { (_, error) in
            if let error = error {
                print("Error saving recoring to cloud kit", error)
                completion(error)
            }
            completion(nil)
        }
    }
    
    // Perform query to fetch records
    func fetchRecords(ofType type: String, database: CKDatabase, completion: @escaping ([CKRecord]?, Error?) -> Void) {
        
        let predicate = NSPredicate(value: true)
        
        let query = CKQuery(recordType: type, predicate: predicate)
        
        database.perform(query, inZoneWith: nil, completionHandler: completion)
    }
    
    
    func delete(entry: Entry, database: CKDatabase, completion: @escaping (Bool) -> Void) {
        let ckRecordID = entry.ckRecordID
        database.delete(withRecordID: ckRecordID) { (ckRecordID, error) in
            if let error = error {
                print("Error deleting record form database: \(error)")
                completion(false)
            }
        
            completion(true)
        }
    }
}
