//
//  Model.swift
//  WatchApp Extension
//
//  Created by Maxim Tolstikov on 06/05/2018.
//  Copyright © 2018 Maxim Tolstikov. All rights reserved.
//
import SwiftyJSON

struct News {
    
    let post_id: Int
    var source_id: Int = 0
    var text: String = ""
    var avatar: String = ""
    var name = ""
    var contentImageGroup = ""
    var contentImageFriend = ""
    
    init(json: JSON){
        
        self.post_id = json["post_id"].intValue
        self.source_id = abs(json["source_id"].intValue)
        self.text = json["text"].stringValue
        self.contentImageGroup = json["attachments"][0]["photo"]["photo_604"].stringValue
        self.contentImageFriend = json["copy_history"][0]["attachments"][0]["photo"]["photo_604"].stringValue
    }
}

struct Profiles {
    
    let id: Int
    var first_name: String = ""
    var last_name: String = ""
    var name: String {
        return first_name + " " + last_name
    }
    var photo_50: String = ""
    
    init(json: JSON) {
        
        self.id = json["id"].intValue
        self.first_name = json["first_name"].stringValue
        self.last_name = json["last_name"].stringValue
        self.photo_50 = json["photo_50"].stringValue
    }
}

struct Groups {
    
    let id: Int
    var name: String = ""
    var photo_50: String = ""
    
    init(json: JSON) {
        
        self.id = json["id"].intValue
        self.name = json["name"].stringValue
        self.photo_50 = json["photo_50"].stringValue
    }
}
