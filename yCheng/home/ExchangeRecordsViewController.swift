//
//  ExchangeRecordsViewController.swift
//  yCheng
//
//  Created by De Peng Li on 2017/4/26.
//  Copyright © 2017年 De Peng Li. All rights reserved.
//

import UIKit

class ExchangeRecordsViewController: UIViewController {
    lazy var appDelegate :AppDelegate = {
        return UIApplication.shared.delegate as! AppDelegate
    }()
    @IBOutlet weak var tableView: UITableView!
    var exchangeList :[AnyObject] = []
    var currpage = 1
    var allPage = 1
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "兑换记录"
        let refresh = MJRefreshNormalHeader()
        refresh.setRefreshingTarget(self, refreshingAction: #selector(ExchangeRecordsViewController.pullRefresh))
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = UIColor.groupTableViewBackground
        tableView.mj_header = refresh
        getDataAndLoad()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func pullRefresh() {
        getDataAndLoad()
    }
    
    func getDataAndLoad() {
        
//        if currpage > allPage{
//            Drop.down("已经是全部交易记录", state: .info)
//            return
//        }
        
        var exchangeDic = ConstantDict
        exchangeDic["page"] = currpage
        
        Http.Http_PostInfo(post: url_boot+url_trade_record, parameters: exchangeDic) { (responseDic) in
            print(responseDic)
            self.tableView.mj_header.endRefreshing()
            if responseDic["result"] as! NSNumber == 0 {
                if let tmpDic = responseDic["body"] as? Dictionary<String,AnyObject> {
                    if tmpDic["isLogin"] as! NSNumber == 1 {
                        
                        if let tarr = tmpDic["list"] as? [AnyObject]{
                            for o in tarr{
                                self.exchangeList.append(o)
                            }
                        }
                        self.allPage = tmpDic["pageSize"] as! Int

                        self.currpage = self.currpage + 1
                        
                        self.tableView.reloadData()
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
    
}
extension ExchangeRecordsViewController : UITableViewDelegate
{
    
}
extension ExchangeRecordsViewController : UITableViewDataSource
{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return exchangeList.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "recordCell", for: indexPath)
        
        //                    {
        //                        "create_time": "2017-04-18 15:08:48",//兑换时间
        //                        "credit": 100,//使用积分
        //                        "id": 14,
        //                        "order_code": "1704181508482325821905620",//订单号
        //                        "product_img": "http://img.azhongzhi.com/201704/58ec3f51db746.jpg",//产品原图
        //                        "product_name": "红色便捷包",//产品名称
        //                        "product_thumb_img": "http://img.azhongzhi.com/201704/58ec3f51db746_210_210.jpg"//产品缩略图
        let timeLab = cell.contentView.viewWithTag(1) as! UILabel
        let creditlab = cell.contentView.viewWithTag(2) as! UILabel
        let iconImage = cell.contentView.viewWithTag(3) as! UIImageView
        let nameLab = cell.contentView.viewWithTag(4) as! UILabel
        let dingdanLab = cell.contentView.viewWithTag(5) as! UILabel
        
        let tmpdic = exchangeList[indexPath.section] as? Dictionary<String,AnyObject>
        timeLab.text = tmpdic?["create_time"] as? String
        creditlab.text = "\(tmpdic?["credit"] ?? "" as AnyObject)积分"
        let url = URL(string: tmpdic?["product_thumb_img"] as! String)
        iconImage.setImageWith(url!)
        nameLab.text = tmpdic?["product_name"] as? String
        dingdanLab.text = "订单号:\( tmpdic?["order_code"] ?? "" as AnyObject)"
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 5.0
    }
}
