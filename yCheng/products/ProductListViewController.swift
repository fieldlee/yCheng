//
//  ProductListViewController.swift
//  yCheng
//
//  Created by De Peng Li on 2017/5/1.
//  Copyright © 2017年 De Peng Li. All rights reserved.
//

import UIKit

class ProductListViewController: UIViewController {

    @IBOutlet weak var flowLayout: LNICoverFlowLayout!
    @IBOutlet weak var collectionView: UICollectionView!
    var originalItemSize : CGSize?
    var originalCollectionViewSize :CGSize?
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isPagingEnabled = true
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
      

        // Do any additional setup after loading the view.
        originalItemSize = flowLayout.itemSize
        originalCollectionViewSize = collectionView.bounds.size
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(2 * NSEC_PER_SEC)) / Double(NSEC_PER_SEC)) {
            self.collectionView.reloadData()
        }
    }
    

    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        flowLayout.invalidateLayout()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        flowLayout.itemSize = CGSize(width: collectionView.bounds.size.width * (originalItemSize?.width)!/(originalCollectionViewSize?.width)!, height: collectionView.bounds.size.height * (originalItemSize?.height)! / (originalCollectionViewSize?.height)!)
        print("=============")

        print(originalItemSize)
        print(flowLayout.itemSize)
        setInitialValues()
        // flowLayout.itemSize = CGSize(width: productCollectionView.bounds.size.width * (originalItemSize?.width)!/(originalCollectionViewSize?.width)!, height: productCollectionView.bounds.size.height * (originalItemSize?.height)! / (originalCollectionViewSize?.height)!)
        collectionView.setNeedsLayout()
        collectionView.layoutIfNeeded()
        collectionView.reloadData()
        
    }

    fileprivate func setInitialValues() {
        // Setting some nice defaults, ignore if you don't like them
//        coverFlowLayout.maxCoverDegree = 45
//        coverFlowLayout.coverDensity = 0.06
//        coverFlowLayout.minCoverScale = 0.69
//        coverFlowLayout.minCoverOpacity = 0.50
        flowLayout.maxCoverDegree = 45
        flowLayout.coverDensity = 0.06
        flowLayout.minCoverScale = 0.69
        flowLayout.minCoverOpacity = 0.5
    }

}
extension ProductListViewController : UICollectionViewDataSource
{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) 
        cell.contentView.backgroundColor = UIColor.blue
        print(cell.frame)
//        cell.frame.origin.y  = 0.0
        return cell
    }
    
}
extension ProductListViewController : UICollectionViewDelegateFlowLayout
{
//        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
//        {
//            return CGSize(width: 280 , height: 430)
//       }
}
extension ProductListViewController : UICollectionViewDelegate
{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}
