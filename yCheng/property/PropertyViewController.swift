//
//  PropertyViewController.swift
//  yCheng
//
//  Created by De Peng Li on 2017/3/21.
//  Copyright © 2017年 De Peng Li. All rights reserved.
//

import UIKit

class PropertyViewController: UIViewController {
    lazy var appDelegate :AppDelegate = {
        return UIApplication.shared.delegate as! AppDelegate
    }()
    
    @IBOutlet weak var propertyTableView: UITableView!
    
    @IBOutlet weak var rightItem: UIBarButtonItem!
    var myasset : Dictionary<String,AnyObject>?
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var regesterBtn: UIButton!
    var popupController : UIViewController!
    var syBtn : UIButton?
    @IBAction func regesterClick(_ sender: Any) {
        let signStoryBoard = UIStoryboard(name: "sign", bundle: nil)
        let rootViewControler = signStoryBoard.instantiateInitialViewController()
        appDelegate.window?.rootViewController = rootViewControler

    }
    
    @IBAction func loginClick(_ sender: Any) {
        let signStoryBoard = UIStoryboard(name: "sign", bundle: nil)
        let rootViewControler = signStoryBoard.instantiateInitialViewController()
        appDelegate.window?.rootViewController = rootViewControler

    }
    func pullRefresh() -> Void {
        print("refresh")
        getDataAndLoad(endLoad:{
            self.propertyTableView.mj_header.endRefreshing()
        })
        
    }
    
    
    func pushRecordClick() -> Void {
        
    }
    
    func syClick()  {
        let earnView = self.storyboard?.instantiateViewController(withIdentifier: "EarningView") as? EarningRecordViewController
        navigationController?.pushViewController(earnView!, animated: true)
    }
    
    func rechargeClick() -> Void {
        let storeView = self.storyboard?.instantiateViewController(withIdentifier: "stroeMoneyView") as? StroeMoneyViewController
        storeView?.yeNum = self.myasset?["fund"] as? Float
        navigationController?.pushViewController(storeView!, animated: true)
    }
    
    func cashMoneyClick()  {
        let cashView = self.storyboard?.instantiateViewController(withIdentifier: "cashView") as? CashViewController
        cashView?.mayCash = self.myasset?["cash"] as? Float
        navigationController?.pushViewController(cashView!, animated: true)
    }
    
