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

    var headerView = StreetHeaderView()
    var listDataArray = [StreetModel]()
    
    //底部上拉加载
    let bottom_footer = MJRefreshAutoNormalFooter()
    
    lazy var showTableView:UITableView = {
        
        let table = UITableView.init(frame: .init(x: 0, y: kNavigationHeight, width: SCREEN_WIDTH, height:SCREEN_HEIGHT - kNavigationHeight - kTabBarHeight))
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
        
        headerView = StreetHeaderView.init(frame: .init(x: 0, y: 0, width: SCREEN_WIDTH, height: 84))
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
        
    
        NetWorkTool.shareNetworkTool.getData {
    
//            self.listDataArray.removeAllObjects()
            self.listDataArray = $0
            self.showTableView.reloadData()
            
            self.showTableView.mj_header.endRefreshing()

        }
        
    }
    
    @objc func getMoreListData()  {
        
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
        
        var tempModel = StreetModel()
        tempModel = self.listDataArray[indexPath.row]
        if Int(tempModel.model) == 1 {
            return 180
        }
        else {
            return 300
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var tempModel = StreetModel()
        tempModel = self.listDataArray[indexPath.row]
        
        if Int(tempModel.model) == 1 {
            
            let cellID = NSStringFromClass(StreetBannerCell.self)
            
            var cell = tableView.dequeueReusableCell(withIdentifier: cellID) as? StreetBannerCell
            if cell == nil {
                cell = StreetBannerCell.init(style: .default, reuseIdentifier: cellID)
            }
            
            cell?.loadCellWithModel(model: tempModel)
            
            cell?.selectionStyle = .none
            
            return cell!
        }
        else {
            
            let cellID = NSStringFromClass(StreetListCell.self)
            
            var cell = tableView.dequeueReusableCell(withIdentifier: cellID) as? StreetListCell
            if cell == nil {
                cell = StreetListCell.init(style: .default, reuseIdentifier: cellID)
            }
            
            cell?.loadCellWithModel(model: tempModel)
            
            cell?.selectionStyle = .none
            
            return cell!
        }
    
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print("选中了第\(indexPath.row)行")
    }
    
}
