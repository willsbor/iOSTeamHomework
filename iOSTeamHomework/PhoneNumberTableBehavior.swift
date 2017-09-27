//
//  PhoneNumberTableBehavior.swift
//  iOSTeamHomework
//
//  Created by Mike on 27/09/2017.
//  Copyright © 2017 gogolook. All rights reserved.
//

import UIKit

protocol PhoneNumberTableBehavior {
    
    func getSections() -> [Int]
    func getRows(section: Int) -> [PhoneNumbers]
    func addRow(_ number: PhoneNumbers) -> Bool
    func deleteRow(_ number: PhoneNumbers)
    func save()
    func setCell(cell: UITableViewCell, phoneNumber: PhoneNumbers)
}
