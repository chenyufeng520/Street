//
//  STWebViewController.swift
//  Street
//
//  Created by 陈宇峰 on 2019/5/20.
//  Copyright © 2019 inmyshow. All rights reserved.
//

import UIKit
import WebKit

class STWebViewController: UIViewController {

    public var urlString:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let webView = WKWebView.init(frame: CGRect.init(x: 0, y: kNavigationHeight, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - kNavigationHeight - kTabBarHeight))
        
        let url = URL(string: urlString!)
        let request = URLRequest.init(url: url!)
    
        webView.load(request)
        self.view.addSubview(webView)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