    func changeTab()  {
        self.tabBarController?.selectedIndex = 1
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "资产"
        view.backgroundColor = backColor

        
        
//        let defaults = UserDefaults.standard
//        if let tmpAsset = defaults.dictionary(forKey: T_My_Asset) as Dictionary<String, AnyObject>?{
//            myasset = tmpAsset
//        }
        
//        navigationController?.navigationBar.isTranslucent = false
//        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.barTintColor = mainColor
        
        // refresh control init
        
        let refresh = MJRefreshNormalHeader()
        refresh.setRefreshingTarget(self, refreshingAction: #selector(PropertyViewController.pullRefresh))
        
//        navigationController?.navigationBar.shadowImage = UIImage()
        propertyTableView.delegate = self
        propertyTableView.dataSource = self
        propertyTableView.separatorColor = UIColor.clear
        propertyTableView.backgroundColor = litColor
        propertyTableView.isScrollEnabled = false
//        
//        if getisLogin() {
//            let footerview = UIView(frame: CGRect(x: 0, y: 0, width: propertyTableView.bounds.width, height: 200.0))
//            footerview.backgroundColor = litColor
//            propertyTableView.tableFooterView = footerview
//            
//            let loadingView = DGElasticPullToRefreshLoadingViewCircle()
//            loadingView.tintColor = UIColor(red: 78/255.0, green: 221/255.0, blue: 200/255.0, alpha: 1.0)
//            propertyTableView.dg_addPullToRefreshWithActionHandler({ [weak self] () -> Void in
//                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(1.5 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: {
//                    self?.propertyTableView.dg_stopLoading()
//                })
//                }, loadingView: loadingView)
//            propertyTableView.dg_setPullToRefreshFillColor(mainColor)
//            propertyTableView.dg_setPullToRefreshBackgroundColor(UIColor.red)
//            
//        }
        
        
        let presentController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "popupController")
        let pop = CCMPopupTransitioning.sharedInstance()
        pop?.destinationBounds = CGRect(x: 0, y: 0, width: 300, height: 400)
        pop?.presentedController = presentController
        pop?.presentingController = self
        self.popupController = presentController
//        self.present(presentController, animated: true) {
//            
//        }
 
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getDataAndLoad(endLoad:{
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
//    deinit {
//        propertyTableView.dg_removePullToRefresh()
//    }
    
    func getDataAndLoad(endLoad:@escaping ()->Void){
        let assetDic = ConstantDict
        
        Http.Http_PostInfo(post: url_boot + url_my_asset, parameters: assetDic) { (responseDic) in
            print(responseDic)
            if responseDic["result"] as! NSNumber == 0 {
                if let tmpDic = responseDic["body"] as? Dictionary<String,AnyObject> {
                    if tmpDic["isLogin"] as! NSNumber == 1 {
                        self.myasset = tmpDic["asset"] as? Dictionary<String, AnyObject>
                        let defaults = UserDefaults.standard
                        defaults.set(self.myasset, forKey: T_My_Asset)
                        defaults.synchronize()
                        
                        self.propertyTableView.reloadData()
                        endLoad()
                    }else{
                        ////  未登陆
                        let signStoryBoard = UIStoryboard(name: "sign", bundle: nil)
                        let rootViewControler = signStoryBoard.instantiateInitialViewController()
                        self.appDelegate.window?.rootViewController = rootViewControler
                    }
                }
            }else{
                Drop.down(responseDic["msg"] as! String, state: .error)
            }
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
    }
}


extension PropertyViewController : UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
//        switch section {
//        case 0:
//            return 1
//        case 1:
//            return 1
//        default:
//            return 1
//        }
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
//        if indexPath.section == 0 {
        
//            if getisLogin() {
                let cell = tableView.dequeueReusableCell(withIdentifier: "topCell", for: indexPath)
                
                let backView = cell.contentView.viewWithTag(100)
                backView?.layer.cornerRadius = 5.0
                backView?.layer.borderColor = litColor.cgColor
                backView?.layer.borderWidth = 1.0
                
                syBtn = cell.contentView.viewWithTag(101) as? UIButton
        syBtn?.addTarget(self, action: #selector(PropertyViewController.syClick), for: .touchUpInside)
        
                let allProperty = cell.contentView.viewWithTag(1) as! UILabel
                let saveLabel = cell.contentView.viewWithTag(2) as! UILabel
                let cashLabel = cell.contentView.viewWithTag(3) as! UILabel
                if (self.myasset != nil) {
                    
                    
                    allProperty.text = "\(self.myasset?["fund"] ?? "" as AnyObject)"
                    saveLabel.text = "\(self.myasset?["profit"] ?? "" as AnyObject)"
                    cashLabel.text = "\(self.myasset?["cash"] ?? "" as AnyObject)"
                }
                
                
                let rechargeBtn = cell.contentView.viewWithTag(4) as! UIButton
                rechargeBtn.addTarget(self, action: #selector(PropertyViewController.rechargeClick), for: .touchUpInside)
                let cashBtn = cell.contentView.viewWithTag(5) as! UIButton
                cashBtn.addTarget(self, action: #selector(PropertyViewController.cashMoneyClick), for: .touchUpInside)
                 let mMoneyBtn = cell.contentView.viewWithTag(6) as! UIButton
                
                mMoneyBtn.addTarget(self, action: #selector(PropertyViewController.changeTab), for: .touchUpInside)
                return cell
//            }
//            else{
//                let cell = tableView.dequeueReusableCell(withIdentifier: "anymouseCell", for: indexPath)
//                
//                let regesterBtn = cell.contentView.viewWithTag(1) as! UIButton
//                let loginBtn = cell.contentView.viewWithTag(2) as! UIButton
//                regesterBtn.layer.cornerRadius = 5.0
//                regesterBtn.layer.masksToBounds = true
//                
//                
//                loginBtn.layer.cornerRadius = 5.0
//                loginBtn.layer.masksToBounds = true
//                loginBtn.layer.borderWidth = 2.0
//                loginBtn.layer.borderColor = UIColor.red.cgColor
//                return cell
//            }
    
//        }
//        else if indexPath.section == 1 {
//            let cell = tableView.dequeueReusableCell(withIdentifier: "twoCell", for: indexPath)
//            let labelName = cell.contentView.viewWithTag(1) as! UILabel
//            let labelCount = cell.contentView.viewWithTag(2) as! UILabel
//            let labelDesction = cell.contentView.viewWithTag(3) as! UILabel
//            return cell
//        }
//        else  {
//            let cell = tableView.dequeueReusableCell(withIdentifier: "twoCell", for: indexPath)
//            let labelName = cell.contentView.viewWithTag(1) as! UILabel
//            labelName.text = "基金"
//            let labelCount = cell.contentView.viewWithTag(2) as! UILabel
//            let labelDesction = cell.contentView.viewWithTag(3) as! UILabel
//            return cell
//        }
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
//        if getisLogin() {
//             return 1
//        }
//        else{
            return 1
//        }
    }
}

extension PropertyViewController : UITableViewDelegate
{
   
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("indexPath:\(indexPath)")
        let cell = tableView.cellForRow(at: indexPath)
        cell?.setSelected(false, animated: false)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
//        if indexPath.section == 0  {
//            if getisLogin() {
                return 400.0
//            }else{
//                return view.bounds.size.height - 64 - 44
//            }
//
//        }
//        return 80.0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
//        if getisLogin() {
            return max((view.bounds.size.height - 64 - 44 - 400.0)/2,0.0)
//        }else{
//            return 0.0
//        }
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat
    {
//        if getisLogin() {
            return max((view.bounds.size.height - 64 - 44 - 400.0)/2,0.0)
//        }else{
//            return 0.0
//        }
    }
}

