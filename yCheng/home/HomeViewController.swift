//
//  HomeViewController.swift
//  yCheng
//
//  Created by De Peng Li on 2017/3/21.
//  Copyright © 2017年 De Peng Li. All rights reserved.
//

import UIKit
import YYWebImage

class HomeViewController: UIViewController {
    lazy var appDelegate :AppDelegate = {
        return UIApplication.shared.delegate as! AppDelegate
    }()
    @IBOutlet weak var homeCollectionView: UICollectionView!
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    let headCollectionIdentifier = "headCell"
    let collectionHeaderIdentifier = "headerIdentifier"
    
    
    var headCollectionView : UICollectionView!
    var pageControl :UIPageControl = UIPageControl()
    var pageControl2 :UIPageControl = UIPageControl()
    var timer : Timer?
    var curIndex : Int = 0
    var Notifications = [AnyObject]()
    var MiddleImages = [AnyObject]()
    var ProductRecommend:[String:AnyObject] = [:]
    var ProductOthers = [AnyObject]()
    let middleCollectionIdentifier = "middleIdentifier"
    var middleCollectionView : UICollectionView!
    var token: String?
    var isLogin:Bool?
    @IBOutlet weak var float_Right_Btn: UIButton!
    
    @IBOutlet weak var topView: UIView!
    
    @IBOutlet weak var topTitle: UILabel!
    @IBAction func float_right_click(_ sender: Any) {
        //        notificationView
        
        let notificaitonView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "notificationView")
        if (navigationController?.navigationBar.isHidden)! {
            navigationController?.navigationBar.isHidden = false
            //            navigationController?.navigationBar.alpha = 0.0
        }
        navigationController?.pushViewController(notificaitonView, animated: true)
        
