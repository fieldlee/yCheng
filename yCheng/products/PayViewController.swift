//
//  PayViewController.swift
//  yCheng
//
//  Created by De Peng Li on 2017/4/24.
//  Copyright © 2017年 De Peng Li. All rights reserved.
//

import UIKit

class PayViewController: UIViewController {
    var productInfo : Dictionary<String,AnyObject>?
    @IBOutlet weak var payTableView: UITableView!
    var payMoney : Float?
    
    var savedMoney : Float?
    var hasTicket : String?
    var bank : Dictionary<String,AnyObject>?
    var savedPayTag : String = "0"
    var savedLabel : UILabel?
    var savedBtn : UIButton?
    var ticketInfo : Dictionary<String,AnyObject>?
    override func viewDidLoad() {
        super.viewDidLoad()
        payTableView.delegate = self
        payTableView.dataSource = self
        payTableView.backgroundColor = UIColor.groupTableViewBackground
        // Do any additional setup after loading the view.
        title = "支付"
        getMoney()
    }
    func payClick(){
        
        
        
        
        //        product
        
        //
        //        totalMoney
        //        cashMoney
        //        bankMoney
        
        //
        //        coupon
        //        true
        //        string
        //        0
        //        优惠券id（未使用传0）
        
        //        couponMoney
        var payDict = ConstantDict
        payDict["product"] = productInfo?["id"]
        payDict["totalMoney"] = (payMoney! as NSNumber).intValue
        
        if savedPayTag == "1" {
            payDict["cashMoney"] = (savedMoney! as NSNumber).intValue
        }else{
            payDict["cashMoney"] = 0
        }
        
        
        if hasTicket == "1" {
            if ticketInfo != nil {
                payDict["coupon"] = ticketInfo?["id"]
                if ticketInfo?["coupon_type"] as! String == "1" || ticketInfo?["coupon_type"] as! String == "2" {
                    let ticketNum = ((ticketInfo?["coupon_value"] as! String).floatValue as NSNumber).intValue
                    if ticketNum > (payMoney! as NSNumber).intValue
                    {
                        payDict["couponMoney"] = (payMoney! as NSNumber).intValue
                    }else{
                        payDict["couponMoney"] = ticketNum
                    }
                    
                    
                }else{
                    payDict["couponMoney"] = 0
                }
            }else{
                payDict["coupon"] = 0
                payDict["couponMoney"] = 0
            }
        }else{
            payDict["coupon"] = 0
            payDict["couponMoney"] = 0
        }
        
        if savedPayTag == "1"{
            if ticketInfo != nil && (ticketInfo!["coupon_type"] as! String) != "0"{
                if (payMoney! - savedMoney! - (ticketInfo?["coupon_value"] as? String)!.floatValue) > 0 {
                    payDict["bankMoney"] = ((payMoney! - savedMoney! - (ticketInfo?["coupon_value"] as? String)!.floatValue) as NSNumber).intValue
                }else{
                    payDict["bankMoney"] = 0
                }
                
            }else{
                if (payMoney! - savedMoney! ) > 0{
                    payDict["bankMoney"] = ((payMoney! - savedMoney!) as NSNumber).intValue
                }
                else{
                    payDict["bankMoney"] = 0
                }
            }
            
        }else{
            if ticketInfo != nil && (ticketInfo!["coupon_type"] as! String) != "0" {
                if self.payMoney! - (ticketInfo?["coupon_value"] as! String).floatValue > 0 {
                    payDict["bankMoney"] = ((payMoney! - (ticketInfo?["coupon_value"] as! String).floatValue) as NSNumber).intValue
                }else{
                    payDict["bankMoney"] = 0
                }
                
            }else{
                payDict["bankMoney"] = (payMoney! as NSNumber).intValue
            }
        }
        
        
        
        
        Http.Http_PostInfo(post: url_boot+url_submit_order, parameters: payDict) { (responseDic) in
            if responseDic["result"] as! NSNumber == 0 {
                if let tmpDic = responseDic["body"] as? Dictionary<String,AnyObject> {
                    if (tmpDic["list"] as? Dictionary<String,AnyObject>) != nil{
                        Drop.down("恭喜！成功的订购该产品", state:.success)
                        let webView = self.storyboard?.instantiateViewController(withIdentifier: "webView") as? webViewController
                        webView?.url = "http://m.azhongzhi.com/client/orderSuccess.htm"
                        self.navigationController?.pushViewController(webView!, animated: true)
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
    
    func getMoney() -> Void {
        var moneyDic = ConstantDict
        moneyDic["product"] = productInfo?["id"]
        moneyDic["money"] = payMoney
        
        Http.Http_PostInfo(post: url_boot + url_get_money, parameters: moneyDic, completionHandler: { (responseDic) in
            print(responseDic)
            if responseDic["result"] as! NSNumber == 0 {
                if let tmpDic = responseDic["body"] as? Dictionary<String,AnyObject> {
                    //                    "cash": 0,//余额可用金额（最大金额与“待支付金额”相同）
                    //                    "bank": {
                    //                        "account": "9942",
                    //                        "id": 0,
                    //                        "logo": "http://img.azhongzhi.com/201703/58d66f92c05a2.jpg",
                    //                        "name": "中国银行",
                    //                        "thumb_logo": "http://img.azhongzhi.com/"
                    //                    },
                    //                    "is_coupon": 0//是否有优惠券可用（0：无；1：有）
                    self.savedMoney = tmpDic["cash"] as? Float
                    if self.savedMoney! > self.payMoney! {
                        self.savedMoney = self.payMoney
                    }
                    //                    self.savedMoney = 200.0
                    self.hasTicket = (tmpDic["is_coupon"] as! NSNumber).stringValue
                    self.bank = tmpDic["bank"] as? Dictionary<String,AnyObject>
                    self.payTableView.reloadData()
                }
            }else{
                Drop.down(responseDic["msg"] as! String, state: .error)
            }
        })
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
    
    func setPaybySaved() {
        let noselect = UIImage(named: "noselect")
        let select = UIImage(named: "selected")
        if savedPayTag == "0"{
            
            savedPayTag = "1"
            savedLabel?.textColor = UIColor.black
            savedBtn?.setImage(select, for: .normal)
        }else{
            savedPayTag = "0"
            savedLabel?.textColor = UIColor.gray
            savedBtn?.setImage(noselect, for: .normal)
        }
        payTableView.reloadData()
    }
}
extension PayViewController : UITableViewDelegate
{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            if indexPath.row == 1 {
                let navView = self.storyboard?.instantiateViewController(withIdentifier: "CardView") as? CardViewController
                navView?.delegate = self
                navigationController?.pushViewController(navView!, animated: true)
            }
        }
        if indexPath.section == 0 {
            if indexPath.row == 2 {
                if hasTicket == "1" {
                    let selectTicketView = self.storyboard?.instantiateViewController(withIdentifier: "selectTicketView") as? SelectTitcketsViewController
                    selectTicketView?.productInfo = productInfo
                    selectTicketView?.payMoney = payMoney
                    selectTicketView?.delegate = self
                    if ticketInfo != nil {
                        selectTicketView?.selectTicketInfo = ticketInfo
                    }
                    navigationController?.pushViewController(selectTicketView!, animated: true)
                }
            }
        }
    }
}

extension PayViewController : CardViewControllerDelegate
{
    func selectCard(cardinfo: Dictionary<String, AnyObject>) {
        self.navigationController?.popViewController(animated: true)
        
    }
}
extension PayViewController : SelectTitcketsViewControllerDelegate
{
    func selectTicket(ticket: AnyObject) {
        self.navigationController?.popViewController(animated: true)
        if ticket != nil {
            self.ticketInfo = ticket as? Dictionary<String,AnyObject>
        }else{
            self.ticketInfo = nil
        }
        
        self.payTableView.reloadData()
        
    }
}
extension PayViewController : UITableViewDataSource
{
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10.0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 2 {
            return 10.0
        }
        return 0.0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44.0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if section == 0 {
            return 3
        }else if section == 1 {
            return 2
        }else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        //        waitPayCell
        //        saveCell
        //        ticketsCell
        //        bankPayCell
        //        selectBankCell
        //        btnCell
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "waitPayCell", for: indexPath)
                let moneyLab = cell.contentView.viewWithTag(1) as! UILabel
                //
                //                if savedPayTag == "1"{
                //                     if ticketInfo != nil {
                //                        if (payMoney! - savedMoney! - (ticketInfo?["coupon_value"] as? Float)!) > 0 {
                //                            moneyLab.text = "\(payMoney! - savedMoney! - (ticketInfo?["coupon_value"] as? Float)!)元"
                //                        }else{
                //                            moneyLab.text = "0元"
                //                        }
                //
                //                     }else{
                //                        if (payMoney! - savedMoney! ) > 0{
                //                            moneyLab.text = "\(payMoney! - savedMoney!)元"
                //                        }
                //                        else{
                //                            moneyLab.text = "0元"
                //                        }
                //                    }
                //
                //                }else{
                //                    if ticketInfo != nil {
                //                        if self.payMoney! - (ticketInfo?["coupon_value"] as! String).floatValue > 0 {
                //                            moneyLab.text = "\(self.payMoney! - (ticketInfo?["coupon_value"] as! NSNumber).floatValue)元"
                //                        }else{
                //                            moneyLab.text = "0元"
                //                        }
                //
                //                    }else{
                //                        moneyLab.text = "\(self.payMoney ?? 0.00)元"
                //                    }
                //                }
                moneyLab.text = "\(self.payMoney ?? 0.00)元"
                return cell
                
            }else if indexPath.row == 1 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "saveCell", for: indexPath)
                savedLabel = cell.contentView.viewWithTag(1) as? UILabel
                savedBtn = cell.contentView.viewWithTag(2) as? UIButton
                if savedMoney != nil {
                    savedLabel?.text = "可支付\(savedMoney ?? 0)元"
                }else{
                    savedLabel?.text = "可支付0元"
                }
                if ticketInfo != nil && (ticketInfo!["coupon_type"] as! String) != "0" {
                    if savedMoney! - ((ticketInfo?["coupon_value"] as? String)?.floatValue)! > 0 {
                        savedLabel?.text = "可支付\(savedMoney! - (ticketInfo?["coupon_value"] as? String)!.floatValue)元"
                    }else{
                        savedLabel?.text = "可支付0元"
                    }
                }
                
                
                
                savedLabel?.isUserInteractionEnabled = true
                let tapGesture = UITapGestureRecognizer(target: self, action: #selector(PayViewController.setPaybySaved))
                savedLabel?.addGestureRecognizer(tapGesture)
                savedBtn?.addTarget(self, action: #selector(PayViewController.setPaybySaved), for: .touchUpInside)
                return cell
            }else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "ticketsCell", for: indexPath)
                let tickteLab = cell.contentView.viewWithTag(1) as! UILabel
                if ticketInfo != nil {
                    tickteLab.text = ticketInfo?["coupon_name"] as? String
                }else {
                    if hasTicket == "1" {
                        tickteLab.text = "有可用的优惠券"
                    }
                    else {
                        tickteLab.text = "无可用的优惠券"
                    }
                }
                
                return cell
            }
        }else if indexPath.section == 1 {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "bankPayCell", for: indexPath)
                
                let bankPaylab = cell.contentView.viewWithTag(1) as! UILabel
                if savedPayTag == "1"{
                    if ticketInfo != nil && (ticketInfo!["coupon_type"] as! String) != "0"{
                        if (payMoney! - savedMoney! - (ticketInfo?["coupon_value"] as? String)!.floatValue) > 0 {
                            bankPaylab.text = "\(payMoney! - savedMoney! - (ticketInfo?["coupon_value"] as? String)!.floatValue)元"
                        }else{
                            bankPaylab.text = "0元"
                        }
                        
                    }else{
                        if (payMoney! - savedMoney! ) > 0{
                            bankPaylab.text = "\(payMoney! - savedMoney!)元"
                        }
                        else{
                            bankPaylab.text = "0元"
                        }
                    }
                    
                }else{
                    if ticketInfo != nil && (ticketInfo!["coupon_type"] as! String) != "0" {
                        if self.payMoney! - (ticketInfo?["coupon_value"] as! String).floatValue > 0 {
                            bankPaylab.text = "\(self.payMoney! - (ticketInfo?["coupon_value"] as! String).floatValue)元"
                        }else{
                            bankPaylab.text = "0元"
                        }
                        
                    }else{
                        bankPaylab.text = "\(self.payMoney ?? 0.00)元"
                    }
                }
                
                return cell
            }else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "selectBankCell", for: indexPath)
                
                let bankIcon = cell.contentView.viewWithTag(1) as! UIImageView
                let bankLab = cell.contentView.viewWithTag(2) as! UILabel
                if (self.bank != nil) {
                    if let imageString = bank?["logo"] as? String{
                        let imageUrl = URL(string: imageString)
                        bankIcon.setImageWith(imageUrl!)
                        bankLab.text = (bank?["name"] as! String)
                    }
                    
                }
                return cell
            }
        }else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "btnCell", for: indexPath)
            let btn = cell.contentView.viewWithTag(1) as! UIButton
            btn.addTarget(self, action: #selector(PayViewController.payClick), for: .touchUpInside)
            btn.backgroundColor = btnColor
            btn.layer.cornerRadius = 5.0
            btn.layer.masksToBounds = true
            
            return cell
        }
        
    }
    
    
}
