//
//  MessageListCell.swift
//  Street
//
//  Created by 陈宇峰 on 2019/5/27.
//  Copyright © 2019 inmyshow. All rights reserved.
//

import UIKit
import SnapKit
import Kingfisher

class MessageListCell: UITableViewCell {
    
    //MARK: - 属性
    var userImageView = UIImageView()
    var userNickName = UILabel()
    var timeLable = UILabel()
    var titleLable = UILabel()
    var redPointLable = UILabel()
    var botLine = UIView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.configUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - 创建UI
    func configUI() {
        
        userImageView = UIImageView.init()
        userImageView.layer.cornerRadius = 20
        userImageView.layer.masksToBounds = true
        userImageView.contentMode = .scaleAspectFill
        userImageView.layer.masksToBounds = true
        userImageView.backgroundColor = UIColor.colorFromHex(rgbValue: 0xF1F1F1)
        contentView.addSubview(userImageView)
        
        userNickName = UILabel.init()
        userNickName.textColor = UIColor.colorFromHex(rgbValue: 0x151515)
        userNickName.font = UIFont.boldSystemFont(ofSize: 14)
        userNickName.textAlignment = .left
        contentView.addSubview(userNickName)
        
        timeLable = UILabel.init()
        timeLable.textColor = UIColor.colorFromHex(rgbValue: 0xc7c2c1)
        timeLable.font = UIFont.systemFont(ofSize: 10)
        timeLable.textAlignment = .right
        contentView.addSubview(timeLable)
        
        titleLable = UILabel.init()
        titleLable.textColor = UIColor.colorFromHex(rgbValue: 0x8E8585)
        titleLable.font = UIFont.systemFont(ofSize: 12)
        titleLable.textAlignment = .left
        contentView.addSubview(titleLable)
        
        redPointLable = UILabel.init()
        redPointLable.textColor = UIColor.white
        redPointLable.backgroundColor = UIColor.colorFromHex(rgbValue: 0xFF486E)
        redPointLable.font = UIFont.boldSystemFont(ofSize: 10)
        redPointLable.textAlignment = .center
        redPointLable.layer.cornerRadius = 7
        redPointLable.layer.masksToBounds = true
        contentView.addSubview(redPointLable)
        
        botLine = UIView.init()
        botLine.backgroundColor = UIColor.colorFromHex(rgbValue: 0xe6e6e6)
        contentView.addSubview(botLine)
        
        userImageView.snp.makeConstraints { (make) in
            make.left.top.equalTo(self).offset(15)
            make.size.equalTo(CGSize.init(width: 40, height: 40))
        }
        
        userNickName.snp.makeConstraints { (make) in
            make.top.equalTo(userImageView.snp.top).offset(0)
            make.left.equalTo(userImageView.snp.right).offset(15)
            make.right.equalTo(self).offset(-120)
            make.height.equalTo(20)
        }
        
        timeLable.snp.makeConstraints { (make) in
            make.top.equalTo(userImageView.snp.top).offset(0)
            make.right.equalTo(self).offset(-15)
            make.height.equalTo(20)
        }
        
        titleLable.snp.makeConstraints { (make) in
            make.left.equalTo(userImageView.snp.right).offset(15)
            make.bottom.equalTo(userImageView.snp.bottom)
            make.right.equalTo(self).offset(-15)
        }
        
        redPointLable.snp.makeConstraints { (make) in
            make.right.bottom.equalTo(self).offset(-15)
            make.size.equalTo(CGSize.init(width: 24, height: 14))
        }
        
        botLine.snp.makeConstraints { (make) in
            make.left.equalTo(userImageView.snp.right).offset(15)
            make.right.bottom.equalTo(self)
            make.height.equalTo(0.5)
        }
    }
    
    //MARK: - 赋值
    func loadCellWithModel(model:MessageListModel) {
        
//        if let avatarUrl = URL(string:model.avatar) {
//            userImageView.kf.setImage(with: ImageResource.init(downloadURL:avatarUrl))
//        }
//        userNickName.text = model.nick
//        timeLable.text = model.time
//        titleLable.text = model.content
        
        userImageView.image = UIImage(named: "header_default")
        userNickName.text = "隔壁老王"
        timeLable.text = "5-28 10:30"
        titleLable.text = "这是聊天详情，是不是？"
        redPointLable.text = "\(arc4random()%30)"
    }
    
    //MARK: - 系统回调
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
