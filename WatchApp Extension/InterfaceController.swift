//
//  InterfaceController.swift
//  WatchApp Extension
//
//  Created by Maxim Tolstikov on 19/04/2018.
//  Copyright © 2018 Maxim Tolstikov. All rights reserved.
//

import WatchKit
import WatchConnectivity


class InterfaceController: WKInterfaceController, WCSessionDelegate {
   
    @IBOutlet var newsTable: WKInterfaceTable!
    
    var session: WCSession?
    let defaults = UserDefaults.standard
    

    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
        if WCSession.isSupported(){
            session = WCSession.default
            session?.delegate = self
            session?.activate()
        }
    }

    func update(){
        
        newsTable.setNumberOfRows(1, withRowType: "NewTableViewControllerID")
        let row = newsTable.rowController(at: 0) as! NewTableViewController
        row.lable.setText(defaults.value(forKey: "textNews") as? String)
        
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
        if activationState == .activated {
            //update()
            session.sendMessage(["request" : "news"], replyHandler: { (reply) in
                print(reply)
               //self.defaults.set(reply["textNews"], forKey: "textNews")
            }, errorHandler: { (error) in
                self.newsTable.setRowTypes(["NewTableViewControllerID"])
                let row = self.newsTable.rowController(at: 0) as! NewTableViewController
                row.lable.setText("Not data!")
                print(error.localizedDescription)
            })
        } else {
            self.newsTable.setRowTypes(["NewTableViewControllerID"])
            let row = self.newsTable.rowController(at: 0) as! NewTableViewController
            row.lable.setText("No connect!")
        }
    }
}
