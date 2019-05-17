//
//  StreetListCell.swift
//  Street
//
//  Created by 陈宇峰 on 2019/5/14.
//  Copyright © 2019 inmyshow. All rights reserved.
//

import UIKit
import SnapKit
import Kingfisher

class StreetListCell: UITableViewCell {
    
    var userImageView = UIImageView()
    var userNickName = UILabel()
    var timeLable = UILabel()
    
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
        userImageView.layer.cornerRadius = 20
        userImageView.layer.masksToBounds = true
        userImageView.contentMode = .scaleAspectFill
        userImageView.layer.masksToBounds = true
        self.contentView.addSubview(userImageView)
        
        userNickName = UILabel.init()
        userNickName.textColor = UIColor.black
        userNickName.font = UIFont.systemFont(ofSize: 14)
        userNickName.textAlignment = .left
        self.contentView.addSubview(userNickName)
        
        timeLable = UILabel.init()
        timeLable.textColor = UIColor.gray
        timeLable.font = UIFont.systemFont(ofSize: 10)
        timeLable.textAlignment = .left
        self.contentView.addSubview(timeLable)
        
        showImageView = UIImageView.init()
        showImageView.contentMode = .scaleAspectFill
        showImageView.layer.masksToBounds = true
        self.contentView.addSubview(showImageView)
        
        
        userImageView.snp.makeConstraints { (make) in
            make.left.top.equalTo(self).offset(10)
            make.size.equalTo(CGSize.init(width: 40, height: 40))
        }
        
        userNickName.snp.makeConstraints { (make) in
            make.top.equalTo(self).offset(10)
            make.left.equalTo(userImageView.snp.right).offset(10)
            make.right.equalTo(self).offset(-10)
            make.height.equalTo(20)
        }
        
        timeLable.snp.makeConstraints { (make) in
            make.top.equalTo(self).offset(30)
            make.left.equalTo(userImageView.snp.right).offset(10)
            make.right.equalTo(self).offset(-10)
            make.height.equalTo(20)
        }
        
        showImageView.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(10)
            make.right.equalTo(self).offset(-10)
            make.top.equalTo(userImageView.snp.bottom).offset(10)
            make.bottom.equalTo(self).offset(-10)
        }
        
    }
    
    func loadCellWithModel(model:StreetModel) {
        
        let avatarUrl = URL(string:model.avatar)
        let showUrl = URL(string:model.pict_url.src)
        userImageView.kf.setImage(with: ImageResource.init(downloadURL:avatarUrl!))
        showImageView.kf.setImage(with: ImageResource.init(downloadURL:showUrl!))
        
        userNickName.text = model.nick
        timeLable.text = model.publish_time
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
