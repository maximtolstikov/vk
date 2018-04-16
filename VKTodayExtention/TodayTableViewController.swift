//
//  TodayTableViewController.swift
//  VKTodayExtention
//
//  Created by Maxim Tolstikov on 11/04/2018.
//  Copyright © 2018 Maxim Tolstikov. All rights reserved.
//

import UIKit
import NotificationCenter
import RealmSwift

class TodayTableViewController: UITableViewController, NCWidgetProviding {
    
    var news: Results <News>?
   
    override func viewDidLoad() {
        super.viewDidLoad()

        self.extensionContext?.widgetLargestAvailableDisplayMode = .expanded
        
        var config = Realm.Configuration()
        // Use the default directory, but replace the filename with the username
        config.fileURL = FileManager.default
            .containerURL(forSecurityApplicationGroupIdentifier: "group.ru.pricemin.VK")!
            .appendingPathComponent("Library/Caches/default.realm")
        // Set this as the configuration used for the default Realm
        Realm.Configuration.defaultConfiguration = config
        
        do{
            let realm = try Realm()
            news = realm.objects(News.self)

        } catch {
            print(error.localizedDescription)
        }
        
        tableView.reloadData()
    }


    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
        completionHandler(NCUpdateResult.newData)
    }
    
    @available(iOS 10.0, *)
    public func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {
        
        if activeDisplayMode == .expanded
        {
            self.preferredContentSize = CGSize(width: maxSize.width, height: maxSize.height)
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 20
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "todayCell", for: indexPath) as! TodayTableViewCell

        guard news != nil else {
            return cell
        }
        cell.avatarLable.text = news![indexPath.row].name_lable
        
        let url = URL(string: news![indexPath.row].icon_image)
        
        guard url != nil else {
            print("Url avaImage nil")
            return cell
        }
        
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            guard data != nil else {
                print(error?.localizedDescription)
                return
            }
            print("Data \(data)")
            cell.avatarImage.image = UIImage(data: data!)
        }.resume()
        
        

        

        return cell
    }

}
