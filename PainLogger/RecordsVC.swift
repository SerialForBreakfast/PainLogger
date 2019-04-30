//
//  ViewController.swift
//  PainLogger
//
//  Created by Joseph McCraw on 4/30/19.
//  Copyright © 2019 Joseph McCraw. All rights reserved.
//

import UIKit
import CloudKit

class RecordsVC: UITableViewController {
    
    @IBOutlet weak var table: UITableView!
 
    var notes = [Note]()
    var selectedRow:Int = -1
    var newRowText:String = ""
    var newRowTitleText:String = ""
    
    let privateDatabase = CKContainer.default().database(with: .private)
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if selectedRow == -1 {
            return
        }
        notes[selectedRow].noteBody = newRowText
        notes[selectedRow].noteTitle = newRowTitleText
        
        if newRowTitleText == "" {
            notes.remove(at: selectedRow)
        }
        table.reloadData()
        //save()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Create iCloud Containers
        //let defaultContainer = CKContainer.default()
        //let publicDatabase = defaultContainer.database(with: .public)
        //let sharedDatabase = defaultContainer.database(with: .shared)
        table.dataSource = self
        table.delegate = self
        guard let containerId = CKContainer.default().containerIdentifier else {
            return
        }
        print(containerId)
        
        loadFromCloud()
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        print("cell Row at Index Path \(indexPath.row)")
        cell.textLabel?.text = notes[indexPath.row].noteTitle
        cell.detailTextLabel?.text = notes[indexPath.row].noteBody
        return cell
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
                DispatchQueue.main.async {
                    self.table.reloadData()
                }

            }
        }
        
    }
    // Delete from iCloud
    public func deleteFromCloud(indexPath: IndexPath){
        
        let note = notes[indexPath.row]
        
        privateDatabase.delete(withRecordID: note.record!.recordID) { (recordID, error) in
            guard let recordID = recordID else{
                print("Error deleting record ", error!)
                return
            }
            DispatchQueue.main.async {
                self.notes.remove(at: indexPath.row)
                self.table.deleteRows(at: [indexPath], with: .fade)
                self.table.reloadData()
            }
            
            print("Succesfully deleted record \(recordID)")
        }
        
    }
    
    
}

