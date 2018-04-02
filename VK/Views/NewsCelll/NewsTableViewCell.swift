//
//  NewsTableViewCell.swift
//  VK
//
//  Created by Maxim Tolstikov on 26/02/2018.
//  Copyright © 2018 Maxim Tolstikov. All rights reserved.
//

import UIKit

class NewsTableViewCell: UITableViewCell {

    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var nameLable: UILabel!
    @IBOutlet weak var contentText: UITextView!
    @IBOutlet weak var contentPhoto: UIImageView!
    @IBOutlet weak var likeImage: UIImageView!
    @IBOutlet weak var likeLable: UILabel!
    @IBOutlet weak var commetnsImage: UIImageView!
    @IBOutlet weak var commentsLable: UILabel!
    @IBOutlet weak var repostImage: UIImageView!
    @IBOutlet weak var repostLable: UILabel!
    @IBOutlet weak var previewImage: UIImageView!
    @IBOutlet weak var prewiewLable: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
