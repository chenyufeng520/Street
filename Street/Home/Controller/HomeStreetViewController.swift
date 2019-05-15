//
//  HomeStreetViewController.swift
//  Street
//
//  Created by 陈宇峰 on 2019/5/14.
//  Copyright © 2019 inmyshow. All rights reserved.
//

import UIKit
import MJRefresh

class HomeStreetViewController: STBaseViewController {

    var headerView = UIView()
    var listDataArray = NSMutableArray()
    
    //底部上拉加载
    let bottom_footer = MJRefreshAutoNormalFooter()
    
    lazy var showTableView:UITableView = {
        
        let table = UITableView.init(frame: .init(x: 0, y: 64, width: SCREEN_WIDTH, height:SCREEN_HEIGHT - 64 - 49))
        table.delegate = self
        table.dataSource = self
        table.backgroundColor = UIColor.white
        table.showsVerticalScrollIndicator = false
        if #available(iOS 11.0, *) {
            table.contentInsetAdjustmentBehavior = UIScrollView.ContentInsetAdjustmentBehavior.never
        }
        return table
    }()
    
    override func viewDidLoad() {
    
        super.viewDidLoad()
        self.view.addSubview(showTableView)
        
        headerView = UIView.init(frame: .init(x: 0, y: 0, width: SCREEN_WIDTH, height: 100))
        headerView.backgroundColor = UIColor.lightGray
        showTableView.tableHeaderView = headerView
        
        
        showTableView.mj_header = MJRefreshNormalHeader.init(refreshingBlock: {
            self.getListData()
        })

        showTableView.mj_footer = MJRefreshBackNormalFooter.init(refreshingBlock: {
            self.getMoreListData()
        })

        self.getListData()
    }

    //获取头部数据
    func getHeaderData() {
        
        Thread.sleep(forTimeInterval: 1)
        
    }
    
    func getListData()  {
        
        listDataArray.removeAllObjects()
        listDataArray.add(1)
        listDataArray.add(1)
        listDataArray.add(1)
        listDataArray.add(1)
        listDataArray.add(1)
        
        //延迟，模拟网络请求
        Thread.sleep(forTimeInterval: 1)
        showTableView.reloadData()
        showTableView.mj_header.endRefreshing()
    }
    
    @objc func getMoreListData()  {
        
        listDataArray.add(1)
        listDataArray.add(1)
        listDataArray.add(1)
        listDataArray.add(1)
        listDataArray.add(1)
        
        //延迟，模拟网络请求
        Thread.sleep(forTimeInterval: 1)
        showTableView.reloadData()
        showTableView.mj_footer.endRefreshing()
    }
    
}

extension HomeStreetViewController : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.listDataArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 170
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellID = NSStringFromClass(StreetListCell.self)
        
        var cell = tableView.dequeueReusableCell(withIdentifier: cellID) as? StreetListCell
        if cell == nil {
            cell = StreetListCell.init(style: .default, reuseIdentifier: cellID)
        }
        
        let  random1: CGFloat = CGFloat(arc4random()%255)/255
        let  random2: CGFloat = CGFloat(arc4random()%255)/255
        let  random3: CGFloat = CGFloat(arc4random()%255)/255
        
        cell?.userImageView.backgroundColor = UIColor.init(red: random1, green: random2, blue: random3, alpha: 1)
        cell?.showImageView.backgroundColor = UIColor.init(red: random1, green: random2, blue: random3, alpha: 1)
        cell?.userNickName.text = "昵称是\(indexPath.row)"
        cell?.selectionStyle = .none
        
        return cell!
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print("选中了第\(indexPath.row)行")
    }
    
}
