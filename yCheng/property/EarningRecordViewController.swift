//
//  EarningRecordViewController.swift
//  yCheng
//
//  Created by De Peng Li on 2017/4/29.
//  Copyright © 2017年 De Peng Li. All rights reserved.
//

import UIKit

class EarningRecordViewController: UIViewController {
    var recordsList : [AnyObject] = []
    @IBOutlet weak var tableView: UITableView!
    var currpage = 1
    var allPage = 1
    override func viewDidLoad() {
        super.viewDidLoad()
        let refresh = MJRefreshNormalHeader()
        refresh.setRefreshingTarget(self, refreshingAction: #selector(EarningRecordViewController.pullRefresh))
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor.groupTableViewBackground
        tableView.mj_header = refresh
        title = "收益记录"
        getDataAndLoad()
        // Do any additional setup after loading the view.
    }
    func pullRefresh()  {
        getDataAndLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getDataAndLoad()  {
        var recordDic = ConstantDict
        recordDic["page"] = currpage
        Http.Http_PostInfo(post: url_boot + url_earn_list, parameters: recordDic) { (responseDic) in
            print(responseDic)
            self.tableView.mj_header.endRefreshing()
            if responseDic["result"] as! NSNumber == 0 {
                if let tmpDic = responseDic["body"] as? Dictionary<String,AnyObject> {
                    if tmpDic["isLogin"] as! NSNumber == 1 {
                
                        for o in tmpDic["list"] as! [AnyObject]
                        {
                            self.recordsList.append(o)
                        }
                        self.allPage = tmpDic["pageSize"] as! Int
                        
                        self.currpage = self.currpage + 1
                        
                        self.tableView.reloadData()
                        
                        if self.recordsList.count == 0{
                            self.tableView.separatorColor = UIColor.clear
                            self.tableView.backgroundColor = UIColor.white
                        }
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

}

extension EarningRecordViewController : UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let timeLab = cell.contentView.viewWithTag(1) as! UILabel
        let moneyLab = cell.contentView.viewWithTag(2) as! UILabel

        let tmpDic = recordsList[indexPath.row]
        timeLab.text = tmpDic["profit_day"] as? String
        moneyLab.text = "\((tmpDic["profit_money"] as! NSNumber).stringValue)元"
                //        {
        //            "create_time": "2017-04-06 16:09:30",
        //            "id": 1,
        //            "money": 100,
        //            "product_name": "sss",
        //            "state": "购买成功"
        //        }
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.recordsList.count
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 2.5
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 2.5
    }
    
    
}

extension EarningRecordViewController : UITableViewDelegate
{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("indexPath:\(indexPath)")
        let cell = tableView.cellForRow(at: indexPath)
        cell?.setSelected(false, animated: false)
    }
}
