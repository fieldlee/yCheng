//
//  ProductDetailViewController.swift
//  yCheng
//
//  Created by De Peng Li on 2017/4/21.
//  Copyright © 2017年 De Peng Li. All rights reserved.
//

import UIKit

class ProductDetailViewController: UIViewController {
    var productDetailInfo:Dictionary<String,AnyObject>?
    @IBOutlet weak var buyBtn: UIButton!
    @IBOutlet weak var productInfoTableview: UITableView!
    @IBAction func buyClick(_ sender: Any) {
      let typeView =  self.storyboard?.instantiateViewController(withIdentifier: "TypeMoneyView") as! TypeMoneyViewController
        typeView.productInfo = self.productInfo
        self.navigationController?.pushViewController(typeView, animated: true)
    }
    var productInfo : Dictionary<String,AnyObject>?
    var productId : AnyObject?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = productInfo?["product_name"] as? String
        buyBtn.backgroundColor = btnColor
        buyBtn.layer.cornerRadius = 5.0
        buyBtn.layer.masksToBounds = true
        
        productInfoTableview.delegate = self
        productInfoTableview.dataSource = self
//        if productInfo
        getDataAndLoad()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getDataAndLoad() -> Void {
        var detailDic = ConstantDict
        if productInfo != nil {
            detailDic["product"] = productInfo?["id"]
        }else{
            detailDic["product"] = productId
        }
        
        
        Http.Http_PostInfo(post: url_boot+url_product_productInfo, parameters: detailDic) { (responseDic) in
            print(responseDic)
            if responseDic["result"] as! NSNumber == 0 {
                if let tmpdic = responseDic["body"] as? Dictionary<String,AnyObject> {
                    self.productDetailInfo = tmpdic
                    self.productInfo = (self.productDetailInfo?["product"] as! Dictionary<String, AnyObject>)
                    self.title = self.productInfo?["product_name"] as! String
                    self.productInfoTableview.reloadData()
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
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
    }
}
extension ProductDetailViewController : UITableViewDataSource{
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10.0
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 1 {
            return 10.0
        }
        return 0.0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                return  200.0
                //        }
                //        else if indexPath.row == 1{
                //            return 44.0
            } else {
                return 120.0
            }
        }
        else{
            return 44.0
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if section == 0 {
            return 2
        }else{
            return 3
        }
       
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "topCell", for: indexPath)
                
                let descripLab = cell.contentView.viewWithTag(1) as! UILabel
                if let profit = productInfo?["profit"] as? String {
                    let numstr = "\(String(format: "%.2f", profit.floatValue))"
                    descripLab.text = numstr
                    descripLab.adjustsFontSizeToFitWidth = true
                }
                
                
                
                let descrip2Lab = cell.contentView.viewWithTag(2) as! UILabel
                
                let countstr = "最近30天已经有\(productInfo?["count"] as? String ?? "")人购买该系列产品"
                let attcount = NSMutableAttributedString(string: countstr)
                
                attcount.addAttributes([NSForegroundColorAttributeName:UIColor.darkGray], range: NSMakeRange(0, 8))
                attcount.addAttributes([NSForegroundColorAttributeName:UIColor.red], range: NSMakeRange(8, countstr.characters.count-16))
                attcount.addAttributes([NSForegroundColorAttributeName:UIColor.darkGray], range: NSMakeRange(countstr.characters.count-8, 8))
                descrip2Lab.attributedText = attcount
                
                let btn1 = cell.contentView.viewWithTag(101) as! UIButton
                let btn2 = cell.contentView.viewWithTag(102) as! UIButton
                let btn3 = cell.contentView.viewWithTag(103) as! UIButton
                btn1.layer.borderColor = UIColor.darkGray.cgColor
                btn1.layer.borderWidth = 1.0
                btn2.layer.borderColor = UIColor.darkGray.cgColor
                btn2.layer.borderWidth = 1.0
                btn3.layer.borderColor = UIColor.darkGray.cgColor
                btn3.layer.borderWidth = 1.0
                return cell
                //        }else if indexPath.row == 1{
                //            let cell = tableView.dequeueReusableCell(withIdentifier: "twoCell", for: indexPath)
                //            return cell
            }else{
                let cell = tableView.dequeueReusableCell(withIdentifier: "dateCell", for: indexPath)
                
                let dayLab = cell.contentView.viewWithTag(1) as! UILabel
                dayLab.text = "\(productInfo?["day_no"] as? String ?? "")天"
                
                let startLab = cell.contentView.viewWithTag(2) as! UILabel
                startLab.text = productInfo?["start_time"] as? String
                
                let moneyLab = cell.contentView.viewWithTag(3) as! UILabel
                moneyLab.text = "\(productInfo?["lowest"] as? String ?? "")元"
                
                let endLab = cell.contentView.viewWithTag(4) as! UILabel
                endLab.text = productInfo?["end_time"] as? String
                
                
                return cell
            }
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "bottomCell", for: indexPath)
            let titleLab = cell.contentView.viewWithTag(1) as! UILabel
            if indexPath.row == 0 {
                titleLab.text = "资产安全"
            } else if indexPath.row == 1 {
                titleLab.text = "产品详情"
            } else if indexPath.row == 2 {
                titleLab.text = "平台免责声明"
            }
            
            return cell
        }
    }
}
extension ProductDetailViewController : UITableViewDelegate
{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            if indexPath.row == 0 {
                let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
                let navView = storyBoard.instantiateViewController(withIdentifier: "ProductDetailSafeView") as! ProductDetailSafeViewController
                navView.productInfo = productDetailInfo
                navigationController?.pushViewController(navView, animated: true)
            }
            if indexPath.row == 1 {
                let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
                let navView = storyBoard.instantiateViewController(withIdentifier: "ProductDetailInfoView") as! ProductDetailInfoViewController
                navView.productInfo = productDetailInfo
                navigationController?.pushViewController(navView, animated: true)
            }
            if indexPath.row == 2 {
                let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
                let navView = storyBoard.instantiateViewController(withIdentifier: "ProductDetailLawView") as! ProductDetailLawViewController
                navView.productInfo = productDetailInfo
                navigationController?.pushViewController(navView, animated: true)
            }
        }
        
    }
}
