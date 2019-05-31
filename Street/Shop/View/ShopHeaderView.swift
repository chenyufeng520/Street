//
//  ShopHeaderView.swift
//  Street
//
//  Created by 陈宇峰 on 2019/5/30.
//  Copyright © 2019 inmyshow. All rights reserved.
//

import UIKit

class ShopHeaderView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
}

// MARK:- 提供一个快速创建View的类方法
extension ShopHeaderView {
    class func shopHeaderView() -> ShopHeaderView {
        return Bundle.main.loadNibNamed("ShopHeaderView", owner: nil, options: nil)?.first as! ShopHeaderView
    }
}
