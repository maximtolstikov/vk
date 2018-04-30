//
//  APImanager.swift
//  VK
//
//  Created by Maxim Tolstikov on 23/03/2018.
//  Copyright © 2018 Maxim Tolstikov. All rights reserved.
//
import VK_ios_sdk
import Alamofire
import SwiftyJSON
import Foundation

class ApiManager {
    
    let id = Int(VKSdk.accessToken().userId)
    let verApi: String = "&v=5.73"
    let baseUrl: String = "https://api.vk.com/method/"
    let token: String = "&access_token=\(VKSdk.accessToken().accessToken!)"
    let userId: String = "?user_ids=\(VKSdk.accessToken().userId!)"
    let ownerId: String = "?owner_id=\(VKSdk.accessToken().userId!)"
    
    //MARK: обновление списка групп
    func getGroupsJson(complitionHandler: @escaping (JSON?, Error?) ->()) {
        let path: String = "\(baseUrl)groups.get\(userId)\(token)&extended=1&v=5.71"
        let url = URL(string: path)
        
        guard url != nil else {
            print("пустой url")
            return}
        Alamofire.request(url!, method: .get).validate().responseJSON { response in
            
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                complitionHandler(json, nil)
            case .failure(let error):
                complitionHandler(nil, error)
            }            
        }
    }
    
    //MARK: получение запроса друзей
    func getFriendsJson(complitionHandler: @escaping (JSON?, Error?) ->()) {
        
        let path: String = "\(baseUrl)friends.get\(userId)\(token)&fields=nikname,photo_50,photo_400_orig\(verApi)"
        let url = URL(string: path)
        
        guard url != nil else {
            print("пустой url")
            return}
        Alamofire.request(url!, method: .get).validate().responseJSON { response in
            
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                complitionHandler(json, nil)
            case .failure(let error):
                complitionHandler(nil, error)
            }
        }
    }
    //MARK: Получение новостей
    func getNewsJson(complitionHandler: @escaping (JSON?, Error?) ->()) {
        
        let path: String = "\(baseUrl)newsfeed.get\(userId)\(token)&filters=post&count=10\(verApi)"
        let urlNews = URL(string: path)
        
        guard urlNews != nil else {
            print("пустой url")
            return}
        Alamofire.request(urlNews!, method: .get).validate().responseJSON { response in
            
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                complitionHandler(json, nil)
            case .failure(let error):
                complitionHandler(nil, error)
            }            
        }
    }
    //MARK: методы управлением группами
    
    func deleteGroup(groupId: Int, complitionHandler: @escaping (JSON?, Error?) ->()){
        
        let path: String = "\(baseUrl)groups.leave\(userId)\(token)&group_id=\(groupId)\(verApi)"
        let url = URL(string: path)
        
        guard url != nil else {
            print("пустой url")
            return}
        Alamofire.request(url!, method: .get).validate().responseJSON { response in
            
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                complitionHandler(json, nil)
            case .failure(let error):
                complitionHandler(nil, error)
            }
        }
    }
    
    func joinGroup(groupId: Int) {
        
        let path: String = "\(baseUrl)groups.join\(userId)\(token)&group_id=\(groupId)\(verApi)"
        let url = URL(string: path)
        
        guard url != nil else {
            print("пустой url")
            return}
        Alamofire.request(url!, method: .get).validate().responseJSON { response in
            
            // _ = JSON(response.value!)
            
        }
    }
    
    func searchGroups( q: String, complition: @escaping ([Group]) -> ()) {
        
        let path: String = "\(baseUrl)groups.search\(userId)\(token)&q=\(q)&count=10\(verApi)"
        let stringEncoding = path.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        guard stringEncoding != nil else {
            print("stringEncoding is nil")
            return
        }
        let url = URL(string: stringEncoding!)
        
        guard url != nil else {
            print("пустой url")
            return}
        
        print("url \(url)")
        
        Alamofire.request(url!, method: .get)
            .validate().responseJSON { response in
                
                guard response.value != nil else {
                    print("response.value is nil (request search group)")
                    return
                }
                
                let json = JSON(response.value!)
                DispatchQueue.global(qos: .userInteractive).async {
                    let json = JSON(json)
                    let groups = json["response"]["items"].flatMap({Group(json: $0.1)})
                    complition(groups)
                }
        }
        
        
    }
    
    func addPost(text: String) {
        
        let path: String = "\(baseUrl)wall.post\(userId)\(token)&message=\(text)\(verApi)"
        let url = URL(string: path)
        
        guard url != nil else {
            print("Wrong url in addPost")
            return}
        Alamofire.request(url!, method: .get).validate().responseJSON { response in
            //let json = JSON(response.value!)
        }
    }

    func getRequestFrends(complition: @escaping ([Int]) -> ()) {
        
        let path: String = "\(baseUrl)friends.getRequests\(userId)\(token)&need_viewed=1\(verApi)"
        let url = URL(string: path)
        
        guard url != nil else {
            return}
        Alamofire.request(url!, method: .get).validate().responseJSON { response in
            let json = JSON(response.value!)
            let array = json["response"]["items"].arrayValue
            var arrayInt = [Int]()
            for i in array {
                arrayInt.append(i.intValue)
            }
            complition(arrayInt)
        }
    }
    
    func addFriend(id: Int, complition: @escaping (Bool) -> ()) {

        let path: String = "\(baseUrl)friends.add\(userId)\(token)&user_id=\(id)\(verApi)"
        let url = URL(string: path)
        
        guard url != nil else {return}
        Alamofire.request(url!, method: .get).validate().responseJSON { response in
            
            guard response.value != nil else {return}
            let json = JSON(response.value!)
            let response = json["response"].intValue

            if response == 2 {
                complition(true)
                return
            }
            complition(false)
        }
    }
    
}
