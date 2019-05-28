//
//  AttentionViewController.swift
//  Street
//
//  Created by 陈宇峰 on 2019/5/14.
//  Copyright © 2019 inmyshow. All rights reserved.
//

import UIKit
import MJRefresh

class AttentionViewController: STBaseViewController {

    var listDataArray = [MessageListModel]()
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(showTableView)
        
        let headerView:MessageHeaderView = MessageHeaderView.init(frame: .init(x: 0, y: 0, width: SCREEN_WIDTH, height: 100))
        headerView.backgroundColor = UIColor.white
        headerView.delegate = self
        showTableView.tableHeaderView = headerView
        
        showTableView.tableFooterView = UIView()
        
        showTableView.mj_header = MJRefreshNormalHeader.init(refreshingBlock: {
            self.getMessageListData()
        })
        
        getMessageListData()
    }
}

// MARK: - UITableViewDataSource,UITableViewDelegate
extension AttentionViewController : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.listDataArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 70
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let tempModel:MessageListModel = self.listDataArray[indexPath.row]
        
        let cellID = NSStringFromClass(MessageListCell.self)
        var cell = tableView.dequeueReusableCell(withIdentifier: cellID) as? MessageListCell
        if cell == nil {
            cell = MessageListCell.init(style: .default, reuseIdentifier: cellID)
        }

        cell?.loadCellWithModel(model: tempModel)
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView .deselectRow(at: indexPath, animated: true)
        print("选中了第\(indexPath.row)行====详情")
    }
}


// MARK: - 网络请求
extension AttentionViewController {
    
    //模拟假数据
    func getMessageListData()  {
        for _ in 0...12 {
            let model:MessageListModel = MessageListModel()
            self.listDataArray.append(model)
        }
        showTableView.reloadData()
        showTableView.mj_header.endRefreshing()
    }
    
    
    //获取列表数据
//    func getMessageListData()  {
//
//        var params = [String : Any]()
//        params["pageNo"] = "1"
//
//        LTLSNetworkManager.shared()?.get("/chat/list", parameters: params, success: { (task, responseObject) in
//
//            objc_sync_enter(self)
//
//            self.listDataArray.removeAll()
//
//            if let dic = responseObject as? [String : Any] {
//                if let dataDic = dic["data"] as? [String : Any] {
//
//                    if let array = dataDic["pageContent"] as? [Any] {
//
//                        self.listDataArray += array.compactMap({ MessageListModel.deserialize(from: $0 as? Dictionary) })
//                    }
//                }
//            }
//
//            self.showTableView.reloadData()
//            self.showTableView.mj_header.endRefreshing()
//
//            objc_sync_exit(self)
//
//        }, failure: { (task, responseObject, error) in
//
//            self.showTableView.mj_header.endRefreshing()
//            print(error as Any);
//        })
//    }
    
}

// MARK: - d头部代理
extension AttentionViewController :MessageHeaderViewProtocol {
    
    func selectMessageHeaderView(messageType: MessageType) {
        switch messageType {
        case .comment:
            print("评论列表")
        case .priase:
            print("点赞列表")
        case .attention:
            print("关注列表")
        case .notice:
            print("通知列表")
        }
    }

}
