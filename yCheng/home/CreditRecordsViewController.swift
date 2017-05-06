//
//  CreditRecordsViewController.swift
//  yCheng
//
//  Created by De Peng Li on 2017/4/19.
//  Copyright © 2017年 De Peng Li. All rights reserved.
//

import UIKit

class CreditRecordsViewController: UIViewController {
    
    @IBOutlet weak var creditTable: UITableView!
    var myCredit : String?
    var myCreditList = [AnyObject]()
    var currpage = 1
    var allPage = 1
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "积分列表"
        let refresh = MJRefreshNormalHeader()
        refresh.setRefreshingTarget(self, refreshingAction: #selector(CreditRecordsViewController.pullRefresh))
        creditTable.delegate = self
        creditTable.dataSource = self
        creditTable.backgroundColor = UIColor.groupTableViewBackground
        creditTable.mj_header = refresh
        getDataAndLoad()
        // Do any additional setup after loading the view.
        
    }
    func pullRefresh()  {
        getDataAndLoad()
    }
    
    func getDataAndLoad()  {
        //       积分列表
        var creditDict = ConstantDict
        creditDict["page"] = currpage
        Http.Http_PostInfo(post: url_boot+url_my_credit_list, parameters: creditDict) { (responseDic) in
            print(responseDic)
            self.creditTable.mj_header.endRefreshing()
            if responseDic["result"] as! NSNumber == 0 {
                if let tmpDic = responseDic["body"] as? Dictionary<String,AnyObject> {
                    if  tmpDic["isLogin"] as! NSNumber == 0 {
                        // 登录
                    }else{
                        if let listCredit = tmpDic["list"] as? NSArray{
                            
                            for t in listCredit{
                                self.myCreditList.append(t as AnyObject)
                            }
                            self.allPage = tmpDic["pageSize"] as! Int
                            self.currpage = self.currpage + 1
                            
                            self.creditTable.reloadData()
                        }
                    }
                    
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
    
}
extension CreditRecordsViewController : UITableViewDelegate
{
    
}
extension CreditRecordsViewController : UITableViewDataSource
{
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10.0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return myCreditList.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        //        creditTop
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "creditTop", for: indexPath)
            
            let creditLab = cell.contentView.viewWithTag(1) as! UILabel
            creditLab.text = myCredit
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "recordCell", for: indexPath)
            
            let tmpdic = myCreditList[indexPath.row - 1] as! Dictionary<String,AnyObject>
            
            let nameLab = cell.contentView.viewWithTag(1) as! UILabel
            nameLab.text = tmpdic["type_name"] as? String
            let timeLab = cell.contentView.viewWithTag(2) as! UILabel
            timeLab.text = tmpdic["create_time"] as? String
            let creditLab = cell.contentView.viewWithTag(3) as! UILabel
            creditLab.text = tmpdic["credit"]?.stringValue
            return cell
        }
        
    }
    
}
