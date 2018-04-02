//
//  GroupsTableViewController.swift
//  VK
//
//  Created by Maxim Tolstikov on 04/02/2018.
//  Copyright © 2018 Maxim Tolstikov. All rights reserved.
//

import UIKit
import VK_ios_sdk
import RealmSwift

class GroupsTableViewController: UITableViewController {
    
    var myToken: VKAccessToken? = nil
    let groupService = GroupService()
    let apiManager = ApiManager()
    let fM = FileManager.default
    
    var groups: Results <Group>?
    var token: NotificationToken?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        paitTableAndRealm()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        groupService.updateGroups()
        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(GroupsTableViewController.addTapped(_:)))
    }
    
    @objc func addTapped(_ button:UIBarButtonItem!){
        
        performSegue(withIdentifier: "addGroupSeque", sender: nil)
    }
    
    func paitTableAndRealm(){
        guard let realm = try? Realm() else {return}
        groups = realm.objects(Group.self)
        token = groups?.observe {[weak self] (changes: RealmCollectionChange) in
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
    
    func loadGroupIcon(indexPath: IndexPath) {
        
        let thisGroup = groups![indexPath.row]
        let groupId = thisGroup.id
        let urlImage = URL(string: thisGroup.photo_50)
        let nameFile = String(describing: thisGroup.id)

        URLSession.shared.downloadTask(with: urlImage!) { (location, response, error) in

            let cacheDirectory = self.fM.urls(for: .cachesDirectory, in: .userDomainMask).first
            let newUrl = cacheDirectory!.appendingPathComponent(nameFile)
            try? self.fM.moveItem(at: location!, to: newUrl)
            let urlString = newUrl.path
            self.groupService.addCacheUrl(cache_icon: urlString, id: groupId)

        }.resume()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return groups!.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "groupsCell", for: indexPath) as! GroupsTableViewCell
       
        cell.lableNameGroupsTable.text = groups![indexPath.row].name
        let group = groups![indexPath.row]

        if group.cashed_icon == "" {
            
            loadGroupIcon(indexPath: indexPath)
            print("Downloaded")
            
        } else {
            let strigForUrl = "file://" + group.cashed_icon
            let url = URL(string: strigForUrl)

            do{
                let data = try Data(contentsOf: url!)
                cell.imageGroupsTable.image = UIImage(data: data)
            } catch(let error) {
                print(error.localizedDescription)
            }
            
            print("Cached")
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            let groupId = groups![(indexPath.row)].id
            DispatchQueue.global().async {
                self.apiManager.deleteGroup(groupId: groupId, complitionHandler: { (json, error) in
                    guard (json?.null) == nil else {
                        print(error?.localizedDescription as Any)
                        return}
                    if json!["response"] == 1 {
                        self.groupService.deleteGroup(groupId: groupId)
                    }
                })
            }
        }
    }
 
}
