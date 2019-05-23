//
//  StreetHeaderView.swift
//  Street
//
//  Created by 陈宇峰 on 2019/5/20.
//  Copyright © 2019 inmyshow. All rights reserved.
//

import UIKit

protocol StreetHeaderSelectDelegate {
    func streetHeaderSelectWithCurrentIndex(index:NSInteger)
}

class StreetHeaderView: UIView {
    
    var delegate:StreetHeaderSelectDelegate?
    
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
        self.addSubview(collectionView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


extension StreetHeaderView :UICollectionViewDelegate ,UICollectionViewDataSource ,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell:StreetCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: Identifier, for: indexPath) as! StreetCollectionViewCell
        cell.showImageView.backgroundColor = KRandomColor()
        cell.titleLable.text = "标题\(indexPath.row)"
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        delegate?.streetHeaderSelectWithCurrentIndex(index: indexPath.row)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize.init(width: 100, height: 64)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets.init(top: 0, left: 10, bottom: 0, right: 10)
    }
}
