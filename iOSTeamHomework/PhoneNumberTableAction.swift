//
//  PhoneNumberTableAction.swift
//  iOSTeamHomework
//
//  Created by Mike on 27/09/2017.
//  Copyright © 2017 gogolook. All rights reserved.
//

import UIKit

class PhoneNumberTableAction: PhoneNumberTableBehavior {
    
    func save() {
        let filePathUrl = PhoneNumberManager.sharedInstance.getFilePathURL(fileName: PhoneNumberManager.FILE_NAME)
        PhoneNumberManager.sharedInstance.save(url: filePathUrl)
    }
    
    func deleteRow(_ number: PhoneNumbers) {
        PhoneNumberManager.sharedInstance.remove(number)
    }

    func addRow(_ number: PhoneNumbers) -> Bool {
        
        if !PhoneNumberManager.sharedInstance.checkExists(number) {
            PhoneNumberManager.sharedInstance.add(number)
            return true
        }
        return false
    }

    func getRows(section: Int) -> [PhoneNumbers] {
        let code = PhoneNumberManager.sharedInstance.getCodes()[section]
        return PhoneNumberManager.sharedInstance.getNumbers(for: code)
    }

    func getSections() -> [Int] {
        return PhoneNumberManager.sharedInstance.getCodes()
    }
    
    func setCell(cell: UITableViewCell, phoneNumber: PhoneNumbers) {
        cell.textLabel?.text = "\(phoneNumber.number)"
        cell.detailTextLabel?.text = "\(phoneNumber.code) \(phoneNumber.number)"
    }
}
