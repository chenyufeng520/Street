//
//  StreetNavModel.swift
//  Street
//
//  Created by 陈宇峰 on 2019/5/27.
//  Copyright © 2019 inmyshow. All rights reserved.
//

import UIKit

class StreetNavModel: BaseModel {

    var title = String()
    var jqid = String()
    var pic = StreetNavPicModel()
}

class StreetNavPicModel: BaseModel {
    
    var h = String()
    var w = String()
    var src = String()
    var rgb = String()
}