        //        let notificaitonView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ProductListView")
        //        navigationController?.pushViewController(notificaitonView, animated: true)
    }
    @IBAction func immedietelyBuy(_ sender: Any) {
        let signStoryBoard = UIStoryboard(name: "sign", bundle: nil)
        let rootViewControler = signStoryBoard.instantiateInitialViewController()
        appDelegate.window?.rootViewController = rootViewControler
    }
    
    func checkMoreProducts() -> Void {
        self.tabBarController?.selectedIndex = 1
    }
    
    func pushStore() -> Void {
        let totalView = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "totalStoreView")
        navigationController?.pushViewController(totalView, animated: true)
    }
    
    func pushNewGuide() {
        //        http://ujushou.com/webapp/info/xinshouzhina
        let webView = self.storyboard?.instantiateViewController(withIdentifier: "webView") as? webViewController
        webView?.url = "http://m.azhongzhi.com/client/info/xinshouzhina"
        navigationController?.pushViewController(webView!, animated: true)
        
    }
    
    func pushAboutYc()  {
        //        http://ujushou.com/webapp/info/guanyuyisheng
        let webView = self.storyboard?.instantiateViewController(withIdentifier: "webView") as? webViewController
        webView?.url = "http://m.azhongzhi.com/client/info/guanyuyisheng"
        navigationController?.pushViewController(webView!, animated: true)
    }
    
    func pushTicket() -> Void {
        let totalView = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ticketView")
        navigationController?.pushViewController(totalView, animated: true)
    }
    
    func pushInviteFriend() -> Void {
        let webView = self.storyboard?.instantiateViewController(withIdentifier: "webView") as? webViewController
        webView?.url = "http://m.azhongzhi.com/client/friend.htm"
        navigationController?.pushViewController(webView!, animated: true)
    }
    
    func immedieBuy() -> Void {
        //        let signStoryBoard = UIStoryboard(name: "sign", bundle: nil)
        //        let rootViewControler = signStoryBoard.instantiateViewController(withIdentifier: "realityVerifyNav")
        //        self.present(rootViewControler, animated: true) {
        //
        //        }
        let productDetailView = self.storyboard?.instantiateViewController(withIdentifier: "productDetailView") as! ProductDetailViewController
        productDetailView.productInfo =  self.ProductRecommend
        navigationController?.pushViewController(productDetailView, animated: true)
        
    }
    
    func pullRefresh() -> Void {
        print("refresh")
        sleep(2)
        homeCollectionView.reloadData()
        homeCollectionView.mj_header.endRefreshing()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
        
        
        
        let defaults = UserDefaults.standard
        
        token = defaults.value(forKey: T_Token) as! String?
        
        if (token != nil) && token != "" {
            isLogin = true
        }else{
            //            TODO: 修改
            isLogin = true
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "首页"
        view.backgroundColor = backColor
        topView.backgroundColor = mainColor
        topView.isHidden = true
        // Do any additional setup after loading the view.
        //        navigationController?.navigationBar.isHidden = true
        
        prepareData()
        
        //        select item
        let layout : UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.scrollDirection = UICollectionViewScrollDirection.horizontal
        layout.minimumLineSpacing = 0
        
        headCollectionView = UICollectionView(frame:CGRect(x: 0, y: 0, width: view.frame.size.width, height: 180), collectionViewLayout: layout)
        headCollectionView.tag = 1
        headCollectionView.delegate = self
        headCollectionView.dataSource = self
        headCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: headCollectionIdentifier)
        headCollectionView.isPagingEnabled = true
        headCollectionView.autoresizingMask = [UIViewAutoresizing.flexibleWidth , UIViewAutoresizing.flexibleHeight]
        headCollectionView.contentMode = UIViewContentMode.top
        headCollectionView.backgroundColor = UIColor.white
        headCollectionView.showsHorizontalScrollIndicator=false
        headCollectionView.showsVerticalScrollIndicator = false
        
        
        
        pageControl = UIPageControl(frame: CGRect(x: 0, y: 0, width: 100, height: 30))
        pageControl.currentPage = 0
        pageControl.numberOfPages = Notifications.count
        pageControl.center = CGPoint(x: view.frame.size.width/2, y: 160)
        
        
        pageControl2 = UIPageControl(frame: CGRect(x: 0, y: 0, width: 120, height: 30))
        pageControl2.currentPage = 0
        pageControl2.numberOfPages = MiddleImages.count
        pageControl2.center = CGPoint(x: view.frame.size.width/2, y: 80)
        
        // refresh control init
        
        //        let refresh = MJRefreshNormalHeader()
        //        refresh.setRefreshingTarget(self, refreshingAction: #selector(HomeViewController.pullRefresh))
        
        //      config collectionview
        homeCollectionView.delegate = self
        homeCollectionView.dataSource = self
        homeCollectionView.tag = 2
        homeCollectionView.backgroundColor = UIColor.white
        flowLayout.sectionInset = UIEdgeInsetsMake(2, 2, 2, 2)
        flowLayout.minimumLineSpacing = 1
        flowLayout.minimumInteritemSpacing = 1
        homeCollectionView.register( UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: collectionHeaderIdentifier)
        //        homeCollectionView.mj_header = refresh
        //        homeCollectionView.reloadData()
        
        view.insertSubview(float_Right_Btn, at: 999)
        //        float_Right_Btn.insertSubview(view, at: 1000)
        
        //        中间collectionview
        let midlayout : UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        midlayout.scrollDirection = UICollectionViewScrollDirection.horizontal
        midlayout.minimumLineSpacing = 0
        midlayout.minimumInteritemSpacing = 0
        middleCollectionView = UICollectionView(frame:CGRect(x: 2, y: 0, width: view.frame.size.width, height: 100), collectionViewLayout: midlayout)
        middleCollectionView.tag = 3
        middleCollectionView.delegate = self
        middleCollectionView.dataSource = self
        middleCollectionView.isPagingEnabled = true
        middleCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: middleCollectionIdentifier)
