//
//  StreetModel.swift
//  Street
//
//  Created by 陈宇峰 on 2019/5/15.
//  Copyright © 2019 inmyshow. All rights reserved.
//

import UIKit

class StreetModel: BaseModel {

    var model = String()
    var add_time = String()
    var avatar = String()
    var banner = [StreetPicModel]()
    var comment_num = String()
    var desc = String()
    var favorite_num = String()
    var id = String()
    var idtype = String()
    var is_kol = String()
    var is_like = String()
    var is_recommend = String()
    var jiequ = StreetJiequModel()
    var kol_intr = String()
    var kol_pic = String()
    var lastid = String()
    var like_num = String()
    var nick = String()
    var pict_url = StreetPicModel()
    var pic = StreetPicModel()
    var publish_time = String()
    var title = String()
    var type = String()
    var uid = String()
    
}


class StreetPicModel: BaseModel {
    
    var h = String()
    var w = String()
    var src = String()
    var rgb = String()
}

class StreetJiequModel: BaseModel {
    
    var jqid = String()
    var jqname = String()
}
