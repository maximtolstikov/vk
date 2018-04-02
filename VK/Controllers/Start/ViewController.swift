//
//  ViewController.swift
//  VK
//
//  Created by Maxim Tolstikov on 02/02/2018.
//  Copyright © 2018 Maxim Tolstikov. All rights reserved.
//

import UIKit
import VK_ios_sdk

class ViewController: UIViewController, VKSdkDelegate, VKSdkUIDelegate {
    
    var apid = "6356430"
    let scope: [String] = [VK_PER_GROUPS, VK_PER_PHOTOS, VK_PER_FRIENDS, VK_PER_WALL]
    var isAuthorised = false
    
    //MARK: Кнопка входа
    @IBAction func button(_ sender: Any) {
        
        VKSdk.authorize(scope)
    }    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let sdkInstance = VKSdk.initialize(withAppId: apid)
        
        sdkInstance?.register(self)
        sdkInstance?.uiDelegate = self
        
        VKSdk.wakeUpSession(scope) { (state: VKAuthorizationState, error) in
            
            if state == VKAuthorizationState.authorized {
                self.isAuthorised = true
                print("Authorized")
                
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "startSegue", sender: nil)
                }
                
            } else {
                print("No authorized")
            }
        }        
    }

    //Метод определяет должен ли выполнится сигвэй
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "startSegue" {
            if isAuthorised == true {
                return true
            }
        }
        return false
    }

    func vkSdkShouldPresent(_ controller: UIViewController!) {
        
        self.navigationController?.topViewController?.present(controller, animated: true, completion: nil)
    }
    
    func vkSdkNeedCaptchaEnter(_ captchaError: VKError!) {
        
        let vkCvC = VKCaptchaViewController.captchaControllerWithError(captchaError)
        vkCvC?.present(in: self.navigationController?.topViewController)
    }
    
    func vkSdkAccessAuthorizationFinished(with result: VKAuthorizationResult!) {
        
        if (result.token != nil) {
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "startSegue", sender: nil)
            }
        } else {
            //authState.text = "NOT authorised"
             print("not token!")
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
    
    func vkSdkUserAuthorizationFailed() {
        
        self.navigationController?.popToRootViewController(animated: true)
    }
    
}

