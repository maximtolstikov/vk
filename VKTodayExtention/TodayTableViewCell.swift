//
//  TodayTableViewCell.swift
//  VKTodayExtention
//
//  Created by Maxim Tolstikov on 11/04/2018.
//  Copyright © 2018 Maxim Tolstikov. All rights reserved.
//

import UIKit

class TodayTableViewCell: UITableViewCell {

    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var avatarLable: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
