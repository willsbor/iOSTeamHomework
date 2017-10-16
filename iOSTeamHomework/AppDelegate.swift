//
//  AppDelegate.swift
//  iOSTeamHomework
//
//  Created by willsbor Kang on 2017/9/16.
//  Copyright © 2017年 gogolook. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        let filePathUrl = PhoneNumberManager.sharedInstance.getFilePathURL(fileName: PhoneNumberManager.FILE_NAME)
        let _ = PhoneNumberManager.sharedInstance.load(url: filePathUrl)
        
        BackgroundSyncManager.sharedInstance.apiManager = FakeAPIManager()
        BackgroundSyncManager.sharedInstance.dataAccessLayer = PhoneNumberManager.sharedInstance
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        BackgroundSyncManager.sharedInstance.syncToServer()
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        BackgroundSyncManager.sharedInstance.syncFromServer()
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

extension PhoneNumberManager: PhoneNumberSavable {
    func getCurrentData() -> [String : Any] {
        return [String : Any]() //< TODO
    }
    
    func save(_ numberData: [String : Any]) {
        numberData
            .map({ (_, _) -> PhoneNumbers in
                return PhoneNumbers(code: 0, number: 0)  //< TODO
            })
            .forEach({ (number) in
                self.add(number)
            })
        
        let filePathUrl = getFilePathURL(fileName: PhoneNumberManager.FILE_NAME)
        save(url: filePathUrl)
    }
}

class FakeAPIManager: APIManaging {
    func get(_ completionHandler: @escaping (BackgroundSyncManager.ServerResult) -> Void) {
        DispatchQueue.global().async {
            completionHandler(.success([:]))
        }
    }
    
    func update(_ data: [String : Any], _ completionHandler: @escaping (BackgroundSyncManager.ServerResult) -> Void) {
        DispatchQueue.global().async {
            completionHandler(.success([:]))
        }
    }
    
    
}
