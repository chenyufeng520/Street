//
//  NoticeListViewController.swift
//  Street
//
//  Created by 陈宇峰 on 2019/5/28.
//  Copyright © 2019 inmyshow. All rights reserved.
//

import UIKit

let noticeListCelliden = "noticeListCelliden"

class NoticeListViewController: STBaseViewController {

    lazy var showTableView:UITableView = {
        
        let table = UITableView.init(frame: .init(x: 0, y: kNavigationHeight, width: SCREEN_WIDTH, height:SCREEN_HEIGHT - kNavigationHeight ))
        table.delegate = self
        table.dataSource = self
        table.backgroundColor = UIColor.colorFromHex(rgbValue: 0xF1F1F1)
        table.showsVerticalScrollIndicator = false
        table.separatorStyle = .none
        table.register(UINib(nibName: "NoticeListCell", bundle: Bundle.main), forCellReuseIdentifier: noticeListCelliden)
        if #available(iOS 11.0, *) {
            table.contentInsetAdjustmentBehavior = UIScrollView.ContentInsetAdjustmentBehavior.never
        }
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "通知"
        view.addSubview(showTableView)
    }
    
}


// MARK: - UITableViewDataSource,UITableViewDelegate
extension NoticeListViewController : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 20
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 200
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: noticeListCelliden) as? NoticeListCell
        if cell == nil {
            cell = NoticeListCell.init(style: .default, reuseIdentifier: noticeListCelliden)
        }
        cell?.selectionStyle = .none
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView .deselectRow(at: indexPath, animated: true)
        print("选中了第\(indexPath.row)行====详情")
    }
}
