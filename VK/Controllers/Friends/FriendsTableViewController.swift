//
//  FriendsTableViewController.swift
//  VK
//
//  Created by Maxim Tolstikov on 04/02/2018.
//  Copyright © 2018 Maxim Tolstikov. All rights reserved.
//615aa264f290dd071f5266daffd176902a9d158a877210b85b8041b776738c7b517c03d3fc4fd0a150938
//360088009


import UIKit
import VK_ios_sdk
import RealmSwift

class FriendsTableViewController: UITableViewController {
    

    let friendService = FriendService()
    let fM = FileManager.default
    
    var friends: Results <Friend>?
    var token: NotificationToken?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.friendService.updateFriends()
        pairTableAndRealm()
        
       
    }
    override func viewWillAppear(_ animated: Bool) {
         navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: nil)
    }
    
    func pairTableAndRealm(){
        
        guard let realm = try? Realm() else {return}
        friends = realm.objects(Friend.self)
        token = friends?.observe {[weak self] (changes: RealmCollectionChange) in
            guard let tableView = self?.tableView else {return}
            switch changes{
            case .initial:
                tableView.reloadData()
                break
            case .update(_, deletions: let deletions, insertions: let insertion, modifications: let modifications):
                tableView.beginUpdates()
                tableView.insertRows(at: insertion.map({IndexPath(row: $0, section: 0)}), with: .none)
                tableView.deleteRows(at: deletions.map({IndexPath(row: $0, section: 0)}), with: .none)
                tableView.reloadRows(at: modifications.map({IndexPath(row: $0, section: 0)}), with: .none)
                tableView.endUpdates()
                break
            case .error(let error):
                fatalError("\(error)")
                break
            }
            
        }
    }
    func loadFriendIcon(indexPath: IndexPath) {
        
        let thisUser = friends![indexPath.row]
        let userId = thisUser.id
        let urlImage = URL(string: thisUser.photo_50)
        let nameFile = String(describing: thisUser.id)
        
        URLSession.shared.downloadTask(with: urlImage!) { (location, response, error) in
            
            let cacheDirectory = self.fM.urls(for: .cachesDirectory, in: .userDomainMask).first
            let newUrl = cacheDirectory!.appendingPathComponent(nameFile)
            try? self.fM.moveItem(at: location!, to: newUrl)
            let urlString = newUrl.path
            self.friendService.addCacheUrl(cache_icon: urlString, id: userId)
            
            }.resume()        
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return friends?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "friendsCell", for: indexPath) as! FriendsTableViewCell
        
        cell.first_nameLable.text = friends![indexPath.row].first_name
        cell.last_nameLable.text = friends![indexPath.row].last_name

        let friend = friends![indexPath.row]
        
        if friend.cashed_icon == "" {
            
            loadFriendIcon(indexPath: indexPath)
            print("Downloaded (Friend)")
            
        } else {
            let strigForUrl = "file://" + friend.cashed_icon
            let url = URL(string: strigForUrl)
            
            do{
                let data = try Data(contentsOf: url!)
                cell.imageFriendsCell.image = UIImage(data: data)
            } catch(let error) {
                print(error.localizedDescription)
            }
            
            print("Cached (Friend)")
        }
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "collectionImage" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let destinationViewController = segue.destination as! FriendCollectionViewController
                
                destinationViewController.url_foto = friends![indexPath.row].photo_400_orig
                
            }
        }
    }
    
}
