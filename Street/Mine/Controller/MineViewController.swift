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
let cardH:CGFloat = 280
let mineHeaderViewH:CGFloat = 238

class MineViewController: STBaseViewController {
    
    private lazy var mineHeaderView:MineHeaderView = {
        
        let headerView = MineHeaderView.mineHeaderView()
        headerView.frame = CGRect(x: 0, y: -(mineHeaderViewH), width: SCREEN_WIDTH, height: mineHeaderViewH)
        return headerView
    }()
    
    lazy var collectionView : UICollectionView = {
        
        let layout = UICollectionViewFlowLayout.init()
        layout.minimumLineSpacing = 5
        layout.minimumInteritemSpacing = 5
        layout.scrollDirection = .vertical
        
        let collection = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout)
        collection.backgroundColor = UIColor.colorFromHex(rgbValue: 0xF1F1F1)
        collection.delegate = self
        collection.dataSource = self
        collection.register(UINib(nibName: "CardCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: mineListCellIden)
        collection.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        //防止iOS11BUG，顶部偏移
        //        if #available(iOS 11.0, *) {
        //            collection.contentInsetAdjustmentBehavior = .never
        //        }
        return collection
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        view.addSubview(collectionView)
        collectionView.addSubview(mineHeaderView)
        mineHeaderView.delegate = self
        collectionView.contentInset = UIEdgeInsets(top: mineHeaderViewH, left: 0, bottom: 0, right: 0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
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

// MARK: - MineHeaderViewDelegate代理
extension MineViewController :MineHeaderViewDelegate {
    
    func mineHeaderViewSettingClick(_ headerView: MineHeaderView) {
        print("点击设置")
    }
    
    func mineHeaderViewHobbyClick(_ headerView: MineHeaderView) {
        print("点击爱好")
    }
    
    func mineHeaderViewShareClick(_ headerView: MineHeaderView) {
        print("点击分享")
    }
    
    func mineHeaderViewPersonSettingClick(_ headerView: MineHeaderView) {
        print("点击个人信息")
        //        headerView.personSettingButton.setTitle("点击了", for: .normal)
    }
    
}

// MARK: - ScrollView的滚动代理
extension MineViewController:UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offSetY = scrollView.contentOffset.y + mineHeaderViewH
        if offSetY > kNavigationHeight {
            self.navigationController?.setNavigationBarHidden(false, animated: true)
        }
        else {
            self.navigationController?.setNavigationBarHidden(true, animated: true)
        }
    }
}
