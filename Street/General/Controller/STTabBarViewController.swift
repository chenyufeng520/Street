//
//  STTabBarViewController.swift
//  Street
//
//  Created by 陈宇峰 on 2019/5/13.
//  Copyright © 2019 inmyshow. All rights reserved.
//

import UIKit

class STTabBarViewController: UITabBarController {
    
    //定义一个变量，控制如何跳转
    var change: Bool = true
    
    //MARK: --setter getter
    var _lastSelectedIndex: NSInteger!
    var lastSelectedIndex: NSInteger {
        if _lastSelectedIndex == nil {
            _lastSelectedIndex = NSInteger()
            //判断是否相等,不同才设置
            if (self.selectedIndex != selectedIndex) {
                //设置最近一次
                _lastSelectedIndex = self.selectedIndex;
            }
            //调用父类的setSelectedIndex
            super.selectedIndex = selectedIndex
        }
        return _lastSelectedIndex
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tabbar = UITabBar.appearance()
        tabbar.tintColor = UIColor.colorFromHex(rgbValue: 0x262626)
        tabbar.unselectedItemTintColor = UIColor.colorFromHex(rgbValue: 0xC0C0C0)
        self.tabBarController?.hidesBottomBarWhenPushed = true
        self.addChildViewControllers()
        
        self.delegate = self
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
        
        if title.isEmpty {
            childController.tabBarItem.imageInsets = UIEdgeInsets.init(top: 6, left: 0, bottom: -6, right: 0)
        }
        
        let navC = STNavigationController(rootViewController: childController)
        self.addChild(navC)
    }
    
}

//MARK: -- UITabBar点击
extension STTabBarViewController  {
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        //获取选中的item
        let tabIndex = tabBar.items?.index(of: item)
        if tabIndex != self.selectedIndex {
            //设置最近一次变更
            _lastSelectedIndex = self.selectedIndex
        }
        
        //手动添加消息红点假数据
        if tabIndex == 1 {
            item.badgeValue = "\(arc4random()%20)"
        }
    }
    
}

//MARK: -- UITabBarControllerDelegate
extension STTabBarViewController:UITabBarControllerDelegate  {
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if viewController == self.viewControllers![2]  {
            if change {
                self.selectedIndex = _lastSelectedIndex
                showLoginView()
                return false
            } else {
                return true
            }
        }
        return true
    }
}

// MARK: - 显示登录页
extension STTabBarViewController {
    
    func showLoginView() {
        let loginVC = STLoginViewController()
        loginVC.modalPresentationStyle = .overCurrentContext
        self.present(loginVC, animated: true, completion: nil)
    }
}