//        middleCollectionView.autoresizingMask = [UIViewAutoresizing.flexibleWidth , UIViewAutoresizing.flexibleHeight]
        middleCollectionView.contentMode = UIViewContentMode.center
        middleCollectionView.showsHorizontalScrollIndicator=false
        middleCollectionView.showsVerticalScrollIndicator = false
        middleCollectionView.backgroundColor = UIColor.white
        
        
        getHomeDataAndLoad()
    }
    deinit {
        homeCollectionView.dg_removePullToRefresh()
    }
    func addTimer(){
        let Timers = Timer(timeInterval: 2.0, target: self, selector: #selector(HomeViewController.timeScorll), userInfo: nil, repeats:true)
        RunLoop.main.add(Timers, forMode: RunLoopMode.commonModes)
        timer = Timers
    }
    
    func removeTimer(){
        if let _ = timer {
            timer!.invalidate()
        }
        
    }
    
    func timeScorll()
    {
        if Notifications.count>1 {
            let intX =  Int ( headCollectionView.contentOffset.x / view.frame.size.width)
            headCollectionView.scrollToItem(at: IndexPath(item: intX, section: 0), at: UICollectionViewScrollPosition.left, animated: true)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        //        if Notifications.count > 1 {
        //            let indexPath = NSIndexPath(item: 500*Notifications.count, section: 0)
        //            headCollectionView.scrollToItem(at: indexPath as IndexPath, at: UICollectionViewScrollPosition.centeredHorizontally, animated: false)
        //        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isHidden = false
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if (homeCollectionView != nil) {
            
            //            修改导航栏的alpha
            if homeCollectionView.contentOffset.y <= 0{
                //                navigationController?.navigationBar.alpha = 0.0
                //                navigationController?.navigationBar.isHidden = true
                topView.isHidden = true
            }
            
            if homeCollectionView.contentOffset.y >= 0 && homeCollectionView.contentOffset.y <= 30 {
                topView.isHidden = false
                topView.alpha = 0.0
                //                navigationController?.navigationBar.isHidden = false
                //                navigationController?.navigationBar.alpha = 0.0
            }
            if homeCollectionView.contentOffset.y > 30 {
                if(homeCollectionView.contentOffset.y >= 130){
                    topView.isHidden = false
                    topView.alpha = 1.0
                    navigationController?.navigationBar.alpha = 1.0
                }else{
                    //                    navigationController?.navigationBar.alpha = homeCollectionView.contentOffset.y/130
                    topView.isHidden = false
                    topView.alpha = homeCollectionView.contentOffset.y/130
                }
            }
        }
        
        if Notifications.count>0 {
            curIndex = 5000 % Notifications.count
            pageControl.currentPage = curIndex
            addTimer()
        }
        
    }
    
    
    // MARK: - Navigation
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        removeTimer()
    }
    func scrollToMiddlePosition() {
        
        let indexPath = IndexPath(item: 5000, section: 0)
        scrollWithIndexPath(indexPath, animated: false)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
    }
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        return false
    }
    func prepareData() -> Void {
        Notifications = appDelegate.SQLiteDb.getData(T_SQLITE_IMAGE, whereStr: "item = '1'")
        MiddleImages = appDelegate.SQLiteDb.getData(T_SQLITE_IMAGE, whereStr: "item = '2'")
        let productsRecomment = appDelegate.SQLiteDb.getData(T_SQLITE_PRODUCT, whereStr: " item = '1'")
        if productsRecomment.count > 0 {
            ProductRecommend = productsRecomment[0] as! [String : AnyObject]
        }
        
        ProductOthers = appDelegate.SQLiteDb.getData(T_SQLITE_PRODUCT, whereStr: " item = '2'")
    }
    
    func getHomeDataAndLoad() -> Void {
        //        第一列产品
        var dict = ConstantDict
        dict["item"] = "1"
        
        Http.Http_PostInfo(post: url_boot+url_home_image, parameters: dict) { (responseDic) in
            print(responseDic)
            if responseDic["result"] as! NSNumber == 0 {
                if let imagesArr = responseDic["body"] as? NSArray {
                    self.Notifications = [AnyObject]()
                    self.appDelegate.SQLiteDb.deleteData(T_SQLITE_IMAGE, whereStr: " item = 1")
                    for  t in imagesArr {
                        
                        if var tempDic = t as? Dictionary<String,AnyObject> {
                            tempDic["item"] = "1" as AnyObject
                            tempDic["type"] = tempDic["obj"]?["type"] as AnyObject
                            tempDic["objectId"] = tempDic["obj"]?["id"] as AnyObject
                            tempDic["info_url"] = tempDic["obj"]?["url"] as AnyObject
                            self.Notifications.append(tempDic as AnyObject)
                            
                            self.appDelegate.SQLiteDb.Insert(tablename: T_SQLITE_IMAGE, insertValue: tempDic)
                        }
                        
                    }
                    self.pageControl.numberOfPages = self.Notifications.count
                    //                    头部view 刷新数据
                    self.headCollectionView.reloadData()
                }
            }else{
                Drop.down(responseDic["msg"] as! String, state: .error)
            }
            
        }
        //        第二列产品
        dict["item"] = "2"
        Http.Http_PostInfo(post: url_boot+url_home_image, parameters: dict) { (responseDic) in
            print(responseDic)
            if responseDic["result"] as! NSNumber == 0 {
                if let imagesArr = responseDic["body"] as? NSArray {
                    self.MiddleImages = [AnyObject]()
                    self.appDelegate.SQLiteDb.deleteData(T_SQLITE_IMAGE, whereStr: " item = 2")
                    for  t in imagesArr {
                        
                        if var tempDic = t as? Dictionary<String,AnyObject> {
                            if let _ = tempDic["img_thumb_path"] {
                                tempDic["item"] = "2" as AnyObject
                                tempDic["id"] = NSUUID().uuidString as AnyObject
                                tempDic["type"] = tempDic["obj"]?["type"] as AnyObject
                                tempDic["objectId"] = tempDic["obj"]?["id"] as AnyObject
                                tempDic["info_url"] = tempDic["obj"]?["url"] as AnyObject
                                self.MiddleImages.append(tempDic as AnyObject)
                                self.pageControl2.numberOfPages = self.MiddleImages.count
                                self.appDelegate.SQLiteDb.Insert(tablename: T_SQLITE_IMAGE, insertValue: tempDic)
                            }
                        }
                        
                    }
                    //                    中部view 刷新数据
                    self.middleCollectionView.reloadData()
                }
            }else{
                Drop.down(responseDic["msg"] as! String, state: .error)
            }
        }
        //        推荐产品
        Http.Http_PostInfo(post: url_boot+url_product_recomment, parameters: ConstantDict) { (responseDic) in
            print(responseDic)
            if responseDic["result"] as! NSNumber == 0 {
                if var recommendProduct = responseDic["body"] as? Dictionary<String,AnyObject> {
                    self.ProductRecommend = recommendProduct
                    //                    self.appDelegate.SQLiteDb.deleteData(T_SQLITE_PRODUCT, whereStr: "")
                    recommendProduct["item"] = "1" as AnyObject
                    self.appDelegate.SQLiteDb.Insert(tablename: T_SQLITE_PRODUCT, insertValue: recommendProduct)
                   
                }
                self.homeCollectionView.reloadData()
            }else{
                Drop.down(responseDic["msg"] as! String, state: .error)
            }
        }
        
        //        其他产品
        Http.Http_PostInfo(post: url_boot+url_product_others, parameters: ConstantDict) { (responseDic) in
            print(responseDic)
            if responseDic["result"] as! NSNumber == 0 {
                if let imagesArr = responseDic["body"] as? NSArray {
                    self.ProductOthers = [AnyObject]()
                    self.appDelegate.SQLiteDb.deleteData(T_SQLITE_PRODUCT, whereStr: " item = 2")
                    for  t in imagesArr {
                        
                        if var tempDic = t as? Dictionary<String,AnyObject> {
                            tempDic["item"] = "2" as AnyObject
                            
                            self.ProductOthers.append(tempDic as AnyObject)
                            
                            self.appDelegate.SQLiteDb.Insert(tablename: T_SQLITE_PRODUCT, insertValue: tempDic)
                        }
                        
                    }
                    //                    全部view 刷新数据
                    self.homeCollectionView.reloadData()
                }
            }else{
                Drop.down(responseDic["msg"] as! String, state: .error)
            }
        }
        
    }
    
    
}

