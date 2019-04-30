//
//  Note.swift
//  PainLogger
//
//  Created by Joseph McCraw on 4/30/19.
//  Copyright © 2019 Joseph McCraw. All rights reserved.
//

import Foundation
import CloudKit

class Note: NSObject{
    var record: CKRecord?
    var noteTitle: String?{
        didSet{
            record!["title"] = noteTitle
        }
    }
    
    var noteBody: String?{
        didSet{
            record!["note"] = noteBody
        }
    }
    var painLevel: Double?{
        didSet{
            record!["painLevel"] = painLevel
        }
    }
    
    init(record: CKRecord){
        self.record = record
        self.noteTitle = self.record!["title"] as? String
        self.noteBody = self.record!["note"] as? String
        self.painLevel = self.record!["painLevel"] as? Double
 
    }
    
    
    convenience init(title: String, body: String) {
        self.init(record: CKRecord(recordType: "Notes", recordID: CKRecord.ID(recordName: UUID().uuidString)))
        self.noteTitle = title
        self.noteBody = body
    }
    
    
}
