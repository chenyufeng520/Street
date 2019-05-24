//
//  NetWorkTool.swift
//  Street
//
//  Created by 陈宇峰 on 2019/5/15.
//  Copyright © 2019 inmyshow. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD
import SwiftyJSON

enum methodType {
    case get
    case post
}

class NetWorkTool: NSObject {
    
    /// 单例
    static let shareNetworkTool = NetWorkTool()
    
    func NetWorkToolRequest(method: methodType, url: String, parameters: [String:Any]?, _ completionHandler: @escaping (_ result: Any?) -> ()){
        
        
        let headers:HTTPHeaders = [
           "Accept-Language" : "zh-Hans-US;q=1, en;q=0.9"
        ]
        
        Alamofire.request(url, method: method == methodType.get ? .get : .post ,parameters: parameters, encoding: URLEncoding.default, headers: headers).responseJSON { (response) in
            
            let dict = JSON(response.result.value!)
            completionHandler(dict)
        }
    }
    
    
    //暂时写死
    func getData(_ completionHandler: @escaping (_ listArray: [StreetModel]) -> ()) {
        
        let url = BASE_URL + "/community/articleStar"
        
        let headers:HTTPHeaders = [
            "Accept-Language" : "zh-Hans-US;q=1, en;q=0.9",
            "User-Agent" : "iOS12.1;iPhone;zh-Hans_US;20300/2.3.0;414x736;F2864937-FE08-4729-A650-753A108137E6",
            "paiAppVer" : "20300",
            "paiChannel" : "AppStore",
            "paiPlatform" : "ios",
            "paiScreen" : "414x736",
            "paiSession" : "",
            "paiSign" : "5747d082a7d7b32ab23042141bdbdc82",
            "paiTime" : "1557911653847",
            "paiVer" : "20300"
        ]
        
        Alamofire.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: headers).responseJSON { (response) in
            if(response.error == nil){
                
                print(response.result.value!)
                
                let dict = JSON(response.result.value!)
                let code = dict["code"].intValue
                
                if let datas = dict["data"]["pageContent"].arrayObject {
                    var titles = [StreetModel]()
                    
                    titles += datas.compactMap({ StreetModel.deserialize(from: $0 as? Dictionary) })
                    completionHandler(titles)
                }
                
                //                guard let datas = dict["data"]["pageContent"].array else { return }
                //                completionHandler(datas.compactMap({ StreetModel.deserialize(from: $0["content"].string) }))
                
                if code == 200 {
                    SVProgressHUD.showInfo(withStatus: "请求成功")
                }
                
                
            }else{
                print("请求失败\(String(describing: response.error))")
            }
            
        }
        
    }
    
    
}
