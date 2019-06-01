//
//  CALayer+Extension.swift
//  Street
//
//  Created by 陈宇峰 on 2019/6/1.
//  Copyright © 2019 inmyshow. All rights reserved.
//

import UIKit

extension CALayer {
    
    func setBorderColorFromUIColor(rgbValue: Int) {
        
        self.borderColor =  UIColor(red: ((CGFloat)((rgbValue & 0xFF0000) >> 16)) / 255.0,green: ((CGFloat)((rgbValue & 0xFF00) >> 8)) / 255.0, blue: ((CGFloat)(rgbValue & 0xFF)) / 255.0, alpha: 1.0).cgColor
        
    }
}
