//
//  SearchGroupTableViewCell.swift
//  VK
//
//  Created by Maxim Tolstikov on 13/03/2018.
//  Copyright © 2018 Maxim Tolstikov. All rights reserved.
//

import UIKit

class SearchGroupTableViewCell: UITableViewCell {

    @IBOutlet weak var imageGroup: UIImageView!
    @IBOutlet weak var nameGroup: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
