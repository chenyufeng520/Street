//
//  LoginView.swift
//  Street
//
//  Created by 陈宇峰 on 2019/6/1.
//  Copyright © 2019 inmyshow. All rights reserved.
//

import UIKit

class LoginView: UIView {

    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var phoneLogin: UIButton!
    @IBOutlet weak var weixinLogin: UIButton!
    
    typealias loginBackBlock = (String) ->()
    var backBlock :loginBackBlock?
    
    func getBack (block:loginBackBlock?){
        backBlock = block
    }
    
    @IBAction func backButtonClick(_ sender: Any) {
        
        if let block = self.backBlock{
            block("back")
        }
    }
    
    @IBAction func phoneLoginClick(_ sender: Any) {
    }
    
    @IBAction func weixinLoginClick(_ sender: Any) {
    }
}
