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

let HostH5BaseURLPath = "http://47.96.237.239:8082";//测试环境（H5）
//let HostH5BaseURLPath = "https://appview.xi5jie.com";//正式环境H5）
/// 屏幕的宽
let SCREEN_WIDTH = UIScreen.main.bounds.size.width
/// 屏幕的高
let SCREEN_HEIGHT = UIScreen.main.bounds.size.height

//判断是否是iPhone
let isPhone = Bool(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.phone)

//判断是否是iPhone X
let isPhoneX = Bool(SCREEN_WIDTH >= 375.0 && SCREEN_HEIGHT >= 812.0 && isPhone)

//导航条的高度
let kNavigationHeight = CGFloat(isPhoneX ? 88 : 64)

//状态栏高度
let kStatusBarHeight = CGFloat(isPhoneX ? 44 : 20)

//tabbar高度
let kTabBarHeight = CGFloat(isPhoneX ? (49 + 34) : 49)

//顶部安全区域远离高度
let kTopSafeHeight = CGFloat(isPhoneX ? 44 : 0)

//底部安全区域远离高度
let kBottomSafeHeight = CGFloat(isPhoneX ? 34 : 0)

//图片压缩处理
func kPicSale(_ sale:CGFloat) -> String {
    return "?imageMogr2/auto-orient/interlace/1/thumbnail/\(sale)x%3E/quality/80"
}

