//
//  NewAddressViewController.swift
//  yCheng
//
//  Created by De Peng Li on 2017/4/19.
//  Copyright © 2017年 De Peng Li. All rights reserved.
//

import UIKit



class NewAddressViewController: UIViewController {
    @IBOutlet weak var newAddressTableView: UITableView!

    lazy var appDelegate :AppDelegate = {
        return UIApplication.shared.delegate as! AppDelegate
    }()
    var receivedName : String?
    var receivedAddress : String?
    var receviedAera :String?
    var receviedPhone : String?
    var isDefault = "0"
    
    
    var nameField : UITextField?
    var phoneField : UITextField?
    var areaField : UITextField?
    var addressField : UITextField?
    
    var areaid = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "新增收货地址"
        newAddressTableView.delegate = self
        newAddressTableView.dataSource = self
        newAddressTableView.backgroundColor = UIColor.groupTableViewBackground
        // Do any additional setup after loading the view.
        
        
        
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
    func setDefalut(sender:UIButton) -> Void {
        let butImage = UIImage(named: "noselect")
        let selectImage = UIImage(named: "selected")
        if isDefault == "0"{
            isDefault = "1"
            sender.setImage(selectImage, for: .normal)
            sender.setTitleColor(mainColor, for: .normal)
        }else{
            isDefault = "0"
            sender.setImage(butImage, for: .normal)
            sender.setTitleColor(UIColor.gray, for: .normal)
        }
    }
    func pushNewAddress() -> Void {
        
        if nameField?.text == ""  {
            Drop.down("请输入收货人姓名", state: .error)
            return
        }
        if areaid == ""  {
            Drop.down("请选择地址", state: .error)
            return
        }
        if phoneField?.text == ""  {
            Drop.down("请输入后货人手机号码", state: .error)
            return
        }
        if addressField?.text == ""  {
            Drop.down("请输入详细地址", state: .error)
            return
        }
        var addressDic = ConstantDict
        addressDic["id"] = "0"
        addressDic["name"] = nameField?.text
        addressDic["areaId"] = areaid
        addressDic["phone"] = phoneField?.text
        addressDic["address"] = addressField?.text
        addressDic["isDefault"] = isDefault
        Http.Http_PostInfo(post: url_boot + url_setAddress, parameters: addressDic) { (responseDic) in
            print(responseDic)
            if responseDic["result"] as! NSNumber == 0 {
                if let tmpDic = responseDic["body"] as? Dictionary<String,AnyObject> {
                    if tmpDic["isLogin"] as! NSNumber == 1 {
//                        "list": {
//                            "address": "天河小区121号1901",
//                            "district": "河北省 邢台 威县",
//                            "id": 12,
//                            "is_default": 1,
//                            "name": "小李",
//                            "phone": "13100000000",
//                            "sys_district_id": 1231,
//                            "users_id": 25
//                        }
                        
                        if let tmpAddInfo = tmpDic["list"] as? Dictionary<String,AnyObject> {
                            
                        self.appDelegate.SQLiteDb.Insert(tablename: T_SQLITE_ADDRESS_LIST, insertValue: tmpAddInfo)
                        self.navigationController?.popViewController(animated: true)
                        }
                        
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
extension NewAddressViewController : UITableViewDelegate
{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 && indexPath.row == 2 {
            let selectaddressView = self.storyboard?.instantiateViewController(withIdentifier: "AreaListView") as! AreaListTableViewController
            //            orderView.productInfo = productInfo
            
            selectaddressView.delegateArealist = self
            
            navigationController?.pushViewController(selectaddressView, animated: true)
        }
    }
}

extension NewAddressViewController : AreaListDelegate{
    func callbackSetArea(backMsg:String,areaid:String)
    {
        areaField?.text = backMsg
        self.areaid = areaid
    }
}

extension NewAddressViewController : UITableViewDataSource
{
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10.0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44.0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if section == 0{
            return 5
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
//        receivePersonCell
//        phoneNoCell
//        addressCell
//        detailAddressCell
//        defaultBtnCell
        //        creditTop
        if indexPath.section == 0  {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "receivePersonCell", for: indexPath)
                nameField = cell.contentView.viewWithTag(1) as? UITextField
                if (receivedName != nil) {
                    nameField?.text = receivedName
                }
                return cell
            }
            else if indexPath.row == 1 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "phoneNoCell", for: indexPath)
                phoneField = cell.contentView.viewWithTag(1) as? UITextField
                if (receviedPhone != nil) {
                    phoneField?.text = receviedPhone
                }
                return cell
            }
            else if indexPath.row == 2
            {
                let cell = tableView.dequeueReusableCell(withIdentifier: "addressCell", for: indexPath)
                areaField = cell.contentView.viewWithTag(1) as? UITextField
                areaField?.isUserInteractionEnabled = false
              
                if (areaField != nil) {
                    areaField?.text = receviedAera
                }
                
                return cell
            }else if indexPath.row == 3{
                let cell = tableView.dequeueReusableCell(withIdentifier: "detailAddressCell", for: indexPath)
                addressField = cell.contentView.viewWithTag(1) as? UITextField
                if (addressField != nil) {
                    addressField?.text = receivedAddress
                }
                return cell
            }else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "defaultBtnCell", for: indexPath)
                let defaultBtn = cell.viewWithTag(1) as! UIButton
                defaultBtn.addTarget(self, action: #selector(NewAddressViewController.setDefalut(sender:)), for: .touchUpInside)
                
                if isDefault == "1" {
                    let selectImage = UIImage(named: "selected")
                    defaultBtn.setImage(selectImage, for: .normal)
                    defaultBtn.setTitleColor(mainColor, for: .normal)
                }
                
                return cell
            }
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "btnCell", for: indexPath)
            
            let btn = cell.contentView.viewWithTag(1) as! UIButton
            btn.backgroundColor = btnColor
            btn.layer.cornerRadius = 5.0
            btn.layer.masksToBounds = true
            btn.addTarget(self, action: #selector(NewAddressViewController.pushNewAddress), for: .touchUpInside)
            return cell
        }
    }
    
}
