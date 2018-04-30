//
//  FetchRequestManager.swift
//  VK
//
//  Created by Maxim Tolstikov on 06/04/2018.
//  Copyright © 2018 Maxim Tolstikov. All rights reserved.
//

import Foundation

class FetchRequestManager {
    
    var countNewFriends = 0
    let fetchRequestFriendsGroup = DispatchGroup()
    var timer: DispatchSourceTimer?
    var lastUpdate: Date? {
        get {
            return UserDefaults.standard.object(forKey: "LastUpdate") as? Date
        }
        set {
            UserDefaults.standard.setValue(Date(), forKey: "LastUpdate")
        }
    }
        
    func getFetchRequest(completion: @escaping (Int?) -> Void) {
        
        print("Вызов обновления данных в фоне \(Date())")
        if lastUpdate != nil, abs(lastUpdate!.timeIntervalSinceNow) < 30 {
            
            print("Фоновое обновление не требуется, т.к. крайний раз данные обновлялись \(abs(lastUpdate!.timeIntervalSinceNow)) секунд назад (меньше 30)")
            completion(0)
            
        } else {
            let apiManager: ApiManager = ApiManager()
            let newsService: NewsService = NewsService()
            
            newsService.updateNews()
            
            apiManager.getRequestFrends {(friends) in
                if !friends.isEmpty {
                    for friendId in friends {
                        apiManager.addFriend(id: friendId, complition: { (response) in
                            let i = response
                            if i {
                                print(i)
                            }
                        })
                    }
                    completion(friends.count)
                }
            }
            
            fetchRequestFriendsGroup.notify( queue: DispatchQueue.main)  {
                
                print("Все данные загружены в фоне")
                self.timer  =  nil
                self.lastUpdate =  Date()
                return
            }
            
            timer =  DispatchSource.makeTimerSource( queue: DispatchQueue.main)
            timer?.schedule( deadline: .now() + 29, leeway: .seconds(1) )
            timer?.setEventHandler {
                print ("Говорим системе, что не смогли загрузить данные")
                self.fetchRequestFriendsGroup.suspend()
                completion(nil)
                return
            }
            timer?.resume()
            
        }
        
        
    }
}
