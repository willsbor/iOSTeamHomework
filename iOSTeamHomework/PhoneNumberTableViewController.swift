//
//  PhoneNumberTableViewController.swift
//  iOSTeamHomework
//
//  Created by willsbor Kang on 2017/9/16.
//  Copyright © 2017年 gogolook. All rights reserved.
//

import UIKit

class PhoneNumberTableViewController: UITableViewController {
    
    private var tableAct: PhoneNumberTableBehavior!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableAct = PhoneNumberTableAction()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return tableAct.getSections().count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableAct.getRows(section: section).count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let code = tableAct.getSections()[section]
        return "\(code)"
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "default", for: indexPath)
        let section = indexPath.section
        let data = tableAct.getRows(section: section)[indexPath.row]
        tableAct.setCell(cell: cell, phoneNumber: data)
        
        return cell
    }

    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .delete
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deleteRow(indexPath: indexPath)
        }
    }
    
    private func deleteRow(indexPath: IndexPath) {
        let section = indexPath.section
        let data = tableAct.getRows(section: section)[indexPath.row]
        let isNeedsDeleteSec = tableAct.getRows(section: indexPath.section).count == 1
        tableAct.deleteRow(data)
        self.tableView.beginUpdates()
        if isNeedsDeleteSec {
            self.tableView.deleteSections(IndexSet(integer: indexPath.section), with: .automatic)
        }
        self.tableView.deleteRows(at: [indexPath], with: .automatic)
        self.tableView.endUpdates()
    }
    
    //MARK: - button actions
    @IBAction func addPhoneNumber() {
        switchToInputPage()
    }
    
    @IBAction func savePhoneNumbers() {
        tableAct.save()
    }
    
    //MARK: - switch page
    private func switchToInputPage() {
        
        if let icv = InputViewController.instantiate() {
            icv.setCallback { [weak self] (phoneNumber: PhoneNumbers) -> Bool in
                if let result = self?.tableAct.addRow(phoneNumber) {
                    self?.tableView.reloadData()
                    
                    return result
                } else {
                    return false
                }
            }
            self.navigationController?.present(icv, animated: true, completion: nil)
        }
    }
}