extension HomeViewController : UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    { //productDetailView
        print(indexPath)
        if collectionView.tag == 1 {
            let tmpDic = Notifications[indexPath.row%Notifications.count]
            if tmpDic["type"] as! String == "web" {
                let webView = self.storyboard?.instantiateViewController(withIdentifier: "webView") as? webViewController
                webView?.url = tmpDic["info_url"] as? String
                navigationController?.pushViewController(webView!, animated: true)
            }else if tmpDic["type"] as! String == "product" {
                let productDetailView = self.storyboard?.instantiateViewController(withIdentifier: "productDetailView") as! ProductDetailViewController
                productDetailView.productId = tmpDic["objectId"] as AnyObject
                navigationController?.pushViewController(productDetailView, animated: true)
            }else if tmpDic["type"] as! String == "register" {
                let signStoryBoard = UIStoryboard(name: "sign", bundle: nil)
                let registerView = signStoryBoard.instantiateViewController(withIdentifier: "registerView")
                navigationController?.pushViewController(registerView, animated: true)
            }else if tmpDic["type"] as! String == "shop" {
                let detailView = self.storyboard?.instantiateViewController(withIdentifier: "detailView") as! DetailViewController
                
                detailView.productId = tmpDic["objectId"] as AnyObject
                navigationController?.pushViewController(detailView, animated: true)
            }
        }
        
        
        if collectionView.tag == 2 {

                if indexPath.row >= 8 {
                    let productDetailView = self.storyboard?.instantiateViewController(withIdentifier: "productDetailView") as! ProductDetailViewController
                    productDetailView.productInfo =  ProductOthers[indexPath.row - 8] as? Dictionary<String,AnyObject>
                    navigationController?.pushViewController(productDetailView, animated: true)
                }

            if indexPath.section == 0 && indexPath.row==0 {
                pushStore()
            }
            if indexPath.section == 0 && indexPath.row==1 {
                pushTicket()
            }
            if indexPath.section == 0 && indexPath.row==2 {
                pushInviteFriend()
            }
            if indexPath.section == 0 && indexPath.row == 3{
                //                Drop.down("今日已签到", state: .success, duration: 1.0, action: {
                //
                //                })
                let webView = self.storyboard?.instantiateViewController(withIdentifier: "webView") as? webViewController
                webView?.url = "http://m.azhongzhi.com/client/sign.htm"
                navigationController?.pushViewController(webView!, animated: true)
            }
            
        }
        
