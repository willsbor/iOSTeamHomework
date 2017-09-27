//
//  iOSTeamHomeworkTests.swift
//  iOSTeamHomeworkTests
//
//  Created by willsbor Kang on 2017/9/16.
//  Copyright © 2017年 gogolook. All rights reserved.
//

import XCTest
@testable import iOSTeamHomework

class iOSTeamHomeworkTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
 
    func createTempFileWithData(_ filePathURL: URL) {
        do {
            let str = ""
            try str.write(to: filePathURL, atomically: false, encoding: String.Encoding.utf8)
        } catch let error {
            print("\(error)")
        }
    }
    
    func testPhoneNumerManager() {
        
        let TEST_FILE_NAME = "test.dat"
        let filePathURL = PhoneNumberManager.sharedInstance.getFilePathURL(fileName: TEST_FILE_NAME)
        
        createTempFileWithData(filePathURL)
        
        var loadResults = PhoneNumberManager.sharedInstance.load(url: filePathURL)
        XCTAssert(loadResults.count == 0, "PhoneNumberManager load() fail.")
        
        var codes: [Int]
        var numbers: [PhoneNumbers]

        codes = PhoneNumberManager.sharedInstance.getCodes()
        XCTAssert(codes.count == 0, "PhoneNumberManager getCodes() amount fail.")
        
        numbers = PhoneNumberManager.sharedInstance.getNumbers(for: 1)
        XCTAssert(numbers.count == 0, "PhoneNumberManager getNumbers() amount fail.")
        
        let TEST_AMOUNT = 3
        for i in 1...TEST_AMOUNT {
            let number = PhoneNumbers(code: i, number: i)
            PhoneNumberManager.sharedInstance.add(number)
        }
        
        codes = PhoneNumberManager.sharedInstance.getCodes()
        XCTAssert(codes.count == TEST_AMOUNT, "PhoneNumberManager add() fail.")
        if codes.count == TEST_AMOUNT {
            XCTAssert(codes[0] == 1, "PhoneNumberManager getCodes() content fail after add().")
        }
        
        numbers = PhoneNumberManager.sharedInstance.getNumbers(for: 1)
        XCTAssert(numbers.count == 1, "PhoneNumberManager add() fail.")
        if numbers.count == 1 {
            XCTAssert(numbers[0].code == 1, "PhoneNumberManager getNumbers() code content fail after add().")
            XCTAssert(numbers[0].number == 1, "PhoneNumberManager getNumbers() number content fail after add().")
        }
        
        let number = PhoneNumbers(code: 1, number: 1)
        PhoneNumberManager.sharedInstance.remove(number)
        
        codes = PhoneNumberManager.sharedInstance.getCodes()
        XCTAssert(codes.count == TEST_AMOUNT-1, "PhoneNumberManager remove() fail.")
        if codes.count == TEST_AMOUNT-1 {
            XCTAssert(codes[0] == 2, "PhoneNumberManager getCodes() content fail after remove().")
        }
        
        numbers = PhoneNumberManager.sharedInstance.getNumbers(for: 1)
        XCTAssert(numbers.count == 0, "PhoneNumberManager remove() fail.")
        if numbers.count == 2 {
            XCTAssert(numbers[0].code == 2, "PhoneNumberManager getNumbers() code content fail after remove().")
            XCTAssert(numbers[0].number == 2, "PhoneNumberManager getNumbers() number content fail after remove().")
        }
        
        PhoneNumberManager.sharedInstance.save(url: filePathURL)
        loadResults = PhoneNumberManager.sharedInstance.load(url: filePathURL)
        XCTAssert(loadResults.count == 2, "PhoneNumberManager save() fail.")
        
        do {
            let fileManager = FileManager.default
            try fileManager.removeItem(at: filePathURL)
        } catch let error {
            print("\(error)")
        }
    }
}
