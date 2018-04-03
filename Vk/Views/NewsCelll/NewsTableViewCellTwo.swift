//
//  NewsTableViewCellTwo.swift
//  VK
//
//  Created by Maxim Tolstikov on 19/02/2018.
//  Copyright © 2018 Maxim Tolstikov. All rights reserved.
//

import UIKit

class NewsTableViewCellTwo: UITableViewCell {

    @IBOutlet weak var likeLable: UILabel!
    @IBOutlet weak var commentLable: UILabel!
    @IBOutlet weak var repostLable: UILabel!
    @IBOutlet weak var browseLable: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
