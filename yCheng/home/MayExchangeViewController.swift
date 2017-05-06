//
//  MayExchangeViewController.swift
//  yCheng
//
//  Created by De Peng Li on 2017/4/18.
//  Copyright © 2017年 De Peng Li. All rights reserved.
//

import UIKit

class MayExchangeViewController: UIViewController {

    @IBOutlet weak var exchangeView: UICollectionView!
    var myCanExchangeList = [AnyObject]()
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "可兑换的产品"
        
        exchangeView.delegate = self
        exchangeView.dataSource = self
        exchangeView.backgroundColor = UIColor.groupTableViewBackground
        // Do any additional setup after loading the view.

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
    }
    

}
extension MayExchangeViewController : UICollectionViewDelegate
{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let tmp = myCanExchangeList[indexPath.row] as! Dictionary<String,AnyObject>
        let detailView = self.storyboard?.instantiateViewController(withIdentifier: "detailView") as! DetailViewController
        detailView.titleName = tmp["product_name"] as? String
        detailView.productInfo = tmp
        navigationController?.pushViewController(detailView, animated: true)
    }
}
extension MayExchangeViewController : UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return myCanExchangeList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
//        exchangeCell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "exchangeCell", for: indexPath)
        
        let dic = myCanExchangeList[indexPath.row ] as! Dictionary<String,AnyObject>
        
        let imageView = cell.contentView.viewWithTag(1) as! UIImageView
        //                let tmpImageView = imageView as?
        let url = URL(string: dic["product_thumb_img"] as! String)
        imageView.yy_setImage(with: url, options: .allowBackgroundTask)
        
        
        let nameLab = cell.contentView.viewWithTag(2) as! UILabel
        let creditLab = cell.contentView.viewWithTag(3) as! UILabel
        nameLab.text = dic["product_name"] as? String
        creditLab.text = "积分:"+(dic["credit"]?.stringValue)!
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int
    {
        return 1
    }
    
    
}

extension MayExchangeViewController : UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.size.width - 16)/2 ,height: 200)
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize.zero
    }
    
}
