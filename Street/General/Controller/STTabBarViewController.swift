//
//  STTabBarViewController.swift
//  Street
//
//  Created by 陈宇峰 on 2019/5/13.
//  Copyright © 2019 inmyshow. All rights reserved.
//

import UIKit

class STTabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let tabbar = UITabBar.appearance()
        tabbar.tintColor = kRGBColorFromHex(rgbValue: 0x262626)
        tabbar.unselectedItemTintColor = kRGBColorFromHex(rgbValue: 0xC0C0C0)
        self.addChildViewControllers()
        
    }
    
    /**
     * 添加子控制器
     */
    private func addChildViewControllers() {
        
        addChildViewController(childController: HomeStreetViewController(), title: "首页", imageName: "street")
        addChildViewController(childController: AttentionViewController(), title: "关注", imageName: "attention")
        addChildViewController(childController: PublishViewController(), title: "", imageName: "tabbar_publish")
        addChildViewController(childController: ShopViewController(), title: "福利", imageName: "shop")
        addChildViewController(childController: MineViewController(), title: "我的", imageName: "mine")
    }

    /**
     # 初始化子控制器
     
     - parameter childControllerName: 需要初始化的控制器
     - parameter title:               标题
     - parameter imageName:           图片名称
     */
    private func addChildViewController(childController:UIViewController, title:String, imageName:String) {
        childController.tabBarItem.image = UIImage(named: imageName)?.withRenderingMode(.alwaysOriginal)
        childController.tabBarItem.selectedImage = UIImage(named: imageName + "_s")?.withRenderingMode(.alwaysOriginal)
        childController.tabBarItem.title = title;
        childController.title = title
        
        let navC = STNavigationController(rootViewController: childController)
        self.addChild(navC)
    }

}
