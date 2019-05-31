//
//  ShopViewController.swift
//  Street
//
//  Created by 陈宇峰 on 2019/5/14.
//  Copyright © 2019 inmyshow. All rights reserved.
//

import UIKit

let shopListCellIden = "shopListCellIden"
let shopCardW = (SCREEN_WIDTH - 15)/2
let shopCardH:CGFloat = 260

private let kshopHeaderViewH:CGFloat = 230


class ShopViewController: STBaseViewController {
    
    private lazy var shopHeaderView:ShopHeaderView = {

        let shopHeader = ShopHeaderView.shopHeaderView()
        shopHeader.frame = CGRect(x: 0, y: -(kshopHeaderViewH), width: SCREEN_WIDTH, height: kshopHeaderViewH)
        return shopHeader
    }()
    
   private lazy var collectionView : UICollectionView = {
        
        let layout = UICollectionViewFlowLayout.init()
        layout.minimumLineSpacing = 5
        layout.minimumInteritemSpacing = 5
        layout.scrollDirection = .vertical
        
        let collection = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout)
        collection.backgroundColor = UIColor.colorFromHex(rgbValue: 0xF1F1F1)
        collection.delegate = self
        collection.dataSource = self
        collection.register(UINib(nibName: "ShopCardCell", bundle: Bundle.main), forCellWithReuseIdentifier: shopListCellIden)
        collection.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        return collection
    }()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        view.addSubview(collectionView)
        collectionView.addSubview(shopHeaderView)
        collectionView.contentInset = UIEdgeInsets(top: kshopHeaderViewH, left: 0, bottom: 0, right: 0)
    }
}

// MARK: - UICollectionView代理
extension ShopViewController :UICollectionViewDelegate ,UICollectionViewDataSource ,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell:ShopCardCell = collectionView.dequeueReusableCell(withReuseIdentifier: shopListCellIden, for: indexPath) as! ShopCardCell
        
        cell.backgroundColor = UIColor.white
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize.init(width: shopCardW, height: shopCardH)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets.init(top: 5, left: 5, bottom: 5, right: 5)
    }
}
