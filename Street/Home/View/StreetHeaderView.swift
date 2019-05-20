//
//  StreetHeaderView.swift
//  Street
//
//  Created by 陈宇峰 on 2019/5/20.
//  Copyright © 2019 inmyshow. All rights reserved.
//

import UIKit

class StreetHeaderView: UIView {
    
    let Identifier = "cell";
    
    lazy var collectionView : UICollectionView = {
        
        let layout = UICollectionViewFlowLayout.init()
        layout.minimumLineSpacing = 5
        layout.minimumInteritemSpacing = 5
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize.init(width: 100, height: 64)
        
        let collection = UICollectionView.init(frame:CGRect.init(x: 0, y: 10, width: self.frame.width, height: 64), collectionViewLayout: layout)
        collection.backgroundColor = UIColor.white
        collection.delegate = self
        collection.dataSource = self
        collection.register(UICollectionViewCell.self, forCellWithReuseIdentifier: Identifier)
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


extension StreetHeaderView :UICollectionViewDelegate ,UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell:UICollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: Identifier, for: indexPath)
        cell.backgroundColor = UIColor.gray
      
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        print("点击了")
    }
    
}
