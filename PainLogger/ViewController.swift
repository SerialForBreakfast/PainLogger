//
//  ViewController.swift
//  PainLogger
//
//  Created by Joseph McCraw on 4/30/19.
//  Copyright © 2019 Joseph McCraw. All rights reserved.
//

import UIKit
import CloudKit

class ViewController: UIViewController {
    var notes = [Note]()
    let privateDatabase = CKContainer.default().database(with: .private)

    override func viewDidLoad() {
        super.viewDidLoad()
        // Create iCloud Containers
        //let defaultContainer = CKContainer.default()
        //let publicDatabase = defaultContainer.database(with: .public)
        //let sharedDatabase = defaultContainer.database(with: .shared)
        
        guard let containerId = CKContainer.default().containerIdentifier else {
            return
        }
        print(containerId)
        
        loadFromCloud()
    }
    
    public func loadFromCloud() {
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: "Notes", predicate: predicate)
        
        //Fetch records
        privateDatabase.perform(query, inZoneWith: nil) { (results, error) in
            
            guard error == nil else{
                print("Error \(String(describing: error?.localizedDescription))")
                return
            }
            
            if let notes = results{
                print(notes)
                for note in notes{
                    let aNote = Note(record:note)
                    self.notes.append(aNote)
                }
            }
        }
        
    }
}

