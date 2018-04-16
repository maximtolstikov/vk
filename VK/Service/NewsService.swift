//
//  NewsService.swift
//  VK
//
//  Created by Maxim Tolstikov on 18/02/2018.
//  Copyright © 2018 Maxim Tolstikov. All rights reserved.
//

import UIKit
import SwiftyJSON
import RealmSwift

class NewsService {
    
    let apiManager = ApiManager()
    var profiles = [Profiles]()
    var groups = [Groups]()
    
    func updateNews() {
               
        apiManager.getNewsJson {[weak self] (jsonNews, error) in
            
            guard (jsonNews?.null) == nil else {
                print(error?.localizedDescription as Any)
                return}
            self?.processingData(json: jsonNews!)
        }
    }
    
    func processingData(json: JSON) {
        
        DispatchQueue.global(qos: .userInteractive).async {
            let json = JSON(json)
            let news = json["response"]["items"].flatMap({News(json: $0.1)})
            self.profiles = json["response"]["profiles"].flatMap({Profiles(json: $0.1)})
            self.groups = json["response"]["groups"].flatMap({Groups(json: $0.1)})
            self.saveNewsData(news: news)
        }
    }
        //MARK: определение профиь или группа
        func checkProfileOrGroup(source_id: Int) -> Bool {
    
            for i in profiles {
                if i.id == abs(source_id){
                    return true
                }
            }
            return false
        }
    
    func saveNewsData( news: [News]) {
                
        do{            
            let realm = try Realm()
            //print(realm.configuration.fileURL)
            let oldNews = realm.objects(News.self)
            let oldPhoto = realm.objects(Photo.self)
            let oldComments = realm.objects(Comments.self)
            let oldLikes = realm.objects(Likes.self)
            let oldReposts = realm.objects(Reposts.self)
            let oldViews = realm.objects(Views.self)
            
            for i in news {
                let numberId = abs(i.source_id)
                if checkProfileOrGroup(source_id: numberId) {
                    for profile in profiles {
                        if numberId == profile.id {
                            i.name_lable = profile.first_name + " " + profile.last_name
                            i.icon_image = profile.photo_50
                            break
                        }
                    }
                }
                else {
                    for group in groups {
                        if numberId == group.id {
                            i.name_lable = group.name
                            i.icon_image = group.photo_50
                            break
                        }
                    }
                }
            }
            
            realm.beginWrite()
            realm.delete(oldNews)
            realm.delete(oldPhoto)
            realm.delete(oldComments)
            realm.delete(oldLikes)
            realm.delete(oldReposts)
            realm.delete(oldViews)
            realm.add(news)
            try realm.commitWrite()
            saveNewsForToday(news: news)
            
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func addCacheUrlNewsContent(cache_photo: String, id: Int) {
        do{
            guard let realm = try? Realm() else {return}
            let photo = realm.objects(Photo.self).filter("id==%@", id)
            realm.beginWrite()
            photo[0].cashed_photo = cache_photo
            realm.add(photo[0])
            try realm.commitWrite()
            print("Save realm (News cacheFoto)")
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func addCacheUrlProfile(cache_photo: String, id: Int) {
        do{            
            guard let realm = try? Realm() else {return}
            let photo = realm.objects(Profiles.self).filter("id==%@", id)
            realm.beginWrite()
            photo[0].cashed_icon = cache_photo
            realm.add(photo[0])
            try realm.commitWrite()
            print("Save realm (Profiles cashed icon)")
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func saveNewsForToday(news: [News]) {
        
        let defaults = UserDefaults(suiteName: "group.ru.pricemin.VK")
        defaults?.set(news[0].name_lable, forKey: "avatarLable")
        defaults?.synchronize()

    }

}


