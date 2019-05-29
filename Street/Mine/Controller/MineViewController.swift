//
//  MineViewController.swift
//  Street
//
//  Created by 陈宇峰 on 2019/5/14.
//  Copyright © 2019 inmyshow. All rights reserved.
//

import UIKit

let mineListCellIden = "mineListCellIden"
let cardW = (SCREEN_WIDTH - 15)/2
let cardH:CGFloat = 300


class MineViewController: STBaseViewController {

    lazy var collectionView : UICollectionView = {
        
        let layout = UICollectionViewFlowLayout.init()
        layout.minimumLineSpacing = 5
        layout.minimumInteritemSpacing = 5
        layout.scrollDirection = .vertical
        
        let collection = UICollectionView.init(frame:CGRect.init(x: 0, y: kNavigationHeight, width:SCREEN_WIDTH, height: SCREEN_HEIGHT - kNavigationHeight - kTabBarHeight), collectionViewLayout: layout)
        collection.backgroundColor = UIColor.colorFromHex(rgbValue: 0xF1F1F1)
        collection.delegate = self
        collection.dataSource = self
        collection.register(UINib(nibName: "CardCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: mineListCellIden)
        collection.showsHorizontalScrollIndicator = false
        return collection
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(collectionView)
    }
}

// MARK: - UICollectionView代理
extension MineViewController :UICollectionViewDelegate ,UICollectionViewDataSource ,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell:CardCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: mineListCellIden, for: indexPath) as! CardCollectionViewCell
        
//        cell.showImageView.backgroundColor = UIColor.randomColor()
//        cell.nickNameLabel.text = "懒羊羊\(indexPath.item)"
//        cell.titleLabel.text = "测试标题\(indexPath.item)"
        
        cell.backgroundColor = UIColor.white
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize.init(width: cardW, height: cardH)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {

        return UIEdgeInsets.init(top: 5, left: 5, bottom: 5, right: 5)
    }
}
