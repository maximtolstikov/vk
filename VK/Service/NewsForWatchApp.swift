//
//  NewsForWatchApp.swift
//  VK
//
//  Created by Maxim Tolstikov on 21/04/2018.
//  Copyright © 2018 Maxim Tolstikov. All rights reserved.
//

import RealmSwift

class NewsForWatchApp {
    
    var newsArray = [String: Any]()
    var sendArray = [[String: Any]]()
    let defaults = UserDefaults.standard
    
    func getArrayDataNews() -> [String: Any]{
        
//        for i in 1...5 {
//            let data = defaults.data(forKey: "image\(i)")
//            newsArray = ["image\(i)":data as! Data]
//            sendArray.append(newsArray)
//        }
        guard let data = defaults.data(forKey: "image0") else {
            return ["b":"b"]
        }
        
        print("data \(data)")
        
        return ["i":data]
    }
}

//
//let dataText = Data("some text 5".utf8)
//print("this")
//let image = #imageLiteral(resourceName: "like")
//let imageData = UIImagePNGRepresentation(image) as! Data