        if collectionView.tag == 3 {
            let tmpDic = MiddleImages[indexPath.row]
            print(tmpDic)
            if tmpDic["type"] as! String == "web" {
                let webView = self.storyboard?.instantiateViewController(withIdentifier: "webView") as? webViewController
                webView?.url = tmpDic["info_url"] as? String
                navigationController?.pushViewController(webView!, animated: true)
            }else if tmpDic["type"] as! String == "product" {
                let productDetailView = self.storyboard?.instantiateViewController(withIdentifier: "productDetailView") as! ProductDetailViewController
                productDetailView.productId = tmpDic["objectId"] as AnyObject
                navigationController?.pushViewController(productDetailView, animated: true)
            }else if tmpDic["type"] as! String == "register" {
                let signStoryBoard = UIStoryboard(name: "sign", bundle: nil)
                let registerView = signStoryBoard.instantiateViewController(withIdentifier: "registerView")
                navigationController?.pushViewController(registerView, animated: true)
            }else if tmpDic["type"] as! String == "shop" {
                let detailView = self.storyboard?.instantiateViewController(withIdentifier: "detailView") as! DetailViewController
                
                detailView.productId = tmpDic["objectId"] as AnyObject
                navigationController?.pushViewController(detailView, animated: true)
            }
        }
        
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        if scrollView.tag == 1 {
            if Notifications.count > 1{
                let page = Int(scrollView.contentOffset.x / view.frame.size.width)
                print("page:\(page)")
                let count = Notifications.count
                curIndex = page % count
                pageControl.currentPage = curIndex
            }
        }
        if scrollView.tag == 3{
            if MiddleImages.count > 0 {
                let page = Int(scrollView.contentOffset.x / view.frame.size.width)
                pageControl2.currentPage = page
            }
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        removeTimer()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        addTimer()
    }
    
    
    func scrollWithIndexPath(_ indexPath: IndexPath, animated:Bool) {
        
        headCollectionView.scrollToItem(at: indexPath, at: UICollectionViewScrollPosition.centeredHorizontally, animated: animated)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView)
    {
        if scrollView.tag == 3 {
            return
        }
        if scrollView.tag == 1 {
            return
        }
        if scrollView.tag == 2 {
            //            修改导航栏的alpha
            if scrollView.contentOffset.y <= 0{
                //                navigationController?.navigationBar.alpha = 0.0
                //                navigationController?.navigationBar.isHidden = true
                topView.alpha = 0.0
                topView.isHidden = true
            }
            
            if scrollView.contentOffset.y >= 0 && scrollView.contentOffset.y <= 30 {
                //                navigationController?.navigationBar.isHidden = false
                //                navigationController?.navigationBar.alpha = 0.0
                topView.alpha = 0.0
                topView.isHidden = false
            }
            if scrollView.contentOffset.y > 30 {
                if(scrollView.contentOffset.y >= 130){
                    topView.alpha = 1.0
                    //                    navigationController?.navigationBar.alpha = 1.0
                }else{
                    //                    navigationController?.navigationBar.alpha = scrollView.contentOffset.y/130
                    topView.alpha = scrollView.contentOffset.y/130
                }
            }
        }
    }
    
}



