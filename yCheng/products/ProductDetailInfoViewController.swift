//
//  ProductDetailInfoViewController.swift
//  yCheng
//
//  Created by De Peng Li on 2017/4/21.
//  Copyright © 2017年 De Peng Li. All rights reserved.
//

import UIKit

class ProductDetailInfoViewController: UIViewController {
    var productInfo : Dictionary<String,AnyObject>?
    @IBOutlet weak var detailInfoTable: UITableView!
    var bankArr : [AnyObject]?
    var leaest : String?
    var titleArr = ["产品总额","预期年化","期限","起息日","到期日","起购金额","手续费","个人所得税","赎回"]
    var infoArr = [AnyObject]()
    override func viewDidLoad() {
        super.viewDidLoad()
        title = productInfo?["product"]?["product_name"] as? String
        detailInfoTable.delegate = self
        detailInfoTable.dataSource = self
        // Do any additional setup after loading the view.
        bankArr = (productInfo?["bank"] as! [AnyObject])
        
        infoArr.append(productInfo?["product"]?["product_money"] as! String as AnyObject)
        infoArr.append("\(productInfo?["product"]?["profit"] as! String)%" as AnyObject)
        infoArr.append("\(productInfo?["product"]?["day_no"] as! String)天" as AnyObject)
        infoArr.append(productInfo?["product"]?["start_time"] as! String as AnyObject)
        infoArr.append(productInfo?["product"]?["end_time"] as! String as AnyObject)
        infoArr.append("\(productInfo?["product"]?["money_limit"] as! String)" as AnyObject)
        infoArr.append((productInfo?["fee"])!)
        infoArr.append((productInfo?["tax"])!)
        infoArr.append((productInfo?["take"])!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
extension ProductDetailInfoViewController : UITableViewDelegate
{
    
}
extension ProductDetailInfoViewController : UITableViewDataSource
{
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 10.0
        }else{
            return 44.0
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return ""
        }else{
            return "支持银行及限额"
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 && (indexPath.row == 8 || indexPath.row == 9) {
            return 69.0
        }
            return 44.0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if section == 0 {
            return titleArr.count + 1
        }else {
            return (bankArr?.count)!
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "topCell", for: indexPath)
                let nameLab = cell.contentView.viewWithTag(1) as! UILabel
                
                nameLab.text = productInfo?["product"]?["product_name"] as? String
                
                return cell
            }else if indexPath.row == 8 || indexPath.row == 9 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "twoCell", for: indexPath)
                
                let titleLab = cell.contentView.viewWithTag(1) as! UILabel
                titleLab.text = titleArr[indexPath.row - 1]
                let valueLab = cell.contentView.viewWithTag(2) as! UILabel
                valueLab.text = infoArr[indexPath.row - 1] as? String
                return cell
            
            }else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "listCell", for: indexPath)
                
                let titleLab = cell.contentView.viewWithTag(1) as! UILabel
                titleLab.text = titleArr[indexPath.row - 1]
                let valueLab = cell.contentView.viewWithTag(2) as! UILabel
                valueLab.text = infoArr[indexPath.row - 1] as? String
                return cell
            }
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "bankCell", for: indexPath)
            let bankImage = cell.contentView.viewWithTag(1) as! UIImageView
            let url = NSURL(string: bankArr?[indexPath.row]["thumb_logo"] as! String)
            bankImage.setImageWith(url! as URL)
            let banknameLab = cell.contentView.viewWithTag(2) as! UILabel
            banknameLab.text = bankArr?[indexPath.row]["name"] as? String
            let descripLab = cell.contentView.viewWithTag(3) as! UILabel
            descripLab.text = bankArr?[indexPath.row]["quota"] as? String
            
            return cell
        }
       
    }
}
