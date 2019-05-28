//
//  MessageHeaderView.swift
//  Street
//
//  Created by 陈宇峰 on 2019/5/28.
//  Copyright © 2019 inmyshow. All rights reserved.
//

import UIKit

// MARK: - 枚举
enum MessageType {
    case comment
    case priase
    case attention
    case notice
}

// MARK: - 协议
protocol MessageHeaderViewProtocol {
    func selectMessageHeaderView(messageType:MessageType)
}

class MessageHeaderView: UIView {

    var delegate:MessageHeaderViewProtocol?
    override init(frame: CGRect) {
        super.init(frame: frame)
        configUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - UI布局
extension MessageHeaderView {
    
    func configUI() {
        let titleArray = ["评论/@","盘/赞/赏","关注","通知"]
        let imageArray = ["消息评论","消息赞赏","消息关注","消息通知"]
        let currentW:CGFloat = SCREEN_WIDTH/CGFloat(titleArray.count)
        
        for i in 0...3 {
            let backView = UIView.init()
            backView.tag = i
            self.addSubview(backView)
            backView.isUserInteractionEnabled = true
            backView.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(selectMessageType(tap:))))
            
            let logoImage = UIImageView.init()
            logoImage.layer.cornerRadius = 28
            logoImage.layer.masksToBounds = true
            logoImage.contentMode = .scaleAspectFill
            logoImage.layer.masksToBounds = true
            logoImage.image = UIImage(named: imageArray[i])
            backView.addSubview(logoImage)
            
            let titleLable = UILabel.init()
            titleLable.textColor = UIColor.colorFromHex(rgbValue: 0x8E8585)
            titleLable.font = UIFont.systemFont(ofSize: 11)
            titleLable.textAlignment = .center
            titleLable.text = titleArray[i]
            backView.addSubview(titleLable)
            
            backView.snp.makeConstraints { (make) in
                make.left.equalTo(self).offset(CGFloat(i)*currentW)
                make.centerY.equalTo(self)
                make.width.equalTo(currentW)
                make.height.equalTo(74)
            }
            
            logoImage.snp.makeConstraints { (make) in
                make.top.equalTo(backView)
                make.size.equalTo(CGSize(width: 56, height: 56))
                make.centerX.equalTo(backView)
            }
            
            titleLable.snp.makeConstraints { (make) in
                make.bottom.equalTo(backView)
                make.left.right.equalTo(backView)
                make.centerX.equalTo(backView)
                make.height.equalTo(18)
            }
        }
        
        let botLine = UIView.init()
        botLine.backgroundColor = UIColor.colorFromHex(rgbValue: 0xF1F1F1)
        self.addSubview(botLine)
        
        botLine.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(self)
            make.height.equalTo(8)
        }
    }
}


// MARK: - 点击代理
extension MessageHeaderView {
    
    @objc func selectMessageType(tap:UITapGestureRecognizer){
        switch tap.view?.tag {
        case 0:
            delegate?.selectMessageHeaderView(messageType: .comment)
        case 1:
            delegate?.selectMessageHeaderView(messageType: .priase)
        case 2:
            delegate?.selectMessageHeaderView(messageType: .attention)
        case 3:
            delegate?.selectMessageHeaderView(messageType: .notice)
        default:
            print("无效事件")
        }
    }
}