extension HomeViewController : UICollectionViewDataSource
{
    func numberOfSections(in collectionView: UICollectionView) -> Int
    {
        if collectionView.tag == 2{
            if isLogin! {
                return 1
            }else{
                return 1
            }
        }
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        if(collectionView.tag==1){
            return 10000
        }
        if(collectionView.tag==2){
            if section == 0 {
                if isLogin! {
                    return 8 + ProductOthers.count
                }else{
                    return 1
                }
            }
            //            if section == 1 {
            //                return 3 + 4
            //            }
            
        }
        if(collectionView.tag==3){
            return MiddleImages.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if collectionView.tag == 2{
            switch kind {
            case UICollectionElementKindSectionHeader:
                
                if indexPath.section == 0 {
                    let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: collectionHeaderIdentifier, for: indexPath)
                    headerView.contentMode = UIViewContentMode.top
                    headerView.backgroundColor = UIColor.groupTableViewBackground
                    headerView.addSubview(headCollectionView)
                    headerView.addSubview(pageControl)
                    headerView.tag = 10000
                    return headerView
                }
                
                
            default:
                fatalError("Unexpected element kind")
            }
        }
        
        fatalError("Unexpected element kind")
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        
        
        if collectionView.tag == 1 {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: headCollectionIdentifier, for: indexPath)
            
            // indexPath.row % Notifications.count
            if Notifications.count>0 {
                if let tmpdic = Notifications[indexPath.row % Notifications.count] as? Dictionary<String,AnyObject> {
                    
                    //                tmpdic["img_thumb_path"] as String
                    let headImageView = YYAnimatedImageView()
                    
                    let image_url = NSURL(string: tmpdic["img_thumb_path"] as! String)! as URL
                    headImageView.setImageWith(image_url, placeholderImage: UIImage(named: "bannerpic"))
                    headImageView.frame = cell.contentView.bounds
                    cell.contentView.addSubview(headImageView)
                }
            }
            return cell
        }else if collectionView.tag == 3{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: middleCollectionIdentifier, for: indexPath)
            for subView in cell.contentView.subviews{
                subView.removeFromSuperview()
            }
            
