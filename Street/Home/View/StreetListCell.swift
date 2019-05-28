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

protocol StreetListSelectDelegate {
    func StreetListSelectCurrentUserImage(index:NSInteger, uid:String)
    func StreetListSelectCurrentStreet(index:NSInteger, streetId:String)
}

class StreetListCell: UITableViewCell {
    
    //MARK: - 属性
    var delegate:StreetListSelectDelegate?
    var currentModel = StreetModel()
    var backView = UIView()
    var userImageView = UIImageView()
    var userNickName = UILabel()
    var timeLable = UILabel()
    var streetButton = UIButton()
    var showImageView = UIImageView()
    var popView = UIView()
    var titleLable = UILabel()
    var picLogo = UIImageView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = UIColor.colorFromHex(rgbValue: 0xF1F1F1)
        self.configUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - 创建UI
    func configUI() {
        
        backView = UIView.init()
        backView.layer.cornerRadius = 8
        backView.layer.masksToBounds = true
        backView.backgroundColor = UIColor.white
        self.contentView.addSubview(backView)
        
        userImageView = UIImageView.init()
        userImageView.layer.cornerRadius = 20
        userImageView.layer.masksToBounds = true
        userImageView.contentMode = .scaleAspectFill
        userImageView.layer.masksToBounds = true
        userImageView.backgroundColor = UIColor.colorFromHex(rgbValue: 0xF1F1F1)
        backView.addSubview(userImageView)
        userImageView.isUserInteractionEnabled = true
        userImageView.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(selectCurrentUserImage)))
        
        userNickName = UILabel.init()
        userNickName.textColor = UIColor.black
        userNickName.font = UIFont.systemFont(ofSize: 14)
        userNickName.textAlignment = .left
        backView.addSubview(userNickName)
        
        timeLable = UILabel.init()
        timeLable.textColor = UIColor.gray
        timeLable.font = UIFont.systemFont(ofSize: 10)
        timeLable.textAlignment = .left
        backView.addSubview(timeLable)
        
        streetButton = UIButton.init(type: .custom)
        streetButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 12)
        streetButton.setTitleColor(UIColor.white, for: .normal)
        streetButton.backgroundColor = UIColor.colorFromHex(rgbValue: 0xA6A6A6)
        streetButton.layer.cornerRadius = 12
        streetButton.addTarget(self, action: #selector(selectCurrentStreet), for:UIControl.Event.touchUpInside)
        backView.addSubview(streetButton)
        
        showImageView = UIImageView.init()
        showImageView.contentMode = .scaleAspectFill
        showImageView.layer.masksToBounds = true
        backView.addSubview(showImageView)
        
        popView = UIView.init()
        showImageView.addSubview(popView)
        
        titleLable = UILabel.init()
        titleLable.textColor = UIColor.white
        titleLable.font = UIFont.systemFont(ofSize: 15)
        titleLable.textAlignment = .left
        titleLable.numberOfLines = 0
        popView.addSubview(titleLable)
        
        picLogo = UIImageView.init()
        showImageView.addSubview(picLogo)
        
        backView.snp.makeConstraints { (make) in
            make.top.equalTo(self)
            make.left.equalTo(self).offset(5)
            make.right.equalTo(self).offset(-5)
            make.bottom.equalTo(self).offset(-10)
        }
        
        userImageView.snp.makeConstraints { (make) in
            make.left.top.equalTo(self.backView).offset(10)
            make.size.equalTo(CGSize.init(width: 40, height: 40))
        }
        
        userNickName.snp.makeConstraints { (make) in
            make.top.equalTo(self.backView).offset(10)
            make.left.equalTo(userImageView.snp.right).offset(10)
            make.right.equalTo(self.backView).offset(-10)
            make.height.equalTo(20)
        }
        
        timeLable.snp.makeConstraints { (make) in
            make.top.equalTo(self.backView).offset(30)
            make.left.equalTo(userImageView.snp.right).offset(10)
            make.right.equalTo(self.backView).offset(-10)
            make.height.equalTo(20)
        }
        
        streetButton.snp.makeConstraints { (make) in
            make.top.equalTo(self.backView).offset(10)
            make.right.equalTo(self.backView).offset(-10)
            make.height.equalTo(24)
        }
        
        showImageView.snp.makeConstraints { (make) in
            make.left.equalTo(self.backView).offset(10)
            make.right.equalTo(self.backView).offset(-10)
            make.top.equalTo(userImageView.snp.bottom).offset(10)
            make.bottom.equalTo(self.backView).offset(-10)
        }
        
        popView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(showImageView)
            make.height.equalTo(64)
        }
        
        titleLable.snp.makeConstraints { (make) in
            make.left.equalTo(popView).offset(10)
            make.right.bottom.equalTo(popView).offset(-10)
        }
        
        picLogo.snp.makeConstraints { (make) in
            make.top.equalTo(showImageView).offset(7)
            make.right.equalTo(showImageView).offset(-7)
            make.size.equalTo(CGSize.init(width: 20, height: 20))
        }
    }
    
    //MARK: - 赋值
    func loadCellWithModel(model:StreetModel) {
 
        self.currentModel = model
        if let avatarUrl = URL(string:model.avatar) {
            userImageView.kf.setImage(with: ImageResource.init(downloadURL:avatarUrl),placeholder:UIImage(named: "header_default"))
        }
        if let showUrl = URL(string:model.pict_url.src) {
            showImageView.kf.setImage(with: ImageResource.init(downloadURL:showUrl))
        }
        
        userNickName.text = model.nick
        timeLable.text = model.publish_time
        
        popView.backgroundColor = UIColor.hexadecimalColor(hexadecimal: model.pict_url.rgb, alpha: 0.3)
        titleLable.text = model.title
        
        if model.jiequ.jqname.count > 0 {
            streetButton.isHidden = false
            streetButton.setTitle(model.jiequ.jqname, for: .normal)
            streetButton.setImage(UIImage(named: "superTopicLogo"), for: .normal)
            streetButton.imageEdgeInsets = .init(top: 0, left: -6, bottom: 0, right:0)
            streetButton.contentEdgeInsets = .init(top: 0, left: 10, bottom: 0, right: 10)
        }
        else {
            streetButton.isHidden = true
        }
        
        //判断是简版还是详版 type : 0,简版 ,1 详版 2.视频 3.长文 默认为普通详情 4.纯文字
        if Int(model.type) == 2 {
            picLogo.image = UIImage(named: "street_videoLogo")
        }
        else if Int(model.type) == 1 ||  Int(model.type) == 3{
            picLogo.image = UIImage(named: "street_longLogo")
        }
        else if Int(model.type) == 0{
            picLogo.image = UIImage(named: "street_picLogo")
        }
    }
    
    //MARK: - 自定义响应方法
    @objc func selectCurrentUserImage() {
        delegate?.StreetListSelectCurrentUserImage(index: self.tag, uid: self.currentModel.uid)
    }
    
    @objc func selectCurrentStreet() {
        delegate?.StreetListSelectCurrentStreet(index: self.tag, streetId: self.currentModel.jiequ.jqid)
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
