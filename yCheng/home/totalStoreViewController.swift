//
//  totalStoreViewController.swift
//  yCheng
//
//  Created by De Peng Li on 2017/3/31.
//  Copyright © 2017年 De Peng Li. All rights reserved.
//

import UIKit

class totalStoreViewController: UIViewController {
    lazy var appDelegate :AppDelegate = {
        return UIApplication.shared.delegate as! AppDelegate
    }()
    @IBOutlet weak var flowlayout: UICollectionViewFlowLayout!
    @IBOutlet weak var collectionView: UICollectionView!
    var myCredit : String?
    var pushRecord = "0"
    var showProducts = [AnyObject]()
    var shopImages = [AnyObject]()
    var pageSize : NSNumber?
    var count : NSNumber?
    var currpage = 1
    var allPage = 1
//    var myCreditList = [AnyObject]()
    var myCanExchangeList = [AnyObject]()
    let middleCollectionIdentifier = "middleIdentifier"
    var middleCollectionView : UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "积分商城"
        
        let refresh = MJRefreshNormalHeader()
        refresh.setRefreshingTarget(self, refreshingAction: #selector(totalStoreViewController.pullRefresh))
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = litColor
        collectionView.tag = 1
        collectionView.mj_header = refresh
        flowlayout.sectionInset = UIEdgeInsetsMake(2, 2, 2, 2)
        flowlayout.minimumLineSpacing = 1
        flowlayout.minimumInteritemSpacing = 1
        
        
        
        
        //        中间collectionview
        let midlayout : UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        midlayout.scrollDirection = UICollectionViewScrollDirection.horizontal
        midlayout.minimumLineSpacing = 2
        midlayout.minimumInteritemSpacing = 2
        middleCollectionView = UICollectionView(frame:CGRect(x: 2, y: 2, width: view.frame.size.width-4, height: 96), collectionViewLayout: midlayout)
        middleCollectionView.tag = 2
        middleCollectionView.delegate = self
        middleCollectionView.dataSource = self
        middleCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: middleCollectionIdentifier)
        middleCollectionView.autoresizingMask = [UIViewAutoresizing.flexibleWidth , UIViewAutoresizing.flexibleHeight]
        middleCollectionView.contentMode = UIViewContentMode.center
        middleCollectionView.showsHorizontalScrollIndicator=false
        middleCollectionView.showsVerticalScrollIndicator = false
        middleCollectionView.backgroundColor = UIColor.white
        
        
        // Do any additional setup after loading the view.
        getDataAndLoad()
    }
    
    func pullRefresh() {
        getStoreinfo()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if pushRecord == "1" {
            pushRecord = "0"
            pushExchangeRecords()
        }
    }
    
    func getStoreinfo() {
        //        商城列表
        var dictCredit = ConstantDict
        dictCredit["page"] = currpage
        Http.Http_PostInfo(post: url_boot+url_shop_products, parameters: dictCredit) { (responseDic) in
            print(responseDic)
            self.collectionView.mj_header.endRefreshing()
            if responseDic["result"] as! NSNumber == 0 {
                if let tmpDic = responseDic["body"] as? Dictionary<String,AnyObject> {
                    self.allPage = tmpDic["pageSize"] as! Int
                    
                    self.currpage = self.currpage + 1
                    
                    for o in (tmpDic["list"] as! NSArray) as [AnyObject]{
                        self.showProducts.append(o)
                    }
                  
                    self.collectionView.reloadData()
                }
            }else{
                Drop.down(responseDic["msg"] as! String, state: .error)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func pushRecords() -> Void {
        let RecordsView = self.storyboard?.instantiateViewController(withIdentifier: "CreditRecords") as! CreditRecordsViewController
        RecordsView.myCredit = myCredit
//        RecordsView.myCreditList = self.myCreditList
        navigationController?.pushViewController(RecordsView, animated: true)
    }
    
    func pushExchangeRecords() -> Void {
        let exchangeView = self.storyboard?.instantiateViewController(withIdentifier: "ExchangeView") as! ExchangeRecordsViewController
        
        navigationController?.pushViewController(exchangeView, animated: true)
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    func prepareData(){
        let defaults = UserDefaults.standard
        if let  _ = defaults.string(forKey: T_Credit){
            myCredit = defaults.string(forKey: T_Credit)
        }
        
    }
    func getDataAndLoad() -> Void {
        Http.Http_PostInfo(post: url_boot+url_my_credit, parameters: ConstantDict) { (responseDic) in
            print(responseDic)
            if responseDic["result"] as! NSNumber == 0 {
                if let tmpDic = responseDic["body"] as? Dictionary<String,AnyObject> {
                    //                    "isLogin": 1,//是否登录（1为已登录）
                    //                    "credit": 20//当前登录人积分
                    let defaults = UserDefaults.standard
                    defaults.setValue(tmpDic["credit"], forKey: T_Credit)
                    defaults.synchronize()
                    //                    中部view 刷新数据
                    self.myCredit = tmpDic["credit"]?.stringValue
                    self.collectionView.reloadData()
                }
            }else{
                Drop.down(responseDic["msg"] as! String, state: .error)
            }
        }
        //        商城列表
        var dictCredit = ConstantDict
        dictCredit["page"] = currpage
        Http.Http_PostInfo(post: url_boot+url_shop_products, parameters: dictCredit) { (responseDic) in
            print(responseDic)
            if responseDic["result"] as! NSNumber == 0 {
                if let tmpDic = responseDic["body"] as? Dictionary<String,AnyObject> {
               
                    self.allPage = tmpDic["pageSize"] as! Int
                    
                    self.currpage = self.currpage + 1

                    
                    self.pageSize =  tmpDic["pageSize"] as? NSNumber
                    self.count = tmpDic["count"] as? NSNumber
                    self.showProducts = (tmpDic["list"] as! NSArray) as [AnyObject]
                   
                    
                    self.collectionView.reloadData()
                }
            }else{
                Drop.down(responseDic["msg"] as! String, state: .error)
            }
        }
        //       积分商城 轮播图片
        
        Http.Http_PostInfo(post: url_boot+url_shop_images, parameters: ConstantDict) { (responseDic) in
            print(responseDic)
            if responseDic["result"] as! NSNumber == 0 {
                if let tmpArr = responseDic["body"] as? NSArray {
//                    self.appDelegate.SQLiteDb.deleteData(T_SQLITE_SHOP_IMAGELIST, whereStr: "")
                    
                    for t in tmpArr
                    {
                        if let tmp = t as? Dictionary<String,AnyObject>{
                            if let _ = tmp["img_thumb_path"] as? String{
                                self.shopImages.append(t as AnyObject)
//                                if var tmp = t as? Dictionary<String,AnyObject>{
//                                    tmp["id"] = NSUUID().uuidString as AnyObject
//                                    self.appDelegate.SQLiteDb.Insert(tablename: T_SQLITE_SHOP_IMAGELIST, insertValue: tmp )
//                                }
                            }
                        }
                        
                    }
                    
                    self.middleCollectionView.reloadData()
                }
            }else{
                Drop.down(responseDic["msg"] as! String, state: .error)
            }
        }
        
        
       
        
        
//     我可以兑换的产品列表
        var exchangeDict = ConstantDict
        exchangeDict["page"] = "1"
        Http.Http_PostInfo(post: url_boot+url_my_allow_exchange_list, parameters: exchangeDict) { (responseDic) in
            print(responseDic)
            if responseDic["result"] as! NSNumber == 0 {
                if let tmpDic = responseDic["body"] as? Dictionary<String,AnyObject> {
                    if  tmpDic["isLogin"] as! NSNumber == 0 {
                        // 登录
                    }else{
                        //                        "count": 3,//总条数
                        //                        "pageSize": 1,//总页数
                        //                        "list": [
                        self.appDelegate.SQLiteDb.deleteData(T_SQLITE_EX_SHOP_PRODUCTS, whereStr: "")
                        if let listCredit = tmpDic["list"] as? NSArray{
                            self.myCanExchangeList = listCredit as [AnyObject]
                            for t in self.myCanExchangeList{
                                
                                let tmp = t as! Dictionary<String,AnyObject>
                                
                                self.appDelegate.SQLiteDb.Insert(tablename: T_SQLITE_EX_SHOP_PRODUCTS, insertValue: tmp)
                            }
                        }
                        
                    }
                    
                }
            }else{
                Drop.down(responseDic["msg"] as! String, state: .error)
            }
        }

    }
    
    func pushExchangeView() -> Void {
        //        MyExchangeView
        let ExchangeView = self.storyboard?.instantiateViewController(withIdentifier: "MyExchangeView") as! MayExchangeViewController
        ExchangeView.myCanExchangeList = self.myCanExchangeList
        navigationController?.pushViewController(ExchangeView, animated: true)
    }
    func getTotalCredit() -> Void {
//        http://www.ujushou.com/webapp/info/huoqijifen
        let webView = self.storyboard?.instantiateViewController(withIdentifier: "webView") as? webViewController
        webView?.url = "http://www.ujushou.com/webapp/info/huoqijifen"
        navigationController?.pushViewController(webView!, animated: true)
    }
}
extension totalStoreViewController : UICollectionViewDelegate
{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView.tag == 1 {
            if indexPath.row >= 3  {
                let tmp = showProducts[indexPath.row - 3] as! Dictionary<String,AnyObject>
                let detailView = self.storyboard?.instantiateViewController(withIdentifier: "detailView") as! DetailViewController
                detailView.titleName = tmp["product_name"] as? String
                detailView.productInfo = tmp
                navigationController?.pushViewController(detailView, animated: true)
            }
        }
        else {
            if let imageDic = shopImages[indexPath.row] as? Dictionary<String,AnyObject>{
                let obj = imageDic["obj"] as? Dictionary<String,AnyObject>
                if obj?["type"] as! String == "web" {
                    let webView = self.storyboard?.instantiateViewController(withIdentifier: "webView") as? webViewController
                    webView?.url = obj?["info_url"] as? String
                    navigationController?.pushViewController(webView!, animated: true)
                }else if obj?["type"] as! String == "product" {
                    let productDetailView = self.storyboard?.instantiateViewController(withIdentifier: "productDetailView") as! ProductDetailViewController
                    productDetailView.productId = obj?["id"] as AnyObject
                    navigationController?.pushViewController(productDetailView, animated: true)
                }else if obj?["type"] as! String == "register" {
                    let signStoryBoard = UIStoryboard(name: "sign", bundle: nil)
                    let registerView = signStoryBoard.instantiateViewController(withIdentifier: "registerView")
                    navigationController?.pushViewController(registerView, animated: true)
                }else if obj?["type"] as! String == "shop" {
                    let detailView = self.storyboard?.instantiateViewController(withIdentifier: "detailView") as! DetailViewController
                    
                    detailView.productId = obj?["id"] as AnyObject
                    navigationController?.pushViewController(detailView, animated: true)
                }
            }
        }
    }
}
extension totalStoreViewController : UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        if collectionView.tag == 1 {
            return 3 + showProducts.count
        }else{
            return shopImages.count
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        if collectionView.tag == 1 {
            if indexPath.row ==  0 {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "topCell", for: indexPath)
                let backView = cell.contentView.viewWithTag(1)
                backView?.layer.cornerRadius = 5.0
                backView?.layer.borderColor = litColor.cgColor
                backView?.layer.borderWidth = 1.0
                
                let totalLabel = cell.contentView.viewWithTag(2) as! UILabel
                let totalBtn = cell.contentView.viewWithTag(3) as! UIButton
                
                var totalString = "积分:0"
                if myCredit != nil  {
                    totalString = "积分:"+myCredit!
                }
                
                totalLabel.isUserInteractionEnabled = true
                let tap = UITapGestureRecognizer(target: self, action: #selector(totalStoreViewController.pushRecords))
                totalLabel.addGestureRecognizer(tap)
                let att = NSMutableAttributedString(string: totalString)
                
                att.addAttributes([NSForegroundColorAttributeName:UIColor.darkGray], range: NSMakeRange(0, 3))
                
                att.addAttributes([NSForegroundColorAttributeName:signColor], range: NSMakeRange(3,totalString.characters.count-3))
                totalLabel.attributedText = att
                
                totalBtn.addTarget(self, action: #selector(totalStoreViewController.pushExchangeRecords), for: .touchUpInside)
                
                
                return cell
            }else if indexPath.row == 1{
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath)
                
                middleCollectionView.frame.size.width = collectionView.bounds.size.width - 4
                cell.contentView.addSubview(middleCollectionView)
                
                return cell
            }else if indexPath.row == 2{
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "btnCell", for: indexPath)
                let btn1 = cell.contentView.viewWithTag(1) as! UIButton
                let btn2 = cell.contentView.viewWithTag(2) as! UIButton
                btn1.addTarget(self, action: #selector(totalStoreViewController.pushExchangeView), for: .touchUpInside)
                btn2.addTarget(self, action: #selector(totalStoreViewController.getTotalCredit), for: .touchUpInside)
                return cell
            }else{
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "merchaniseCell", for: indexPath)
                
                let dic = showProducts[indexPath.row - 3] as! Dictionary<String,AnyObject>
                
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
            
        }
        else  {   ///    tag == 2 collectionView
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: middleCollectionIdentifier, for: indexPath)
            if let imageDic = shopImages[indexPath.row] as? Dictionary<String,AnyObject>{
                let tmpFrame = cell.contentView.bounds
                let imageView = UIImageView(frame: tmpFrame)
                let imageUrl = URL(string: imageDic["img_thumb_path"] as! String)
                imageView.setImageWith(imageUrl!, placeholderImage: UIImage(named: "bannerpic"))
                cell.contentView.addSubview(imageView)
            }
            
           
            return cell
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int
    {
        return 1
    }
    
    
}

extension totalStoreViewController : UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView.tag == 1 {
            if indexPath.row == 0 {
                return CGSize(width: collectionView.frame.size.width - 4 ,height: 80)
                
            }else if indexPath.row == 1{
                return CGSize(width: collectionView.frame.size.width - 4 ,height: 100)
            }else if indexPath.row == 2 {
                return CGSize(width: collectionView.frame.size.width - 4 ,height: 60)
            }else{
                return CGSize(width: (collectionView.frame.size.width - 12)/2 ,height: 200)
            }
        }else{
            return CGSize(width: (view.frame.size.width - 4) ,height: 96)
        }
        
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize.zero
    }
    
}
