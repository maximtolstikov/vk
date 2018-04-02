//
//  GroupService.swift
//  VK
//
//  Created by Maxim Tolstikov on 08/02/2018.
//  Copyright © 2018 Maxim Tolstikov. All rights reserved.
//
import UIKit
import SwiftyJSON
import RealmSwift

import UIKit

class GroupService {
    
    let apiManager = ApiManager()
    
    func updateGroups() {
        
        apiManager.getGroupsJson {[weak self] (json, error) in
            
            guard (json?.null) == nil else {
                print(error?.localizedDescription as Any)
                return}
            self?.processingData(json: json!)
        }
    }
    
    func processingData(json:JSON) {
        
        DispatchQueue.global(qos: .userInteractive).async {
            let json = JSON(json)
            let groups = json["response"]["items"].flatMap({Group(json: $0.1)})
            self.saveGroupData(groups)
        }
    }    
    
    func saveGroupData(_ groups: [Group]) {        
        do{
            let realm = try Realm()
            //print(realm.configuration.fileURL)
            let oldData = realm.objects(Group.self)
            realm.beginWrite()
            realm.delete(oldData)
            realm.add(groups)
            try realm.commitWrite()           
        } catch {
            print(error.localizedDescription)
        }
    }
    func addCacheUrl(cache_icon: String, id: Int) {
        do{
            guard let realm = try? Realm() else {return}
            let group = realm.objects(Group.self).filter("id==%@", id)
            realm.beginWrite()
            group[0].cashed_icon = cache_icon
            realm.add(group[0])
            try realm.commitWrite()
            print("Save realm")
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func deleteGroup(groupId: Int){
        do{
            let realm = try Realm()
            let group = realm.objects(Group.self).filter("id==%@", groupId)
            realm.beginWrite()
            realm.delete(group)
            try realm.commitWrite()
        } catch {
            print(error.localizedDescription)
        }
    }
    

    
    
    
    
    
    
    
    
    
    
}
