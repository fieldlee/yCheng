//
//  OrderSureViewController.swift
//  yCheng
//
//  Created by De Peng Li on 2017/4/19.
//  Copyright © 2017年 De Peng Li. All rights reserved.
//

import UIKit

class OrderSureViewController: UIViewController {
    lazy var appDelegate :AppDelegate = {
        return UIApplication.shared.delegate as! AppDelegate
    }()
    var orderAddress : Dictionary<String,AnyObject>?
    var productInfo : [String:AnyObject] = [:]
    
    @IBOutlet weak var orderTableView: UITableView!
    func sureOrder() -> Void {
        if (orderAddress != nil) {
            var orderdic = ConstantDict
            orderdic["product"] = productInfo["id"]
            orderdic["address"] = orderAddress?["id"]
            Http.Http_PostInfo(post: url_boot + url_shop_addOrder, parameters: orderdic, completionHandler: { (responseDic) in
                print(responseDic)
                if responseDic["result"] as! NSNumber == 0 {
                    if let tmpDic = responseDic["body"] as? Dictionary<String,AnyObject> {
                        if tmpDic["isLogin"] as! NSNumber == 1 {
                            Drop.down("兑换完成", state: DropState.success, duration: 1.0, action: {
                                self.navigationController?.popViewController(animated: true)
                            })
                            
                            
                            let webView = self.storyboard?.instantiateViewController(withIdentifier: "webView") as? webViewController
                            webView?.url = "http://m.azhongzhi.com/client/shopOrderSuccess.htm"
                            self.navigationController?.pushViewController(webView!, animated: true)
                            
                        }else{
                            //                        没有登录
                            let signStoryBoard = UIStoryboard(name: "sign", bundle: nil)
                            let rootViewControler = signStoryBoard.instantiateViewController(withIdentifier: "realityVerifyNav")
                            self.present(rootViewControler, animated: true) {
                                
                            }
                        }
                    }
                }else{
                    Drop.down(responseDic["msg"] as! String, state: .error)
                }
            })
        }else{
            Drop.down("请选择收货地址", state: .error)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "确认订单"
        // Do any additional setup after loading the view.
        
        orderTableView.delegate = self
        orderTableView.dataSource = self
        orderTableView.backgroundColor = UIColor.groupTableViewBackground
        // Do any additional setup after loading the view.
        
        let addressArr = self.appDelegate.SQLiteDb.getData(T_SQLITE_ADDRESS_LIST, whereStr: " is_default = 1")
        if addressArr.count > 0 {
            orderAddress = addressArr[0] as? Dictionary<String, AnyObject>
        }
        
        getDataAndLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getDataAndLoad() {
 
        Http.Http_PostInfo(post: url_boot+url_get_defaultAddress, parameters: ConstantDict) { (responseDic) in
            print(responseDic)
            if responseDic["result"] as! NSNumber == 0 {
                if let tmpDic = responseDic["body"] as? Dictionary<String,AnyObject> {
                    if tmpDic["isLogin"] as! NSNumber == 1 {
//                        "list": {
//                            "address": "安徽省 安庆 宿松县 天河小区121号1901",//地址
//                            "id": 18,//id
//                            "name": "小李",//收货人
//                            "phone": "13100000000"//电话
//                        }
                        
                        self.orderAddress = tmpDic["list"]  as? Dictionary<String,AnyObject>
                        self.orderTableView.reloadData()
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
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
    }
}
extension OrderSureViewController : UITableViewDelegate
{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 && indexPath.section == 0 {
            let addressView = self.storyboard?.instantiateViewController(withIdentifier: "addressManageView") as! AddressViewController
//            orderView.productInfo = productInfo
            
            addressView.delegate = self
            navigationController?.pushViewController(addressView, animated: true)
        }
    }
}

extension OrderSureViewController : AddressViewDelegate{
    func setAddress(info:Dictionary<String,AnyObject>)
    {
        orderAddress = info
        orderTableView.reloadData()
    }
}

extension OrderSureViewController : UITableViewDataSource
{
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 20.0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 60
        } else if indexPath.section == 1 {
            return 75
        } else {
            return 44
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        //        creditTop
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "addressCell", for: indexPath)
            let nameLab = cell.contentView.viewWithTag(1) as! UILabel
           let addressLab = cell.contentView.viewWithTag(2) as! UILabel
            
            if (orderAddress != nil) {
                nameLab.text = "\(orderAddress?["name"]  ?? "" as AnyObject)   \(orderAddress?["phone"] ?? "" as AnyObject)"
                addressLab.text = "\(orderAddress?["district"] ?? "" as AnyObject)  \(orderAddress?["address"] ?? "" as AnyObject)"
            }else{
                nameLab.text = "请添加收货地址"
                addressLab.text = "注:该商品支持全国(除港澳台地区外)配送"
            }
            
            return cell
        }else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "infoCell", for: indexPath)
            
            let iconImage = cell.contentView.viewWithTag(1) as! UIImageView
            let nameLab = cell.contentView.viewWithTag(2) as! UILabel
            let jflab = cell.contentView.viewWithTag(3) as! UILabel
            let url = NSURL(string: productInfo["product_thumb_img"] as! String)
            
            iconImage.setImageWith(url! as URL)
            nameLab.text = productInfo["product_name"] as? String
            jflab.text = "所需积分:\((productInfo["credit"] as! NSNumber).stringValue)"
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "btnCell", for: indexPath)
            
            let btn = cell.contentView.viewWithTag(1) as! UIButton
            btn.backgroundColor = btnColor
            btn.layer.cornerRadius = 5.0
            btn.layer.masksToBounds = true
            btn.addTarget(self, action: #selector(OrderSureViewController.sureOrder), for: .touchUpInside)
            return cell
        }
    }
    
}
