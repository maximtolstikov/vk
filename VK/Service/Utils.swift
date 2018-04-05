//
//  Utils.swift
//  VK
//
//  Created by Maxim Tolstikov on 05/04/2018.
//  Copyright © 2018 Maxim Tolstikov. All rights reserved.
//
import UIKit

let fetchRequestFriendsGroup = DispatchGroup()
var timer: DispatchSourceTimer?
var lastUpdate: Date? {
    get {
        return UserDefaults.standard.object(forKey: "LastUpdate") as? Date
    }
    set {
        UserDefaults.standard.setValue(Date(), forKey: "LastUpdate") }
}
