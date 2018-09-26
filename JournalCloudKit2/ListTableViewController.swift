
//
//  ListTableViewController.swift
//  JournalCloudKit2
//
//  Created by Jason Goodney on 9/22/18.
//  Copyright © 2018 Jason Goodney. All rights reserved.
//

import UIKit
import CloudKit

class ListTableViewController: UITableViewController {

    let cellId = String(describing: UITableViewCell.self)
    
    var entries: [Entry] {
        
        return EntryController.shared.entries
    }
    
    lazy var addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Journal"
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadTableView), name: updateEntriesNotification, object: nil)
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        EntryController.shared.fetchRecords(database: CKContainer.default().privateCloudDatabase) { (success) in
            if success {
                UIApplication.shared.isNetworkActivityIndicatorVisible = true
                self.reloadTableView()
            }
        }

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        
        navigationItem.rightBarButtonItem = addButton
    }
    
    @objc func reloadTableView() {
        DispatchQueue.main.async {
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            self.tableView.reloadData()
        }
    }
    
    @objc func addButtonTapped() {
        let detailVC = EntryDetailViewController()
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
        return entries.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell(style: .subtitle, reuseIdentifier: cellId)
        cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)

        let entry = entries[indexPath.row]
        cell.textLabel?.text = entry.title
        cell.detailTextLabel?.text = entry.body
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let entry = entries[indexPath.row]
        let detailVC = EntryDetailViewController(entry: entry)
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let entry = entries[indexPath.row]
            EntryController.shared.deleteRecord(entry: entry) { (success) in
                if success{
                    print("Deleted entry")
                }
            }

        }
    }



}
