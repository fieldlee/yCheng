//
//  DetailViewController.swift
//  yCheng
//
//  Created by De Peng Li on 2017/4/19.
//  Copyright © 2017年 De Peng Li. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    var titleName : String?
    var productInfo :[String:AnyObject]?
    @IBOutlet weak var exchangeBtn: UIButton!
    @IBOutlet weak var detailTableView: UITableView!
    var productId : AnyObject?
    
    @IBAction func exchangeClick(_ sender: Any) {
    
        
//        orderView
        
        let orderView = self.storyboard?.instantiateViewController(withIdentifier: "orderView") as! OrderSureViewController
        orderView.productInfo = productInfo!
        navigationController?.pushViewController(orderView, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = titleName
        // Do any additional setup after loading the view.
        
        detailTableView.delegate = self
        detailTableView.dataSource = self
        
        exchangeBtn.backgroundColor = btnColor
        exchangeBtn.layer.cornerRadius = 5.0
        exchangeBtn.layer.masksToBounds = true
        getDataAndLoad()
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func  getDataAndLoad()  {
        var detailDic = ConstantDict
        
        if productId != nil {
            detailDic["item"] = productId
        }else{
            detailDic["item"] = "\(productInfo?["id"] ?? "" as AnyObject)"
        }
        Http.Http_PostInfo(post: url_boot+url_product_detail, parameters: detailDic) { (responseDic) in
            print(responseDic)
            if responseDic["result"] as! NSNumber == 0 {
                if let tmpdic = responseDic["body"] as? Dictionary<String,AnyObject> {
                    self.productInfo = tmpdic
                    self.detailTableView.reloadData()
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
extension DetailViewController : UITableViewDelegate
{
    
}
extension DetailViewController : UITableViewDataSource
{
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 20.0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 250
        } else if indexPath.section == 1 {
            if indexPath.row == 0 {
                return 44
            }else{
                return 75
            }
        }else{
            if indexPath.row == 0 {
                return 44
            }else{
                return 75
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if section == 0 {
            return 1
        }else{
            return 2
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        //        creditTop
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "topCell", for: indexPath)
            
            let productImageView = cell.contentView.viewWithTag(1) as! UIImageView
            if productInfo != nil {
                let url = URL(string: productInfo?["product_thumb_img"] as! String)
                productImageView.yy_setImage(with: url, options: .allowBackgroundTask)
                
                
                let productInfoLab = cell.contentView.viewWithTag(2) as! UILabel
                productInfoLab.text = "所需积分："+(productInfo?["credit"]?.stringValue)!+"积分"
            }
            
            return cell
        }else{
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "titleCell", for: indexPath)
                let titleLabel = cell.contentView.viewWithTag(1) as! UILabel
                
                if indexPath.section == 1 {
                    titleLabel.text = "产品简介"
                }else{
                    titleLabel.text = "使用方法"
                }
                
                return cell
            }else{
                let cell = tableView.dequeueReusableCell(withIdentifier: "infoCell", for: indexPath)
                let infoLabel = cell.contentView.viewWithTag(1) as! UILabel
//                content = www;
//                credit = 33;
//                id = 4;
//                instructions = wwww;
                if productInfo != nil {
                    if indexPath.section == 1 {
                        if let content = productInfo?["content"] as? String{
                            infoLabel.text = content
                        }
                        
                    }else{
                        if let instruction = productInfo?["instructions"] as? String{
                            infoLabel.text = instruction
                        }
                        
                    }
                }
                
                
                return cell
            }
        }
        
    }
    
}
