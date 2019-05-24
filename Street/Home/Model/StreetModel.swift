//
//  StreetModel.swift
//  Street
//
//  Created by 陈宇峰 on 2019/5/15.
//  Copyright © 2019 inmyshow. All rights reserved.
//

import UIKit

class StreetModel: BaseModel {

    var avatar = String()
    var nick = String()
    var publish_time = String()
    var model = String()
    var lastid = String()
    var pic = StreetPicModel()
    var pict_url = StreetPicModel()
}


class StreetPicModel: BaseModel {
    
    var h = String()
    var w = String()
    var src = String()
    var rgb = String()
}
