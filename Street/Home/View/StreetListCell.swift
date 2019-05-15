//
//  StreetListCell.swift
//  Street
//
//  Created by 陈宇峰 on 2019/5/14.
//  Copyright © 2019 inmyshow. All rights reserved.
//

import UIKit
import SnapKit

class StreetListCell: UITableViewCell {
    
    var userImageView = UIImageView()
    var userNickName = UILabel()
    var showImageView = UIImageView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.configUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configUI() {
        
        userImageView = UIImageView.init()
        userImageView.backgroundColor = UIColor.yellow
        userImageView.layer.cornerRadius = 20
        userImageView.layer.masksToBounds = true
        self.contentView.addSubview(userImageView)
        
        userNickName = UILabel.init()
        userNickName.textColor = UIColor.black
        userNickName.font = UIFont.systemFont(ofSize: 16)
        userNickName.textAlignment = .left
        self.contentView.addSubview(userNickName)
        
        showImageView = UIImageView.init()
        showImageView.backgroundColor = UIColor.blue
        self.contentView.addSubview(showImageView)
        
        
        userImageView.snp.makeConstraints { (make) in
            make.left.top.equalTo(self).offset(10)
            make.size.equalTo(CGSize.init(width: 40, height: 40))
        }
        
        userNickName.snp.makeConstraints { (make) in
            make.top.equalTo(self).offset(10)
            make.left.equalTo(userImageView.snp.right).offset(10)
            make.right.equalTo(self).offset(-10)
            make.height.equalTo(40)
        }
        
        showImageView.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(10)
            make.right.equalTo(self).offset(-10)
            make.top.equalTo(userImageView.snp.bottom).offset(10)
            make.bottom.equalTo(self).offset(-10)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
