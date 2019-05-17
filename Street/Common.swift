//
//  Common.swift
//  Street
//
//  Created by 陈宇峰 on 2019/5/14.
//  Copyright © 2019 inmyshow. All rights reserved.
//

import UIKit

/// 服务器地址
let BASE_URL = "http://47.96.237.239:8080" //测试环境
//let BASE_URL = "https://api.xi5jie.com"    //正式环境

/// 屏幕的宽
let SCREEN_WIDTH = UIScreen.main.bounds.size.width
/// 屏幕的高
let SCREEN_HEIGHT = UIScreen.main.bounds.size.height

//rbg转UIColor(16进制)
func kRGBColorFromHex(rgbValue: Int) -> (UIColor) {
    
  return UIColor(red: ((CGFloat)((rgbValue & 0xFF0000) >> 16)) / 255.0,green: ((CGFloat)((rgbValue & 0xFF00) >> 8)) / 255.0, blue: ((CGFloat)(rgbValue & 0xFF)) / 255.0, alpha: 1.0)
    
}


