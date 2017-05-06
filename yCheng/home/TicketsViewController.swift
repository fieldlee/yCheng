//
//  TicketsViewController.swift
//  yCheng
//
//  Created by De Peng Li on 2017/4/2.
//  Copyright © 2017年 De Peng Li. All rights reserved.
//

import UIKit

class TicketsViewController: UIViewController {
    var ticketList = [AnyObject]()
    lazy var appDelegate :AppDelegate = {
        return UIApplication.shared.delegate as! AppDelegate
    }()
    @IBOutlet weak var segBtn: UISegmentedControl!
    var currpage = 1
    var allPage = 1
    var curType = "unUsed"
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title = "我的优惠券"
        let refresh = MJRefreshNormalHeader()
        refresh.setRefreshingTarget(self, refreshingAction: #selector(TicketsViewController.pullRefresh))
        tableView.delegate = self
        tableView.dataSource = self
        tableView.mj_header = refresh
        tableView.backgroundColor = UIColor.groupTableViewBackground
        segBtn.backgroundColor = UIColor.white
        segBtn.tintColor = UIColor.white
        
        var dic = Dictionary<String, Any>()
        dic[NSForegroundColorAttributeName] = UIColor.red
        var dic2 = Dictionary<String, Any>()
        dic2[NSForegroundColorAttributeName] = UIColor.black
        segBtn .setTitleTextAttributes(dic, for: .selected)
        segBtn .setTitleTextAttributes(dic2, for: .normal)
        segBtn.setDividerImage(imageWithColor(color: backColor), forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
        
        getDataAndLoad()
        
    }
    func imageWithColor(color: UIColor) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context!.setFillColor(color.cgColor);
        context!.fill(rect);
        let image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return image!
    }
    @IBOutlet weak var tableView: UITableView!
    @IBAction func changeTicket(_ sender: Any) {
        getDataAndLoad()
//        tableView.reloadData()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func pullRefresh() {
        getDataAndLoad()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    func getDataAndLoad() -> Void {
        var tmpType = ""
        var tmpurl = ""
        if segBtn.selectedSegmentIndex == 0 {
            tmpurl = url_credit_unused
            tmpType = "unUsed"
        }else if segBtn.selectedSegmentIndex == 1 {
            tmpurl = url_credit_used
            tmpType = "used"
        }else{
            tmpurl = url_credit_expired
            tmpType = "expired"
        }
        
        var ticketDic = ConstantDict
        
        if curType != tmpType {
            curType = tmpType
            ticketList = []
            currpage = 1
        }
        
        ticketDic["page"] = currpage
        
        
        Http.Http_PostInfo(post: url_boot + tmpurl, parameters: ticketDic) { (responseDic) in
            print(responseDic)
            self.tableView.mj_header.endRefreshing()
            if responseDic["result"] as! NSNumber == 0 {
                if let tmpDic = responseDic["body"] as? Dictionary<String,AnyObject> {
                    if tmpDic["isLogin"] as! NSNumber == 1 {
//                        "count": 3,//总条数
//                        "pageSize": 1,//总页数
                        if let tarr = tmpDic["list"] as? [AnyObject]{
                            for o in tarr{
                                self.ticketList.append(o)
                            }
                        }
                        self.allPage = tmpDic["pageSize"] as! Int
                        
                        self.currpage = self.currpage + 1
                        
                        self.tableView.reloadData()
                    }else{
                        //                        没有登录
                    }
                }
            }else{
                Drop.down(responseDic["msg"] as! String, state: .error)
            }
        }
    }
}
extension TicketsViewController : UITableViewDelegate
{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.selectionStyle = .none
    }
    
}
extension TicketsViewController : UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let colorView = cell.contentView.viewWithTag(1)
        
        
        
        colorView?.backgroundColor = mainColor
        colorView?.layer.borderColor = mainColor.cgColor
        colorView?.layer.borderWidth = 0.0
        var modifyFrame = colorView?.frame
        modifyFrame?.size.width = (colorView?.frame.size.width)! + 1
        colorView?.frame = modifyFrame!
        
        let tmpTicket = ticketList[indexPath.row]
        
        let lab1 = cell.contentView.viewWithTag(2) as! UILabel
        let lab2 = cell.contentView.viewWithTag(3) as! UILabel
        let lab3 = cell.contentView.viewWithTag(4) as! UILabel
        let lab4 = cell.contentView.viewWithTag(5) as! UILabel
        let lab5 = cell.contentView.viewWithTag(6) as! UILabel
//        "category": "直减券",//优惠券类型文字显示
//        "content": "移动用户专用",//其它说明
//        "coupon_name": "30元直减券",//优惠券名称
//        "coupon_type": 1,//优惠券类型（0：加息券；1：直减券；2：满减券）
//        "coupon_value": 30,//优惠券值（加息时为加息百分比，其它为优惠值）
//        "end_time": "2017-04-20"//过期日期
        lab1.textColor = UIColor.white
        lab1.textAlignment = .center
        
        
        lab2.backgroundColor = mainColor
        lab2.layer.cornerRadius = 5.0
        lab2.layer.masksToBounds = true
        lab2.textColor = UIColor.white
        
        if let type = tmpTicket["coupon_type"] as? String{
            if type == "0"{
                lab1.text = "+\(tmpTicket["coupon_type"] as? String ?? "")%"
                lab2.text = "加息券"
                lab2.backgroundColor = mainColor
            }else if type == "1" {
                lab2.text = "直减券"
                lab2.backgroundColor = subtractColor

            }else{
                lab2.text = "满减券"
                lab2.backgroundColor = mSubtractColor
            }
        }
        
        lab3.text = tmpTicket["category"] as? String
        lab4.text = "有效期:\(tmpTicket["end_time"] as? String ?? "")"
        lab5.text = tmpTicket["content"] as? String
        
        
        let image = cell.contentView.viewWithTag(10) as! UIImageView
        
        let statusImg = cell.contentView.viewWithTag(11) as! UIImageView
        if segBtn.selectedSegmentIndex == 0 {
            statusImg.isHidden = true
            image.image = UIImage(named: "valid")
            lab3.textColor = UIColor.black
            lab4.textColor = UIColor.black
            lab5.textColor = UIColor.black
        }
        if segBtn.selectedSegmentIndex == 1 {
            colorView?.backgroundColor = usedColor
            statusImg.isHidden = false
            statusImg.image = UIImage(named: "used")
            lab2.backgroundColor = usedColor
            image.image = UIImage(named: "invalid")
            
            lab3.textColor = usedColor
            lab4.textColor = usedColor
            lab5.textColor = usedColor
        }
        if segBtn.selectedSegmentIndex == 2 {
            colorView?.backgroundColor = usedColor
            statusImg.isHidden = false
            statusImg.image = UIImage(named: "expired")
            lab2.backgroundColor = usedColor
            image.image = UIImage(named: "invalid")
            lab3.textColor = usedColor
            lab4.textColor = usedColor
            lab5.textColor = usedColor
        }
        
        return cell
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return ticketList.count
    }// Default is 1 if not implemented

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90.0
    }
}
