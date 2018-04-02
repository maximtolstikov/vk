//
//  UserService.swift
//  VK
//
//  Created by Maxim Tolstikov on 08/02/2018.
//  Copyright © 2018 Maxim Tolstikov. All rights reserved.
//

import UIKit
import SwiftyJSON
import RealmSwift

class FriendService {
    
    let apiManager = ApiManager()
    
    func updateFriends() {
        
        apiManager.getFriendsJson {[weak self] (json, error) in
            
            guard (json?.null) == nil else {
                print(error?.localizedDescription as Any)
                return}            
            self?.processingData(json: json!)
        }
    }
    
    func processingData(json: JSON) {
        
        DispatchQueue.global(qos: .userInteractive).async {
            let json = JSON(json)
            let users = json["response"]["items"].flatMap({Friend(json: $0.1)})
            self.saveUserData(users)
        }
    }
    
    func saveUserData(_ users: [Friend]) {
        
        do{
            let realm = try Realm()
            let oldData = realm.objects(Friend.self)
            realm.beginWrite()
            realm.delete(oldData)
            realm.add(users)
            try realm.commitWrite()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func addCacheUrl(cache_icon: String, id: Int) {
        do{
            //(cache_icon)
            guard let realm = try? Realm() else {return}
            let user = realm.objects(Friend.self).filter("id==%@", id)
            realm.beginWrite()
            user[0].cashed_icon = cache_icon
            realm.add(user[0])
            try realm.commitWrite()
        } catch {
            print(error.localizedDescription)
        }
    }
    
}
