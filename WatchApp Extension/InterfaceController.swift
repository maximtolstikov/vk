//
//  InterfaceController.swift
//  WatchApp Extension
//
//  Created by Maxim Tolstikov on 19/04/2018.
//  Copyright © 2018 Maxim Tolstikov. All rights reserved.
//

import WatchKit
import WatchConnectivity
import SwiftyJSON


class InterfaceController: WKInterfaceController, WCSessionDelegate {
   
    @IBOutlet var newsTable: WKInterfaceTable!
    
    var session: WCSession?
    let defaults = UserDefaults.standard
    let service = NewsServiceWatchApp()
    var arrayNews = [News]()

    
    override func willActivate() {
        super.willActivate()
        
        if WCSession.isSupported(){
            session = WCSession.default
            session?.delegate = self
            session?.activate()
        }
    }
    
    func update(){
        
        newsTable.setNumberOfRows(arrayNews.count, withRowType: "NewTableViewControllerID")
        
        for (i, new) in arrayNews.enumerated(){
            
            print(new.contentImageFriend)
            
            let row = newsTable.rowController(at: i) as! NewTableViewController
            let text = String(new.name)
            
            self.service.getPhoto(photo: new.avatar, completion: { (data) in
                let image = UIImage(data: data)
                DispatchQueue.main.async {
                    row.image.setImage(image)
                }
            })
            
            let contentGroup: String = new.contentImageGroup
            let contentFriend: String = new.contentImageFriend
            var url: URL?
            
            if contentGroup != "" {
                url = URL(string: contentGroup)
            } else if contentFriend != "" {
                url = URL(string: contentFriend)
            }
            
            if url != nil {
            URLSession.shared.dataTask(with: url!) { (data, response, errore) in
                guard data != nil else {return}
                DispatchQueue.main.async {
                    let image = UIImage(data: data!)
                    row.contentImage.setImage(image)
                }
                }.resume()
            }
            
            row.lable.setText(text)
        }
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
        if activationState == .activated {
            
            print("activated")
            
            session.sendMessage(["request":"news"], replyHandler: { (reply) in
               
                let data = reply["newsData"] as! Data
                self.service.getNewsArray(data: data, complition: { [weak self] (news) in
                    self?.arrayNews = news
                })
                
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
