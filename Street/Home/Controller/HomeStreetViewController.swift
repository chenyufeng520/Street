//
//  HomeStreetViewController.swift
//  Street
//
//  Created by 陈宇峰 on 2019/5/14.
//  Copyright © 2019 inmyshow. All rights reserved.
//

import UIKit
import MJRefresh

class HomeStreetViewController: STBaseViewController,StreetHeaderSelectDelegate,StreetListSelectDelegate {

    //MARK: - 属性
    var currentPageNo:Int = 1
    var nextPageNo:Int = -1
    var listDataArray = [StreetModel]()
    
    lazy var showTableView:UITableView = {
        
        let table = UITableView.init(frame: .init(x: 0, y: kNavigationHeight, width: SCREEN_WIDTH, height:SCREEN_HEIGHT - kNavigationHeight - kTabBarHeight))
        table.delegate = self
        table.dataSource = self
        table.backgroundColor = UIColor.colorFromHex(rgbValue: 0xF1F1F1)
        table.showsVerticalScrollIndicator = false
        table.separatorStyle = .none
        if #available(iOS 11.0, *) {
            table.contentInsetAdjustmentBehavior = UIScrollView.ContentInsetAdjustmentBehavior.never
        }
        return table
    }()
    
    //MARK: - 系统回调
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.view.addSubview(showTableView)
        
        showTableView.tableFooterView = UIView()
        
        showTableView.mj_header = MJRefreshNormalHeader.init(refreshingBlock: {
            self.getListData(isRefresh: true)
        })
        
        showTableView.mj_footer = MJRefreshBackNormalFooter.init(refreshingBlock: {
            self.getListData(isRefresh: false)
        })
        
        let queue = DispatchQueue.global()
        queue.async {
            self.getZoneNavData()
        }
        queue.async {
            self.getListData(isRefresh: true)
        }
    }
    
    /// 头部UI
    func configHeaderNavUI(titleArray:[StreetNavModel]) {
        
        let headerView = StreetHeaderView.init(frame: .init(x: 0, y: 0, width: SCREEN_WIDTH, height: 84), titleArray: titleArray)
        headerView.backgroundColor = UIColor.colorFromHex(rgbValue: 0xF1F1F1)
        headerView.delegate = self
        showTableView.tableHeaderView = headerView
    }
}

// MARK: - UITableViewDataSource,UITableViewDelegate
extension HomeStreetViewController : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.listDataArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        var tempModel = StreetModel()
        tempModel = self.listDataArray[indexPath.row]
        if Int(tempModel.model) == 1 {
            return 190
        }
        else {
            return 310
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let tempModel:StreetModel = self.listDataArray[indexPath.row]
        
        if Int(tempModel.model) == 1 {
            
            let cellID = NSStringFromClass(StreetBannerCell.self)
            var cell = tableView.dequeueReusableCell(withIdentifier: cellID) as? StreetBannerCell
            if cell == nil {
                cell = StreetBannerCell.init(style: .default, reuseIdentifier: cellID)
            }
            
            cell?.model = tempModel
            cell?.selectionStyle = .none
            
            return cell!
        }
        else {
            
            let cellID = NSStringFromClass(StreetListCell.self)
            var cell = tableView.dequeueReusableCell(withIdentifier: cellID) as? StreetListCell
            if cell == nil {
                cell = StreetListCell.init(style: .default, reuseIdentifier: cellID)
            }
            
            cell?.tag = indexPath.row
            cell?.delegate = self
            cell?.loadCellWithModel(model: tempModel)
            cell?.selectionStyle = .none
            
            return cell!
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let tempModel:StreetModel = self.listDataArray[indexPath.row]
        if Int(tempModel.model) == 1 {
            print("选中了第\(indexPath.row)行====广告详情")
        }
        else {
            print("选中了第\(indexPath.row)行====文章详情 ")
        }
    }
}


// MARK: - 网络请求
extension HomeStreetViewController {
    
