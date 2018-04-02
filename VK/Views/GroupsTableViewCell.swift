//
//  GroupsTableViewCell.swift
//  VK
//
//  Created by Maxim Tolstikov on 04/02/2018.
//  Copyright © 2018 Maxim Tolstikov. All rights reserved.
//

import UIKit

class GroupsTableViewCell: UITableViewCell {

    @IBOutlet weak var lableNameGroupsTable: UILabel!
    @IBOutlet weak var imageGroupsTable: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
