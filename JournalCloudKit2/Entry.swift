//
//  Entry.swift
//  JournalCloudKit2
//
//  Created by Jason Goodney on 9/22/18.
//  Copyright © 2018 Jason Goodney. All rights reserved.
//

import Foundation
import CloudKit

struct Keys {
    static let entryKey = "Entry"
    static let titleKey = "title"
    static let bodyKey = "body"
}

struct Entry: Equatable {
    static func == (lhs: Entry, rhs: Entry) -> Bool {
        return
            lhs.body == rhs.body &&
            lhs.title == rhs.title
    }
    
    let title: String
    let body: String
    let ckRecordID: CKRecordID
    
    init(title: String, body: String, ckRecordID: CKRecordID = CKRecordID(recordName: UUID().uuidString)) {
        self.title = title
        self.body = body
        self.ckRecordID = ckRecordID
    }
    
    init?(record: CKRecord) {
        guard let title = record.object(forKey: Keys.titleKey) as? String,
            let body = record.object(forKey: Keys.bodyKey) as? String else { return nil }
        
        self.init(title: title, body: body, ckRecordID: record.recordID)
    }
}

extension CKRecord {
    convenience init(entry: Entry) {
        self.init(recordType: Keys.entryKey)
        
        self.setValue(entry.title, forKeyPath: Keys.titleKey)
        self.setValue(entry.body, forKeyPath: Keys.bodyKey)
        
    }
}
