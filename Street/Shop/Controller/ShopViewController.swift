//
//  ShopViewController.swift
//  Street
//
//  Created by 陈宇峰 on 2019/5/14.
//  Copyright © 2019 inmyshow. All rights reserved.
//

import UIKit
import WebKit

class ShopViewController: STBaseViewController {

    public var urlString:String?
    
    override func viewDidLoad() {
        
        urlString = HostH5BaseURLPath + "/integralmall/index?utm_from=myHome&pname=home"
        let webView = WKWebView.init(frame: CGRect.init(x: 0, y: kNavigationHeight, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - kNavigationHeight - kTabBarHeight))
        
        let url = URL(string: urlString!)
        let request = URLRequest.init(url: url!)
        
        webView.load(request)
        self.view.addSubview(webView)
    }
}
