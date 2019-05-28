//
//  StreetBannerCell.swift
//  Street
//
//  Created by 陈宇峰 on 2019/5/17.
//  Copyright © 2019 inmyshow. All rights reserved.
//

import UIKit
import SnapKit
import Kingfisher

class StreetBannerCell: UITableViewCell {
    
    var showImageView = UIImageView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = UIColor.colorFromHex(rgbValue: 0xF1F1F1)
        self.configUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configUI() {
        
        showImageView = UIImageView.init()
        showImageView.contentMode = .scaleAspectFill
        showImageView.layer.masksToBounds = true
        showImageView.layer.cornerRadius = 8
        self.contentView.addSubview(showImageView)
        
        showImageView.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(5)
            make.right.equalTo(self).offset(-5)
            make.top.equalTo(self).offset(0)
            make.bottom.equalTo(self).offset(-10)
        }
        
    }
    
    func loadCellWithModel(model:StreetModel) {
        
        let url = URL(string:model.pic.src)
        
        showImageView.kf.setImage(with: ImageResource.init(downloadURL:url!))
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
