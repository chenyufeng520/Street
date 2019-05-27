//
//  StreetHeaderView.swift
//  Street
//
//  Created by 陈宇峰 on 2019/5/20.
//  Copyright © 2019 inmyshow. All rights reserved.
//

import UIKit
import Kingfisher

protocol StreetHeaderSelectDelegate {
    func streetHeaderSelectWithCurrentIndex(index:NSInteger, streetId:String)
}

class StreetHeaderView: UIView {
    
    var delegate:StreetHeaderSelectDelegate?
    var titleArray = [StreetNavModel]()
    
    
    let Identifier = "cell";
    
    lazy var collectionView : UICollectionView = {
        
        let layout = UICollectionViewFlowLayout.init()
        layout.minimumLineSpacing = 5
        layout.minimumInteritemSpacing = 5
        layout.scrollDirection = .horizontal
        
        let collection = UICollectionView.init(frame:CGRect.init(x: 0, y: 10, width: self.frame.width, height: 64), collectionViewLayout: layout)
        collection.backgroundColor = kRGBColorFromHex(rgbValue: 0xFAF8F7)
        collection.delegate = self
        collection.dataSource = self
        collection.register(StreetCollectionViewCell.self, forCellWithReuseIdentifier: Identifier)
        collection.showsHorizontalScrollIndicator = false
        return collection
    }()
    
    
    override init(frame: CGRect) {
       
        super.init(frame: frame)
    }
    
    init(frame: CGRect, titleArray:[StreetNavModel]) {
        super.init(frame:frame) 
        self.titleArray = titleArray
        self.addSubview(collectionView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


extension StreetHeaderView :UICollectionViewDelegate ,UICollectionViewDataSource ,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.titleArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell:StreetCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: Identifier, for: indexPath) as! StreetCollectionViewCell
        
        let model:StreetNavModel = self.titleArray[indexPath.row]
        cell.showImageView.kf.setImage(with: ImageResource(downloadURL: URL(string: model.pic.src)!))
        cell.titleLable.text = model.title
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let model:StreetNavModel = self.titleArray[indexPath.row]
        delegate?.streetHeaderSelectWithCurrentIndex(index: indexPath.row,streetId: model.jqid)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize.init(width: 100, height: 64)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets.init(top: 0, left: 10, bottom: 0, right: 10)
    }
}
