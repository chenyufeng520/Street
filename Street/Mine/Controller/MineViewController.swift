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
    
    lazy var feedBackButton : UIButton = {
        let button = UIButton.init(type: UIButton.ButtonType.custom)
        button .setTitle("用户反馈", for: .normal)
        button.setImage(UIImage(named: "feedback"), for: .normal)
        button.backgroundColor = UIColor.white
        button.setTitleColor(UIColor.colorFromHex(rgbValue: 0x151515), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 4)
        button.addTarget(self, action: #selector(feedbackButtonAction), for: .touchUpInside)
        
        button.frame = CGRect(x: SCREEN_WIDTH - 80, y: SCREEN_HEIGHT - kTabBarHeight - 90, width: 80, height: 30)
        let path = UIBezierPath(roundedRect: button.bounds, byRoundingCorners: [.topLeft, .bottomLeft], cornerRadii: CGSize(width: 15, height: 15))
        let mask = CAShapeLayer.init()
        mask.frame = button.bounds;
        mask.path = path.cgPath
        button.layer.mask = mask
        
        return button
    }()
    
    lazy var collectionView : UICollectionView = {
        
        let layout = UICollectionViewFlowLayout.init()
        layout.minimumLineSpacing = 5
        layout.minimumInteritemSpacing = 5
        layout.scrollDirection = .vertical
        
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.backgroundColor = UIColor.colorFromHex(rgbValue: 0xF1F1F1)
        collection.delegate = self
        collection.dataSource = self
        collection.register(UINib(nibName: "CardCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: mineListCellIden)
        //防止iOS11BUG，顶部偏移
        if #available(iOS 11.0, *) {
            collection.contentInsetAdjustmentBehavior = .never
        }
        return collection
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        view.addSubview(collectionView)
        collectionView.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT  - kTabBarHeight)
        //头部
        collectionView.addSubview(mineHeaderView)
        mineHeaderView.delegate = self
        collectionView.contentInset = UIEdgeInsets(top: mineHeaderViewH, left: 0, bottom: 0, right: 0)
        
        //用户反馈
        view.addSubview(feedBackButton)
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
   
        cell.backgroundColor = UIColor.white
        cell.titleLabel.text = "卡片标题详情\(indexPath.item)"
        cell.praiseButton.setTitle("\(arc4random()%50)", for: .normal)
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
        let shareTool = CustomShareTool.init(frame: .zero)
        shareTool.showShareView()
    }
    
    func mineHeaderViewPersonSettingClick(_ headerView: MineHeaderView) {
        print("点击个人信息")
        //        headerView.personSettingButton.setTitle("点击了", for: .normal)
    }
    
}

// MARK: - ScrollView的滚动代理
extension MineViewController:UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        var offSetY = scrollView.contentOffset.y + mineHeaderViewH
        
        if offSetY < 0 {
            offSetY = 0
            collectionView.setContentOffset(CGPoint(x: 0, y: -mineHeaderViewH), animated: false)
            return
        }
        
        if offSetY > kNavigationHeight {
            self.navigationController?.setNavigationBarHidden(false, animated: true)

        }
        else {
            self.navigationController?.setNavigationBarHidden(true, animated: true)
        }
    }
}

// MARK: - 用户反馈
extension MineViewController {
    
    @objc func feedbackButtonAction() {
        let feedbackVC = FeedBackViewController.init(nibName: "FeedBackViewController", bundle: nil)
        self.navigationController?.pushViewController(feedbackVC, animated: true)
    }
}
