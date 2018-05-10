//
//  NewsService.swift
//  WatchApp Extension
//
//  Created by Maxim Tolstikov on 08/05/2018.
//  Copyright © 2018 Maxim Tolstikov. All rights reserved.
//

import Foundation
import SwiftyJSON

class NewsServiceWatchApp {
    
    func getNewsArray(data: Data, complition: @escaping (([News]) -> Void)){
        
        var outPutArray = [News]()
        
        let json = try? JSON(data: data)
        guard json != nil else {return}
        let profilesArray = json!["response"]["profiles"].flatMap({ Profiles(json: $0.1)})
        let groupsArray = json!["response"]["groups"].flatMap({ Groups(json: $0.1)})
        let newsArray = json!["response"]["items"].flatMap({ News(json: $0.1)})
        
        for var i in newsArray{
                     
            if let j = profilesArray.index(where: { $0.id == i.source_id }){
                
                let profile = profilesArray[j]
                i.name = profile.name
                i.avatar = profile.photo_50
                outPutArray.append(i)
                
            } else if let k = groupsArray.index(where: { $0.id == i.source_id }){
                
                let group = groupsArray[k]
                i.name = group.name
                i.avatar = group.photo_50
                outPutArray.append(i)
            }
        }
        
        complition(outPutArray)
    }
    
    func getPhoto(photo: String,  completion: @escaping(Data) -> Void) {

        let url = URL(string: photo)
        
        //задача для запуска
        URLSession.shared.dataTask(with: url!){(data, response, error) in
            
            guard let data = data else {return}
            completion(data)           
            
            }.resume()
    }

}