            if MiddleImages.count>0 {
                if let tmpdic = MiddleImages[indexPath.row] as? Dictionary<String,AnyObject> {
                    
                    //                tmpdic["img_thumb_path"] as String
                    let headImageView = YYAnimatedImageView()
                    
                    let image_url = NSURL(string: tmpdic["img_thumb_path"] as! String)! as URL
                    headImageView.setImageWith(image_url, placeholderImage: UIImage(named: "bannerpic"))
                    headImageView.frame = cell.contentView.bounds
                    headImageView.layer.cornerRadius = 5.0
                    headImageView.layer.masksToBounds = true
                    cell.contentView.addSubview(headImageView)
                }
            }
            return cell
        }else{
            
            switch indexPath.row {
            case 0,1,2:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "topBtnCell", for: indexPath)
                let btn = cell.contentView.viewWithTag(1) as! JXButton
                btn.isUserInteractionEnabled = false
                switch indexPath.row {
                case 0:
                    
                    btn.setImage(UIImage(named: "countStore"), for: .normal)
                    btn.setTitle("积分商城", for: .normal)
                //                            btn.addTarget(self, action: #selector(HomeViewController.pushStore), for: .touchUpInside)
                case 1:
                    btn.setImage(UIImage(named: "discountTicket"), for: .normal)
                    btn.setTitle("优惠券", for: .normal)
                //                            btn.addTarget(self, action: #selector(HomeViewController.pushTicket), for: .touchUpInside)
                default:
                    btn.setImage(UIImage(named: "inviteFriend"), for: .normal)
                    btn.setTitle("邀请好友", for: .normal)
                    
                    //                            btn.addTarget(self, action: #selector(HomeViewController.pushInviteFriend), for: .touchUpInside)
                }
                
                
                return cell
            case 4:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "newGuideCell", for: indexPath)
                let numLabel = cell.contentView.viewWithTag(1) as! UILabel
                
                if let profit =  ProductRecommend["profit"] as? Float  {//profit
                    let numstr = "\(String(format: "%.2f", profit))%"
                    let att = NSMutableAttributedString(string: numstr)
                    
                    att.addAttributes([NSFontAttributeName:UIFont(name: "Arial", size: 30.0) ?? ""], range: NSMakeRange(0, numstr.characters.count-1))
                    
                    att.addAttributes([NSFontAttributeName:UIFont(name: "Arial", size: 15.0) ?? ""], range: NSMakeRange(numstr.characters.count-1, 1))
                    numLabel.attributedText = att
                }
                
                let nameBtn = cell.contentView.viewWithTag(10) as! UIButton
                if let productName =  ProductRecommend["product_name"] as? String  {//profit
                    
                    nameBtn.setTitle(productName, for: .normal)
                }
                
                let dayLabel = cell.contentView.viewWithTag(11) as! UILabel
                if let productday =  ProductRecommend["day_no"] as? String  {//profit
                    dayLabel.text = "定期\(productday)天"
                }
                
                let moreBtn = cell.contentView.viewWithTag(22) as! UIButton
                moreBtn.addTarget(self, action: #selector(HomeViewController.checkMoreProducts), for: .touchUpInside)
                
                let buyBtn = cell.contentView.viewWithTag(8) as! UIButton
                buyBtn.addTarget(self, action: #selector(HomeViewController.immedieBuy), for: .touchUpInside)
                buyBtn.layer.cornerRadius = 5.0
                buyBtn.backgroundColor = btnColor
                
                return cell
            case 3:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "signCell", for: indexPath)
                let signLabel = cell.contentView.viewWithTag(1) as! UILabel
                
                let defaults = UserDefaults.standard
                let hadsign = defaults.bool(forKey: T_Today_Sign)
                if hadsign {
                    let signString = "今日已签到"
                    signLabel.text = signString
                    
                }else{
                    let signString = "每日签到领取体验金,去签到"
                    let att = NSMutableAttributedString(string: signString)
                    
                    att.addAttributes([NSForegroundColorAttributeName:UIColor.darkGray], range: NSMakeRange(0, signString.characters.count-3))
                    
                    att.addAttributes([NSForegroundColorAttributeName:signColor], range: NSMakeRange(signString.characters.count-3, 3))
                    signLabel.attributedText = att
                    
                }
                
                return cell
                
                
            case 5:
                
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "advertCell", for: indexPath)
                
                cell.contentView.contentMode = UIViewContentMode.top
                cell.contentView.backgroundColor = UIColor.groupTableViewBackground
                cell.contentView.addSubview(middleCollectionView)
                cell.contentView.addSubview(pageControl2)
                
                return cell
            case 6:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "bottomBtnCell", for: indexPath)
                
                let btn = cell.contentView.viewWithTag(1) as! UIButton
                
                btn.setTitle("新手指南", for: .normal)
                btn.addTarget(self, action: #selector(HomeViewController.pushNewGuide), for: .touchUpInside)
//                cell.contentView.backgroundColor = UIColor.red
                return cell
            case 7:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "bottomBtnCell", for: indexPath)
                
                let btn = cell.contentView.viewWithTag(1) as! UIButton
                btn.setTitle("关于乙晟", for: .normal)
                btn.addTarget(self, action: #selector(HomeViewController.pushAboutYc), for: .touchUpInside)
//                cell.contentView.backgroundColor = UIColor.red
                return cell
            default:
                var cell:UICollectionViewCell?
                if indexPath.row == 8 {
                    cell = collectionView.dequeueReusableCell(withReuseIdentifier: "productCell", for: indexPath) as UICollectionViewCell
                    //                        "day_no": 11,
                    //                        "id": 8,
                    //                        "lowest": 11,
                    //                        "product_name": "乙晟短期年化",
                    //                        "profit": 11
                    
                    
                    let profitlAB = cell?.contentView.viewWithTag(1) as! UILabel
                    let nameLab = cell?.contentView.viewWithTag(2) as! UILabel
                    let daylAB = cell?.contentView.viewWithTag(3) as! UILabel
                    let leastLab = cell?.contentView.viewWithTag(5) as! UILabel
                    if let profitdic = ProductOthers[indexPath.row - 8] as? Dictionary<String,AnyObject>{
                        profitlAB.text = "\(profitdic["product_name"] ?? "" as AnyObject)"
                        
                        if let profit = profitdic["profit"] as? Float{
                            
                            let prostring = "\(String(format: "%.2f", profit))%"
                            
                            
                            let att = NSMutableAttributedString(string: prostring)
                            att.addAttributes([NSForegroundColorAttributeName:UIColor.red ], range: NSMakeRange(0, prostring.characters.count-1))
                            
                            att.addAttributes([NSForegroundColorAttributeName:UIColor.darkGray ], range: NSMakeRange(prostring.characters.count-1, 1))
                            
                            att.addAttributes([NSFontAttributeName:UIFont(name: "Arial", size: 30.0) ?? ""], range: NSMakeRange(0, prostring.characters.count-1))
                            
                            att.addAttributes([NSFontAttributeName:UIFont(name: "Arial", size: 15.0) ?? ""], range: NSMakeRange(prostring.characters.count-1, 1))
                            nameLab.attributedText = att
                            
                        }
                        daylAB.text = "期限\(profitdic["day_no"] ?? "" as AnyObject)天"
                        leastLab.text = "\(profitdic["lowest"] ?? "" as AnyObject)元起购"
                    }
                }else{
                    cell = collectionView.dequeueReusableCell(withReuseIdentifier: "productCell2", for: indexPath) as UICollectionViewCell
                    let profitlAB = cell?.contentView.viewWithTag(1) as! UILabel
                    let nameLab = cell?.contentView.viewWithTag(2) as! UILabel
                    let daylAB = cell?.contentView.viewWithTag(3) as! UILabel
                    let leastLab = cell?.contentView.viewWithTag(5) as! UILabel
                    print(indexPath.row - 7)
                    if let profitdic = ProductOthers[indexPath.row - 8] as? Dictionary<String,AnyObject>{
                        profitlAB.text = "\(profitdic["product_name"] ?? "" as AnyObject)"
                        if let profit = profitdic["profit"] as? Float{
                            
                            let prostring = "\(String(format: "%.2f", profit))%"
                            
                            
                            let att = NSMutableAttributedString(string: prostring)
                            att.addAttributes([NSForegroundColorAttributeName:UIColor.red ], range: NSMakeRange(0, prostring.characters.count-1))
                            
                            att.addAttributes([NSForegroundColorAttributeName:UIColor.darkGray ], range: NSMakeRange(prostring.characters.count-1, 1))
                            
                            att.addAttributes([NSFontAttributeName:UIFont(name: "Arial", size: 30.0) ?? ""], range: NSMakeRange(0, prostring.characters.count-1))
                            
                            att.addAttributes([NSFontAttributeName:UIFont(name: "Arial", size: 15.0) ?? ""], range: NSMakeRange(prostring.characters.count-1, 1))
                            nameLab.attributedText = att
                            
                        }
                        daylAB.text = "期限\(profitdic["day_no"] ?? "" as AnyObject)天"
                        leastLab.text = "\(profitdic["lowest"] ?? "" as AnyObject)元起购"
                    }
                }
                return cell!
            }
        }
    }
}


