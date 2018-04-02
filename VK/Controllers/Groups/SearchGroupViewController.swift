//
//  SearchGroupViewController.swift
//  VK
//
//  Created by Maxim Tolstikov on 12/03/2018.
//  Copyright © 2018 Maxim Tolstikov. All rights reserved.
//

import UIKit
import VK_ios_sdk
//import Firebase

class SearchGroupViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!

    //let ref = Database.database().reference()

    let apiManager = ApiManager()
    var groups = [Group]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        apiManager.searchGroups(q: searchBar.text!) { [weak self] (groups) in
            self?.groups = groups
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }
  
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groups.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellForSearchGroup", for: indexPath) as! SearchGroupTableViewCell
        
        cell.nameGroup.text = groups[indexPath.row].name
        
        let url = URL(string: groups[indexPath.row].photo_50)
        
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            
            DispatchQueue.main.async {
                cell.imageGroup.image = UIImage(data: data!)
            }
            }.resume()
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let indexPath = tableView.indexPathForSelectedRow
        let groupId = groups[(indexPath?.row)!].id
        let nameGroup = groups[(indexPath?.row)!].name
        apiManager.joinGroup(groupId: groupId)
        showAlertController(text: nameGroup)
    }
    
    func showAlertController(text: String) {
        let ac = UIAlertController(title: "Вы добавили группу", message: text, preferredStyle: .actionSheet)
        let cancel = UIAlertAction(title: "OK!", style: .cancel, handler: nil)
        ac.addAction(cancel)
        present(ac, animated: true, completion: nil)
    }

    
    
}

