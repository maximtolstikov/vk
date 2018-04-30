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
        //let text = String(data: defaults.value(forKey: "text") as! Data, encoding: String.Encoding.utf8)
        //let imageData = UIImage(data: defaults.value(forKey: "image") as! Data)
        
        //row.lable.setText(text)
        //row.image.setImage(imageData)
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
        if activationState == .activated {
            
            print("activated")
            
            session.sendMessage(["request":"news"], replyHandler: { (reply) in
                print("reply : \(reply)")
//                self.defaults.set(reply["text"], forKey: "text")
//                self.defaults.set(reply["image"], forKey: "image")
                
                self.update()
                
            }, errorHandler: { (error) in
                
                self.newsTable.setRowTypes(["NewTableViewControllerID"])
                let row = self.newsTable.rowController(at: 0) as! NewTableViewController
                row.lable.setText("Not a data!")
                print(error)
            })
            
        } else {
            self.newsTable.setRowTypes(["NewTableViewControllerID"])
            let row = self.newsTable.rowController(at: 0) as! NewTableViewController
            row.lable.setText("No connect!")
        }
    }
}
