//
//  CustomShareTool.swift
//  Street
//
//  Created by 陈宇峰 on 2019/6/19.
//  Copyright © 2019 inmyshow. All rights reserved.
//

import UIKit
import SnapKit

let kShareViewHeight = 260+kBottomSafeHeight

// MARK: - 分享类型枚举
enum CustomShareToolType {
    case siXin
    case weGroup
    case weChat
    case weiBo
    case QQ
    case QQZone
    case copyURL
    case savePicture
    case edit
    case delete
    case report
    case noInterested
}

// MARK: - 代理协议
protocol CustomShareToolDelegate {
    func clickShareViewWithType(type:CustomShareToolType)
}

class CustomShareTool: UIView {
    
    var delegate : CustomShareToolDelegate?
    var backView:UIView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
// MARK: - UI搭建
extension CustomShareTool {
    
    func configUI(){
        self.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT)
        self.backgroundColor = UIColor.colorFromHexA(rgbValue: 0x000000, alpha: 0.5)
        
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(closePopView))
        self.addGestureRecognizer(tap)
        
        backView.frame = CGRect(x: 0, y: SCREEN_HEIGHT, width: SCREEN_WIDTH, height: kShareViewHeight)
        backView.backgroundColor = UIColor.white
        self.addSubview(backView)
        
        let path = UIBezierPath.init(roundedRect: backView.bounds, byRoundingCorners: [.topLeft,.topRight], cornerRadii: CGSize(width: 10, height: 10))
        let shaperLayer = CAShapeLayer.init()
        shaperLayer.frame = backView.bounds;
        shaperLayer.path = path.cgPath
        backView.layer.mask = shaperLayer
        
        configShareUI()
    }
    
    func configShareUI() {
        let titleArray = ["微信","朋友圈","微博","QQ","空间","复制链接","生成图片","举报","不感兴趣"]
        let imageArray = ["微信分享","朋友圈分享","微博分享","QQ分享","空间分享","复制链接","生成图片","举报","不感兴趣"]
        
        let currentW = SCREEN_WIDTH/5;
        let currentH:CGFloat = 100
        
        let count = titleArray.count
        
        for i in 0..<count {
            
            let backV = UIButton.init(frame: CGRect(x:CGFloat(i%5)*currentW, y: CGFloat(i/5)*currentH, width: currentW, height: currentH))
            backV.tag = i;
            backV.addTarget(self, action: #selector(shareButtonClick(button:)), for: UIControl.Event.touchUpInside)
            backView.addSubview(backV)
            
            let logo = UIImageView.init()
            logo.image = UIImage(named:imageArray[i])
            backV.addSubview(logo)
            
            let titleLabel = UILabel.init()
            titleLabel.text = titleArray[i]
            titleLabel.textAlignment = .center
            titleLabel.font = UIFont.systemFont(ofSize: 12)
            titleLabel.textColor = UIColor.colorFromHex(rgbValue: 0x8E8585)
            backV.addSubview(titleLabel)
            
            logo.snp.makeConstraints { (make) in
                make.top.equalTo(backV).offset(15)
                make.size.equalTo(CGSize(width: 48, height: 48))
                make.centerX.equalTo(backV)
            }
            
            titleLabel.snp.makeConstraints { (make) in
                make.top.equalTo(logo.snp.bottom).offset(2)
                make.left.right.equalTo(backV)
                make.height.equalTo(20)
            }
        }
        
        let midLine = UIView.init()
        midLine.backgroundColor = UIColor.colorFromHex(rgbValue: 0xe6e6e6)
        backView.addSubview(midLine)
        
        let botLine = UIView.init()
        botLine.backgroundColor = UIColor.colorFromHex(rgbValue: 0xe6e6e6)
        backView.addSubview(botLine)
        
        midLine.snp.makeConstraints { (make) in
            make.top.equalTo(backView).offset(100)
            make.left.right.equalTo(backView)
            make.height.equalTo(0.5)
        }
        
        botLine.snp.makeConstraints { (make) in
            make.top.equalTo(backView).offset(200)
            make.left.right.equalTo(backView)
            make.height.equalTo(0.5)
        }
        
        let closeLabel = UILabel.init()
        closeLabel.text = "取消"
        closeLabel.textAlignment = .center
        closeLabel.font = UIFont.systemFont(ofSize: 14)
        closeLabel.textColor = UIColor.colorFromHex(rgbValue: 0x8E8585)
        backView.addSubview(closeLabel)
        
        closeLabel.snp.makeConstraints { (make) in
            make.top.equalTo(backView).offset(200)
            make.left.right.equalTo(backView)
            make.height.equalTo(60)
        }
    }
}

// MARK: - 显示，隐藏方法
extension CustomShareTool {
    
    func showShareView() {
        let keyWindow = UIApplication.shared.keyWindow
        keyWindow?.addSubview(self)
        UIView.animate(withDuration: 0.3) {
            self.backView.frame = CGRect(x: 0, y: SCREEN_HEIGHT - kShareViewHeight, width: SCREEN_WIDTH, height: kShareViewHeight)
        }
    }
    
    func hiddenShareView() {
        let keyWindow = UIApplication.shared.keyWindow
        keyWindow?.addSubview(self)
        UIView.animate(withDuration: 0.3, animations: {
            self.backView.frame = CGRect(x: 0, y: SCREEN_HEIGHT, width: SCREEN_WIDTH, height: kShareViewHeight)
        }) { (finished) in
            self.removeFromSuperview()
        }
    }
    
    @objc func closePopView() {
        hiddenShareView()
    }
    
    @objc func shareButtonClick(button:UIButton) {
        switch button.tag {
        case 0:
            delegate?.clickShareViewWithType(type: .weChat)
        case 1:
            delegate?.clickShareViewWithType(type: .weGroup)
        case 2:
            delegate?.clickShareViewWithType(type: .weiBo)
        case 3:
            delegate?.clickShareViewWithType(type: .QQ)
        case 4:
            delegate?.clickShareViewWithType(type: .QQZone)
        case 5:
            delegate?.clickShareViewWithType(type: .copyURL)
        case 6:
            delegate?.clickShareViewWithType(type: .savePicture)
        case 7:
            delegate?.clickShareViewWithType(type: .report)
        case 8:
            delegate?.clickShareViewWithType(type: .noInterested)
        default:
            print("未知分享")
        }
    }
}
