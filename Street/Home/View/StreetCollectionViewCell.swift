//
//  StreetCollectionViewCell.swift
//  Street
//
//  Created by 陈宇峰 on 2019/5/21.
//  Copyright © 2019 inmyshow. All rights reserved.
//

import UIKit

class StreetCollectionViewCell: UICollectionViewCell {
    
    var showImageView = UIImageView()
    var titleLable = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.configUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configUI() {
        
        showImageView = UIImageView.init()
        showImageView.frame = self.bounds
        showImageView.layer.cornerRadius = 8
        showImageView.contentMode = .scaleAspectFill
        showImageView.layer.masksToBounds = true
        self.addSubview(showImageView)
        
        titleLable = UILabel.init()
        titleLable.frame = CGRect.init(x: 0, y: self.frame.height - 30, width: self.frame.width, height: 30)
        titleLable.textAlignment = .center
        titleLable.textColor = UIColor.white
        titleLable.font = UIFont.boldSystemFont(ofSize: 13)
        self.addSubview(titleLable)
        
    }
    
}
