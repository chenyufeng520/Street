//
//  STLoginViewController.swift
//  Street
//
//  Created by 陈宇峰 on 2019/6/1.
//  Copyright © 2019 inmyshow. All rights reserved.
//

import UIKit

class STLoginViewController: STBaseViewController {

    private var loginView:LoginView = {
        
        let login = Bundle.main.loadNibNamed("LoginView", owner: nil, options: nil)?.first as! LoginView
        return login
    }()

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 0.3) {
            self.view.backgroundColor = UIColor.colorFromHexA(rgbValue: 0x000000, alpha: 0.1)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.clear
        title = "登录"
        
        view.addSubview(loginView)
        loginView.frame = CGRect(x: 0, y: 0, width: 280, height: 350)
        loginView.center = view.center
        loginView.getBack { [weak self] (value) in
            self?.view.backgroundColor = UIColor.clear
            self?.dismiss(animated: true, completion: nil)
        }
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
