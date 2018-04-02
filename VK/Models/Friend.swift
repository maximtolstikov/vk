//
//  User.swift
//  VK
//
//  Created by Maxim Tolstikov on 08/02/2018.
//  Copyright © 2018 Maxim Tolstikov. All rights reserved.
//
import RealmSwift
import SwiftyJSON

class Friend: Object {
    
    @objc dynamic var id: Int = 0
    @objc dynamic var first_name: String = ""
    @objc dynamic var last_name: String = ""
    @objc dynamic var photo_50: String = ""
    @objc dynamic var photo_400_orig: String = ""
    @objc dynamic var online : Int = 0
    @objc dynamic var cashed_icon: String = ""
 
    convenience init(json: JSON) {
        self.init()
        
        self.id = json["id"].intValue
        self.first_name = json["first_name"].stringValue
        self.last_name = json["last_name"].stringValue
        self.photo_50 = json["photo_50"].stringValue
        self.photo_400_orig = json["photo_400_orig"].stringValue
        self.online = json["online"].intValue    
    }
    
    override static func ignoredProperties() -> [String] {
        return ["online"]
    }
}