    //获取列表数据
    func getListData(isRefresh:Bool)  {
        
        if isRefresh == false {
            if self.nextPageNo <= 0 {
                self.showTableView.mj_footer.endRefreshing()
                self.showTableView.mj_footer.endRefreshingWithNoMoreData()
                return
            }
        }
        
        var params = [String : Any]()
        params["jqid"] = "0"
        params["pageNo"] = "\(self.currentPageNo)"
        params["dir"] = isRefresh == true ? "0" : "1"
        params["jqid"] = "0"
        if isRefresh == true {
            if self.listDataArray.count > 0 {
                let model:StreetModel = self.listDataArray.first!
                params["lastid"] = "\(model.lastid)"
            }
        }
        else {
            if self.listDataArray.count > 0 {
                let model:StreetModel = self.listDataArray.last!
                params["lastid"] = "\(model.lastid)"
            }
        }

        LTLSNetworkManager.shared()?.get("/community/articleStar", parameters: params, success: { (task, responseObject) in
            
            objc_sync_enter(self)
            
            if isRefresh == true {
                self.listDataArray.removeAll()
            }
            
            if let dic = responseObject as? [String : Any] {
                if let dataDic = dic["data"] as? [String : Any] {
                    
                    if let page = dataDic["page"] as? [String : Any] {
                        self.currentPageNo = page["currentPageNo"] as! Int
                        self.nextPageNo = page["nextPageNo"] as! Int
                    }
                    
                    if let array = dataDic["pageContent"] as? [Any] {
                        
                        self.listDataArray += array.compactMap({ StreetModel.deserialize(from: $0 as? Dictionary) })
                    }
                }
            }
            
             objc_sync_exit(self)
            
            self.showTableView.reloadData()
            if isRefresh == true {
                self.showTableView.mj_header.endRefreshing()
            }
            else {
                self.showTableView.mj_header.endRefreshing()
            }

        }, failure: { (task, responseObject, error) in
            
            if isRefresh == true {
                self.showTableView.mj_header.endRefreshing()
            }
            else {
                self.showTableView.mj_header.endRefreshing()
            }
            print(error as Any);
        })
    }
    
    //获取导航数据
    func getZoneNavData()  {
        
        LTLSNetworkManager.shared()?.get("/config/zone/nav", parameters: nil, success: { (task, responseObject) in
            
            objc_sync_enter(self)
            
            var titleArray = [StreetNavModel]()
            if let dic = responseObject as? [String : Any] {
                if let dataDic = dic["data"] as? [String : Any] {
                    
                    if let array = dataDic["group"] as? [Any] {
                        
                        titleArray += array.compactMap({ StreetNavModel.deserialize(from: $0 as? Dictionary) })
                    }
                }
            }
            
            objc_sync_exit(self)
            
            DispatchQueue.main.async {
                self.configHeaderNavUI(titleArray: titleArray)
            }
            
        }, failure: { (task, responseObject, error) in
            
            print(error as Any);
        })
    }
}

//MARK: - 代理
extension HomeStreetViewController {
    
    //MARK: - StreetHeaderSelectDelegate代理
    func streetHeaderSelectWithCurrentIndex(index: NSInteger, streetId: String) {
        print("点击了第\(index)行,街区id为" + streetId)
    }
    
    //MARK: - StreetListSelectDelegate代理
    func StreetListSelectCurrentUserImage(index: NSInteger, uid: String) {
        print("点击了第\(index)行,用户id为" + uid)
        
        let loginVC = STLoginViewController()
        loginVC.modalPresentationStyle = .overCurrentContext
        self.present(loginVC, animated: true, completion: nil)
    }
    
    func StreetListSelectCurrentStreet(index: NSInteger, streetId: String) {
        print("点击了第\(index)行,街区id为" + streetId)
        
        let loginVC = STLoginViewController()
        loginVC.modalPresentationStyle = .overCurrentContext
        self.present(loginVC, animated: true, completion: nil)
        
    }
}