extension HomeViewController : UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView.tag == 1 {
            return CGSize(width: view.frame.size.width ,height: 180)
            
        }else if collectionView.tag == 3{
            return CGSize(width: view.frame.size.width ,height: 100)
        }else{
           
                if indexPath.row>=0 && indexPath.row<3{
                    return CGSize(width: (view.bounds.size.width-8)/3  ,height: 80)
                    
                }else if indexPath.row == 3 {
                    return CGSize(width: view.frame.size.width-4 ,height: 60)
                }else if indexPath.row == 4 {
                    return CGSize(width: view.frame.size.width-4 ,height: 250)
                }
                else if indexPath.row == 5{
                    return CGSize(width: view.frame.size.width - 4 ,height: 110)
                }
                else if (indexPath.row >= 6 && indexPath.row <= 7){
                    return CGSize(width: (view.frame.size.width-4)/2 - 10 ,height: 75)
                }else{
                    if indexPath.row == 8 {
                        return CGSize(width: view.frame.size.width-4 ,height: 100)
                    }
                    return CGSize(width: collectionView.frame.size.width-4 ,height: 90)
                }

            
        }
        return CGSize.zero
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if collectionView.tag == 1 {
            return CGSize.zero
        }
        if collectionView.tag == 3 {
            return CGSize.zero
        }
        if collectionView.tag == 2 {
            if section == 0 {
                return CGSize(width: view.frame.size.width ,height: 190)
            }
            //            if section == 1 {
            //                return CGSize(width: view.frame.size.width ,height: 110)
            //            }
        }
        return CGSize.zero
    }
    
}
