//
//  Group.swift
//  VK
//
//  Created by Maxim Tolstikov on 08/02/2018.
//  Copyright © 2018 Maxim Tolstikov. All rights reserved.
//
import RealmSwift
import SwiftyJSON

class Group: Object{
    
    @objc dynamic var id: Int = 0
    @objc dynamic var name: String = ""
    @objc dynamic var screen_name: String = ""
    @objc dynamic var is_closed: Int = 0
    @objc dynamic var type: String = ""
    @objc dynamic var is_admin: Int = 0
    @objc dynamic var is_member: Int = 0
    @objc dynamic var photo_50: String = ""
    @objc dynamic var photo_100: String = ""
    @objc dynamic var photo_200: String = ""
    @objc dynamic var cashed_icon: String = ""
    
    convenience init(json: JSON) {
        self.init()
        
        self.id = json["id"].intValue
        self.name = json["name"].stringValue
        self.screen_name = json["screen_name"].stringValue
        self.is_closed = json["is_closed"].intValue
        self.type = json["type"].stringValue
        self.is_admin = json["is_admin"].intValue
        self.is_member = json["is_member"].intValue
        self.photo_50 = json["photo_50"].stringValue
        self.photo_100 = json["photo_100"].stringValue
        self.photo_200 = json["photo_200"].stringValue

    }
    
    override static func ignoredProperties() -> [String] {
        return ["is_closed", "is_admin" , "is_member", "photo_100", "photo_200"]
    }
    
}


