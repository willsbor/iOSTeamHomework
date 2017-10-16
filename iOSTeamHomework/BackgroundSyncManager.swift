//
//  BackgroundSyncManager.swift
//  iOSTeamHomework
//
//  Created by willsbor Kang on 2017/10/2.
//  Copyright © 2017年 gogolook. All rights reserved.
//

import Foundation

protocol APIManaging {
    func get(_ completionHandler: @escaping (BackgroundSyncManager.ServerResult) -> Void)
    func update(_ data: [String: Any], _ completionHandler: @escaping (BackgroundSyncManager.ServerResult) -> Void)
}

protocol PhoneNumberSavable {
    func save(_ numberData: [String: Any])
    func getCurrentData() -> [String: Any]
}

class BackgroundSyncManager {
    static let sharedInstance = BackgroundSyncManager()
    
    enum ServerResult {
        case success([String: Any])
        case failed(Error)
    }
    
    var apiManager: APIManaging!
    var dataAccessLayer: PhoneNumberSavable!
    
    func syncFromServer() {
        apiManager.get { (result) in
            switch result {
            case .success(let data):
                self.dataAccessLayer.save(data)
            case .failed(let error):
                print("failed \(error)")
            }
        }
    }
    
    func syncToServer() {
        
        apiManager.update(dataAccessLayer.getCurrentData()) { (result) in
            switch result {
            case .success(let data):
                print("success \(data)")
            case .failed(let error):
                print("\(error)")
            }
        }
    }
}
