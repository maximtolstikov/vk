//
//  AppDelegate.swift
//  VK
//
//  Created by Maxim Tolstikov on 02/02/2018.
//  Copyright © 2018 Maxim Tolstikov. All rights reserved.
//

import UIKit
import VK_ios_sdk
import Firebase
import UserNotifications
import RealmSwift
import WatchConnectivity

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, WCSessionDelegate {
    

    

    var window: UIWindow?
    var session: WCSession?

    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        VKSdk.processOpen(url, fromApplication: sourceApplication)
        return true
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        registerForBadgeNotifications()
        
        var config = Realm.Configuration()        
        // Use the default directory, but replace the filename with the username
        config.fileURL = FileManager.default
            .containerURL(forSecurityApplicationGroupIdentifier: "group.ru.pricemin.VK")!
            .appendingPathComponent("Library/Caches/default.realm")
        // Set this as the configuration used for the default Realm
        Realm.Configuration.defaultConfiguration = config
        
        if WCSession.isSupported(){
            session = WCSession.default
            session?.delegate = self
            session?.activate()
        }
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
    }

    func applicationWillTerminate(_ application: UIApplication) {
    }

    func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        let fetchRequestManager = FetchRequestManager()
        fetchRequestManager.getFetchRequest { (result) in

            guard result != nil else {
                completionHandler(.failed)
                return
            }
            if result == 0 {
                completionHandler(.noData)
            } else {
                self.incrementBadgeNumberBy(badgeNumberIncrement: result!)
                completionHandler(.newData)
            }
        }
    }
    
    func registerForBadgeNotifications() {
        UNUserNotificationCenter.current().requestAuthorization(options: .badge) {
            (granted, error) in
            print("Permission granted: \(granted)")
        }
    }
    
    func incrementBadgeNumberBy(badgeNumberIncrement: Int) {
        let currentBadgeNumber = UIApplication.shared.applicationIconBadgeNumber
        let updatedBadgeNumber = currentBadgeNumber + badgeNumberIncrement
        if (updatedBadgeNumber > -1) {
            UIApplication.shared.applicationIconBadgeNumber = updatedBadgeNumber
        }
    }
    
    private func session(_ session: WCSession, didReceiveMessageData message: [String: Any], replyHandler: @escaping ([String: Any]) -> Void) {    
        
        if message["request"] as! String == "news" {
            replyHandler(["textNews": "any text"])
        }
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
    }
    
    func sessionDidDeactivate(_ session: WCSession) {        
    }

}

