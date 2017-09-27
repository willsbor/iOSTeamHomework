//
//  PhoneNumberManager.swift
//  iOSTeamHomework
//
//  Created by willsbor Kang on 2017/9/16.
//  Copyright © 2017年 gogolook. All rights reserved.
//

import Foundation


class PhoneNumberManager {
    
    static let sharedInstance = PhoneNumberManager()
    static let dataChangedNotification: Notification.Name = Notification.Name("PhoneNumberManager.dataChangedNotification")
    static let FILE_NAME = "numbers.dat"
    
    private(set) var numbers: [PhoneNumbers] = [] {
        didSet {
            NotificationCenter.default.post(name: PhoneNumberManager.dataChangedNotification, object: nil)
        }
    }
    
    func checkExists(_ phoneNumber: PhoneNumbers) -> Bool {
        return numbers.filter({ (data) -> Bool in
            return (data.code == phoneNumber.code && data.number == phoneNumber.number)
        }).count > 0
    }
    
    func add(_ number: PhoneNumbers) {
        numbers.append(number)
    }
    
    func remove(_ number: PhoneNumbers) {
        let index = numbers.index { (data) -> Bool in
            return data.code == number.code && data.number == number.number
        }
        
        if let index = index {
            numbers.remove(at: index.advanced(by: 0))
        }
    }
    
    func getCodes() -> [Int] {
        return numbers.map({ (data) -> Int in
            return data.code
            
        }).reduce([], { (result, code) -> [Int] in
            if result.contains(code) {
                return result
            }
            
            var next = result
            next.append(code)
            return next
        }).sorted(by: <)
    }
    
    func getNumbers(`for` code: Int) -> [PhoneNumbers] {
        return numbers.filter({ (data) -> Bool in
            return data.code == code
        }).sorted(by: { (pre, next) -> Bool in
            return pre.number < next.number
        })
    }
    
    func load(url: URL) -> [PhoneNumbers]{
        do {
            let targetURL = url
            numbers.removeAll()
            let data = try Data(contentsOf: targetURL)
            if let json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions(rawValue: 0)) as? [[String: Int]] {
                numbers = json.map({ (item) -> PhoneNumbers in
                    return PhoneNumbers(code: item[PhoneNumbers.KEY_CODE]!, number: item[PhoneNumbers.KEY_NUMBER]!)
                })
            }
            
        } catch let error {
            print("\(error)")
        }
        
        return numbers
    }
    
    func save(url: URL) {
        let json = numbers.map { (data) -> [String: Int] in
            return [PhoneNumbers.KEY_CODE: data.code,
                    PhoneNumbers.KEY_NUMBER: data.number]
        }
        
        do {
            let data = try JSONSerialization.data(withJSONObject: json, options: JSONSerialization.WritingOptions(rawValue: 0))
            
            let targetURL = url
            try data.write(to: targetURL)
        } catch let error {
            print("\(error)")
        }
    }
    
    func getFilePathURL(fileName: String) -> URL {
        let tempDirectoryURL = URL(fileURLWithPath: NSTemporaryDirectory(), isDirectory: true)
        let targetURL = tempDirectoryURL.appendingPathComponent(fileName)
        
        return targetURL
    }
}
