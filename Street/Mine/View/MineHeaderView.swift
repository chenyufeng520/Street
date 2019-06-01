//
//  MineHeaderView.swift
//  Street
//
//  Created by 陈宇峰 on 2019/5/21.
//  Copyright © 2019 inmyshow. All rights reserved.
//

import UIKit

protocol MineHeaderViewDelegate {
    
    func mineHeaderViewSettingClick(_ headerView:MineHeaderView)
    func mineHeaderViewHobbyClick(_ headerView:MineHeaderView)
    func mineHeaderViewShareClick(_ headerView:MineHeaderView)
    func mineHeaderViewPersonSettingClick(_ headerView:MineHeaderView)
}

class MineHeaderView: UIView {
    
    @IBOutlet weak var personSettingButton: UIButton!
    var delegate:MineHeaderViewDelegate?
}


// MARK:- 提供一个快速创建View的类方法
extension MineHeaderView {
    class func mineHeaderView() -> MineHeaderView {
        return Bundle.main.loadNibNamed("MineHeaderView", owner: nil, options: nil)?.first as! MineHeaderView
    }
}

// MARK: - 点击代理
extension MineHeaderView {
    
    @IBAction func mineSettingButtonClick(_ sender: Any) {
        delegate?.mineHeaderViewSettingClick(self)
    }
    
    @IBAction func mineHobbyButtonClick(_ sender: Any) {
        delegate?.mineHeaderViewHobbyClick(self)
    }
    
    @IBAction func mineShareButtonClick(_ sender: Any) {
        delegate?.mineHeaderViewShareClick(self)
    }
    
    @IBAction func minepersonSettingClick(_ sender: Any) {
        delegate?.mineHeaderViewPersonSettingClick(self)
    }
}
