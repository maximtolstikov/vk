//
//  News.swift
//  VK
//
//  Created by Maxim Tolstikov on 19/02/2018.
//  Copyright © 2018 Maxim Tolstikov. All rights reserved.
//
import RealmSwift
import SwiftyJSON

class Profiles: Object{
    @objc dynamic var id: Int = 0
    @objc dynamic var first_name: String = ""
    @objc dynamic var last_name: String = ""
    @objc dynamic var photo_50: String = ""
    @objc dynamic var cashed_icon: String = ""
    
    convenience init(json: JSON) {
        self.init()
        
        self.id = json["id"].intValue
        self.first_name = json["first_name"].stringValue
        self.last_name = json["last_name"].stringValue
        self.photo_50 = json["photo_50"].stringValue
    }
}
    class Groups: Object{
        @objc dynamic var id: Int = 0
        @objc dynamic var name: String = ""
        @objc dynamic var photo_50: String = ""
        @objc dynamic var cashed_icon: String = ""
        
        convenience init(json: JSON) {
            self.init()
            
            self.id = json["id"].intValue
            self.name = json["name"].stringValue
            self.photo_50 = json["photo_50"].stringValue
            
        }
}

class News: Object{
    
    @objc dynamic var type: String = ""
    @objc dynamic var source_id: Int = 0
    @objc dynamic var date: Int = 0
    @objc dynamic var post_id: Int = 0
    @objc dynamic var post_type: String = ""
    @objc dynamic var final_post: Int = 0
    @objc dynamic var text: String = ""
    @objc dynamic var comments: Comments?
    @objc dynamic var likes: Likes?
    @objc dynamic var reposts: Reposts?
    @objc dynamic var views: Views?
    var photo: List = List<Photo>()
    @objc dynamic var signer_id: Int = 0
    @objc dynamic var marked_as_ads: Int = 0
    @objc dynamic var name_lable: String = ""
    @objc dynamic var icon_image: String = ""

    
    convenience init(json: JSON) {
        self.init()
        
        self.type = json["type"].stringValue
        self.source_id = json["source_id"].intValue
        self.date = json["date"].intValue
        self.post_id = json["post_id"].intValue
        self.post_type = json["post_type"].stringValue
        self.final_post = json["final_post"].intValue
        self.text = json["text"].stringValue
        self.signer_id = json["signer_id"].intValue
        self.marked_as_ads = json["marked_as_ads"].intValue
        self.comments = Comments(json: json)
        self.likes = Likes(json: json)
        self.reposts = Reposts(json: json)
        self.views = Views(json: json)
        
        for attach in json["attachments"].arrayValue {
            self.photo.append(Photo(json: attach ["photo"]))
        }
        
        for history in json["copy_history"].arrayValue {
            for attach in history["attachments"].arrayValue {
                self.photo.append(Photo(json: attach ["photo"]))
            }
        }
    }
}

class Comments: Object {
    
    @objc dynamic var count: Int = 0
    @objc dynamic var groups_can_post: Bool = false
    @objc dynamic var can_post: Int = 0
    
    convenience init(json: JSON) {
        self.init()
        
        let comentJson = json["comments"]
        self.count = comentJson["count"].intValue
        self.groups_can_post = comentJson["groups_can_post"].boolValue
        self.can_post = comentJson["can_post"].intValue
    }
}

class Likes: Object {
    
    @objc dynamic var count: Int = 0
    @objc dynamic var user_likes: Int = 0
    @objc dynamic var can_like: Int = 0
    @objc dynamic var can_publish: Int = 0
    
    convenience init(json: JSON) {
        self.init()
        
        let likeJson = json["likes"]
        self.count = likeJson["count"].intValue
        self.user_likes = likeJson["user_likes"].intValue
        self.can_like = likeJson["can_like"].intValue
        self.can_publish = likeJson["can_publish"].intValue
    }
}

class Reposts: Object {
    
    @objc dynamic var count: Int = 0
    @objc dynamic var user_reposted: Int = 0
    
    convenience init(json: JSON) {
        self.init()
        
        let repostsJson = json["reposts"]
        self.count = repostsJson["count"].intValue
        self.user_reposted = repostsJson["user_reposted"].intValue
    }
}

class Views: Object {
    
    @objc dynamic var count: Int = 0
    
    convenience init(json: JSON) {
        self.init()
        
        let viewsJson = json["views"]
        self.count = viewsJson["count"].intValue
    }
}

class Photo: Object {
    
    @objc dynamic var id: Int = 0
    @objc dynamic var album_id: Int = 0
    @objc dynamic var owner_id: Int = 0
    @objc dynamic var user_id: Int = 0
    @objc dynamic var photo_75: String = ""
    @objc dynamic var photo_130: String = ""
    @objc dynamic var photo_604: String = ""
    @objc dynamic var photo_807: String = ""
    @objc dynamic var photo_1280: String = ""
    @objc dynamic var width: Int = 0
    @objc dynamic var height: Int = 0
    @objc dynamic var text: String = ""
    @objc dynamic var date: Int = 0
    @objc dynamic var access_key: String = ""
    @objc dynamic var cashed_photo: String = ""
    
    convenience init(json: JSON) {
        self.init()
        
        self.id = json["id"].intValue
        self.album_id = json["album_id"].intValue
        self.owner_id = json["owner_id"].intValue
        self.user_id = json["user_id"].intValue
        self.photo_75 = json["photo_75"].stringValue
        self.photo_130 = json["photo_130"].stringValue
        self.photo_604 = json["photo_604"].stringValue
        self.photo_807 = json["photo_807"].stringValue
        self.photo_1280 = json["photo_1280"].stringValue
        self.width = json["width"].intValue
        self.height = json["height"].intValue
        self.text = json["text"].stringValue
        self.date = json["date"].intValue
        self.access_key = json["access_key"].stringValue
    }
}

class CopyHistory: Object {
    
    let attachments: List = List<Attachments>()
    convenience init(json: JSON) {
        self.init()
    }
}

class Attachments: Object {
    
    @objc dynamic var type: String = ""
    let photo: List = List<Photo>()
    
    convenience init(json: JSON) {
        self.init()
        
        self.type = json["type"].stringValue
    }
}


