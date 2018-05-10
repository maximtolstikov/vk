//
//  MessageTableViewController.swift
//  VK
//
//  Created by Maxim Tolstikov on 05/04/2018.
//  Copyright © 2018 Maxim Tolstikov. All rights reserved.
//

import UIKit
import RealmSwift

class MessageTableViewController: UITableViewController {
    
    let apiManager = ApiManager()

    override func viewDidLoad() {

        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
/////////////////////////////////////////////////////////
        
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }


}
