//
//  MoreViewController.swift
//  yCheng
//
//  Created by De Peng Li on 2017/3/21.
//  Copyright © 2017年 De Peng Li. All rights reserved.
//

import UIKit

class MoreViewController: UIViewController {
    var moreDic : Dictionary<String,AnyObject>?
    lazy var appDelegate :AppDelegate = {
        return UIApplication.shared.delegate as! AppDelegate
    }()
    @IBOutlet weak var moreTableView: UITableView!
    
    @IBOutlet weak var loginBtn: UIButton!

    @IBAction func login(_ sender: Any) {
        ////  未登陆
        let signStoryBoard = UIStoryboard(name: "sign", bundle: nil)
        let rootViewControler = signStoryBoard.instantiateInitialViewController()
        appDelegate.window?.rootViewController = rootViewControler
    }
    override func viewDidLoad() {

        super.viewDidLoad()
        title = "我的"
        view.backgroundColor = backColor
        // Do any additional setup after loading the view.
        moreTableView.dataSource = self
        moreTableView.delegate = self
        moreTableView.backgroundColor = backColor

        if getisLogin() {
            loginBtn.isHidden = true
        }
        
        getDataAndLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        return false
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
    }
    func getDataAndLoad()  {
        Http.Http_PostInfo(post: url_boot + url_my_home, parameters: ConstantDict) { (responseDic) in
            print(responseDic)
//            "isLogin": 1,//是否登录（1为已登录）
//            "slogan": "邀请码告诉给注册者，方便给别人，积分给自己",//邀请码下显示文字
//            "phone": "13761866168",//客服实际拨出时使用的号码
//            "phoneShow": "400-123-2560"//客服显示的号码
//            "code": "1438510557"//我的邀请码
            if responseDic["result"] as! NSNumber == 0 {
                if let tmpDic = responseDic["body"] as? Dictionary<String,AnyObject> {
                    self.moreDic = tmpDic
                    self.moreTableView.reloadData()
                }
            }else{
                Drop.down(responseDic["msg"] as! String, state: .error)
            }
        }
    }
    
    func logout() -> Void {
        let logoutDic = ConstantDict
        
        Http.Http_PostInfo(post: url_boot+url_logout, parameters: logoutDic) { (responseDic) in
            print("responseDict:\(responseDic)")
            
            if responseDic["result"] as! NSNumber == 0 {
                if let body = responseDic["body"] {
                    if let isLogin = body["isLogin"] as? NSNumber{
                        if isLogin == 0 {
                            let defaults = UserDefaults.standard
                            defaults.removeObject(forKey: T_User_password)
                            defaults.removeObject(forKey: T_User_phoneNumber)
                            defaults.removeObject(forKey: T_Token)
                            defaults.removeObject(forKey: T_User_Name)
                            defaults.removeObject(forKey: T_User_Code)
                            defaults.synchronize()
                            self.loginBtn.isHidden = false
                            self.moreTableView.reloadData()
                        }
                    }
                }
            }else{
                Drop.down(responseDic["msg"] as! String, state: .error)
            }
        }
    }
}

extension MoreViewController : UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if getisLogin() {
            return 9
        }
        return 8
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if indexPath.row <= 6 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            
            let labelTitle = cell.contentView.viewWithTag(1) as! UILabel
            let labelDesction = cell.contentView.viewWithTag(2) as! UILabel
            
            if indexPath.row == 0 {
                labelTitle.text = "我的账号"
                labelDesction.text = "未完善"
                labelDesction.isHidden = false
            }else if indexPath.row == 1 {
                labelTitle.text = "银行卡"
                labelDesction.isHidden = true
            }else if indexPath.row == 2 {
                labelTitle.text = "提醒通知"
                labelDesction.isHidden = true
            }else if indexPath.row == 3 {
                labelTitle.text = "关于乙晟"
                labelDesction.isHidden = true
            }else if indexPath.row == 4 {
                labelTitle.text = "吐个槽"
                labelDesction.isHidden = true
            }else if indexPath.row == 5 {
                if (moreDic != nil) {
                    labelTitle.text = "客户电话:\(moreDic?["phoneShow"] ?? "" as AnyObject)"
                }
                else{
                    labelTitle.text = "客户电话"
                }
                labelDesction.isHidden = true
                cell.accessoryType = .none
            }else if indexPath.row == 6 {
                labelTitle.text = "版本号：V1.0"
                labelDesction.isHidden = true
                cell.accessoryType = .none
            }
            return cell
        }
        
        else if indexPath.row == 7{
            let cell2 = tableView.dequeueReusableCell(withIdentifier: "cell2", for: indexPath)
             let lab1 = cell2.contentView.viewWithTag(1) as! UILabel
             let lab2 = cell2.contentView.viewWithTag(2) as! UILabel
            
            lab1.text = "我的邀请码：\(moreDic?["code"] ?? "" as AnyObject)"

            lab2.text = "\(moreDic?["slogan"] ?? "" as AnyObject)"
            cell2.accessoryType = .none
            return cell2
        }else{
            let cell3 = tableView.dequeueReusableCell(withIdentifier: "cell3", for: indexPath)
            let logoutBtn = cell3.contentView.viewWithTag(1) as! UIButton
            logoutBtn.backgroundColor = btnColor
            logoutBtn.addTarget(self, action: #selector(MoreViewController.logout), for: .touchUpInside)
            logoutBtn.layer.cornerRadius = 5.0
            logoutBtn.layer.masksToBounds=true
            
            return cell3
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}

extension MoreViewController : UITableViewDelegate
{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.setSelected(false, animated: false)
        
//        if indexPath.row == 1 {
//            let webView = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "webView")
//            navigationController?.pushViewController(webView, animated: true)
//        } CardView
        
        
        if indexPath.row == 0 {
            let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
            let navView = storyBoard.instantiateViewController(withIdentifier: "AccountView")
            navigationController?.pushViewController(navView, animated: true)
        }else if indexPath.row == 1 {
            let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
            let navView = storyBoard.instantiateViewController(withIdentifier: "CardView")
            navigationController?.pushViewController(navView, animated: true)
        }else if indexPath.row == 2 {
                let newView = self.storyboard?.instantiateViewController(withIdentifier: "newView") as! NewsViewController
                navigationController?.pushViewController(newView, animated: true)
        }else if indexPath.row == 3{

                let webView = self.storyboard?.instantiateViewController(withIdentifier: "webView") as? webViewController
                webView?.url = "http://m.azhongzhi.com/client/info/guanyuyisheng"
                navigationController?.pushViewController(webView!, animated: true)
    
        }else if indexPath.row == 4 {
            let feedbackView = self.storyboard?.instantiateViewController(withIdentifier: "feedbackView") as! BackCommentViewController
            navigationController?.pushViewController(feedbackView, animated: true)
        }else if indexPath.row == 5 {
            let phoneNumberURL = "tel://\(moreDic?["phoneShow"] ?? "" as AnyObject)"
            UIApplication.shared.openURL(NSURL(string: phoneNumberURL)! as URL)
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if indexPath.row <= 6 {
            return 44.0
        }
        else{
            return 60.0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        return 10.0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat
    {
        return 10.0
    }
    

    
//    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
//        let rect = CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 100.0)
//        let footerView = UIView(frame: rect)
//        footerView.backgroundColor = litColor
//        return footerView
//    }
}
