//
//  StartTabBarController.swift
//  VK
//
//  Created by Maxim Tolstikov on 04/02/2018.
//  Copyright © 2018 Maxim Tolstikov. All rights reserved.
//

import UIKit
import VK_ios_sdk
import Firebase

class StartTabBarController: UITabBarController {

    let userId = VKSdk.accessToken().userId
    let ref = Database.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(VKSdk.accessToken().accessToken)
        print(VKSdk.accessToken().userId)
        
        ref.child("user_id").setValue(userId)
       
        self.navigationController?.view.backgroundColor = UIColor.white
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "LogOut", style: UIBarButtonItemStyle.done, target: self, action: #selector(logout))
    }
    
    @objc func logout() {
        VKSdk.forceLogout()
        
        self.navigationController?.popToRootViewController(animated: true)
        
    }
    
    
}

