//
//  NoticeListCell.swift
//  Street
//
//  Created by 陈宇峰 on 2019/5/28.
//  Copyright © 2019 inmyshow. All rights reserved.
//

import UIKit

class NoticeListCell: UITableViewCell {

    @IBOutlet weak var userImageview: UIImageView!
    @IBOutlet weak var titleLable: UILabel!
    @IBOutlet weak var showImageview: UIImageView!
    @IBOutlet weak var timeLable: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
