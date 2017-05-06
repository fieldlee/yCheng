//
//  AddressViewController.swift
//  yCheng
//
//  Created by De Peng Li on 2017/4/19.
//  Copyright © 2017年 De Peng Li. All rights reserved.
//

import UIKit

protocol AddressViewDelegate {
    func setAddress(info:Dictionary<String,AnyObject>)
}

class AddressViewController: UIViewController {
    var addressinfo = [AnyObject]()
    @IBOutlet weak var addressTable: UITableView!
    
    var delegate : AddressViewDelegate?
    
    lazy var appDelegate :AppDelegate = {
        return UIApplication.shared.delegate as! AppDelegate
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "收货地址管理"
        // Do any additional setup after loading the view.
        
        addressTable.delegate = self
        addressTable.dataSource = self
        addressTable.backgroundColor = UIColor.groupTableViewBackground
        // Do any additional setup after loading the view.
        
//        addressinfo = self.appDelegate.SQLiteDb.getData(T_SQLITE_ADDRESS_LIST)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getDataAndLoad()
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
    
    func setDefault(sender:UIButton) -> Void {
        var setInfo = self.addressinfo[sender.tag - 100] as! Dictionary<String,AnyObject>
        var setDic = ConstantDict
        setDic["id"] = setInfo["id"] ?? ""
        Http.Http_PostInfo(post: url_boot + url_setDefaultAddress, parameters: setDic) { (responseDic) in
            print(responseDic)
            if responseDic["result"] as! NSNumber == 0 {
                if let tmpDic = responseDic["body"] as? Dictionary<String,AnyObject> {
                    if tmpDic["isLogin"] as! NSNumber == 1 {
                        if tmpDic["isdefault"] as! NSNumber == 1 {
                            setInfo["is_default"] = "1" as AnyObject
//                            self.appDelegate.SQLiteDb.Insert(tablename: T_SQLITE_ADDRESS_LIST, insertValue: setInfo )
//                            self.addressinfo = self.appDelegate.SQLiteDb.getData(T_SQLITE_ADDRESS_LIST)
                            
                            self.getDataAndLoad()
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
    
    func deleteInfo(sender:UIButton) -> Void {
        let alert = UIAlertController(title: "确认", message: "确认删除该地址？", preferredStyle: .alert)
        let sureAction = UIAlertAction(title: "确定", style: .default) { (action) in
            let delInfo = self.addressinfo[sender.tag - 1000]
            var delDic = ConstantDict
            delDic["id"] = delInfo["id"] ?? ""
            Http.Http_PostInfo(post: url_boot + url_deleteAddress, parameters: delDic) { (responseDic) in
                print(responseDic)
                if responseDic["result"] as! NSNumber == 0 {
                    if let tmpDic = responseDic["body"] as? Dictionary<String,AnyObject> {
                        if tmpDic["isLogin"] as! NSNumber == 1 {
                            if tmpDic["isDelete"] as! NSNumber == 1 {
//                                self.appDelegate.SQLiteDb.deleteData(T_SQLITE_ADDRESS_LIST, whereStr: " id = \(delDic["id"] ?? "")")
//                                self.addressinfo = self.appDelegate.SQLiteDb.getData(T_SQLITE_ADDRESS_LIST)
                                self.getDataAndLoad()
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
        
        let cancelAction = UIAlertAction(title: "取消", style: .cancel) { (action) in
            
        }
        alert.addAction(sureAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
//        present(alert, animated: true, completion: nil)
    }
    
    func newAddress() -> Void {
        let NewaddressView = self.storyboard?.instantiateViewController(withIdentifier: "NewAddressView") as! NewAddressViewController
        //            orderView.productInfo = productInfo
        navigationController?.pushViewController(NewaddressView, animated: true)
    }

    
    func editAddress(sender:UIButton) -> Void {
        
        let tmpInfo = addressinfo[sender.tag - 1] as! Dictionary<String,AnyObject>
        
        let NewaddressView = self.storyboard?.instantiateViewController(withIdentifier: "NewAddressView") as! NewAddressViewController
//        var receivedName : String?
//        var receivedAddress : String?
//        var receviedAera :String?
//        var receviedPhone : String?
//        var isDefault = "0"
        NewaddressView.receivedName = tmpInfo["name"] as? String
        NewaddressView.receivedAddress = tmpInfo["address"] as? String
        NewaddressView.receviedAera = tmpInfo["district"] as? String
        NewaddressView.receviedPhone = tmpInfo["phone"] as? String
        NewaddressView.isDefault = (tmpInfo["is_default"]?.stringValue)!
        navigationController?.pushViewController(NewaddressView, animated: true)
    }
    
    func getDataAndLoad() -> Void {
        Http.Http_PostInfo(post: url_boot + url_getAddresses, parameters: ConstantDict) { (responseDic) in
            print(responseDic)
            if responseDic["result"] as! NSNumber == 0 {
                if let tmpDic = responseDic["body"] as? Dictionary<String,AnyObject> {
                    if tmpDic["isLogin"] as! NSNumber == 1 {
                        if let addressList = tmpDic["list"] as? NSArray{
                            self.addressinfo = addressList as [AnyObject]
//                            self.appDelegate.SQLiteDb.deleteData(T_SQLITE_ADDRESS_LIST, whereStr: "")
//                            for t in self.addressinfo
//                            {
//                                let tmp = t as! Dictionary<String,AnyObject>
//                                self.appDelegate.SQLiteDb.Insert(tablename: T_SQLITE_ADDRESS_LIST, insertValue: tmp)
//                            }
                            self.addressTable.reloadData()
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
extension AddressViewController : UITableViewDelegate
{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section < addressinfo.count {
            
            if (delegate != nil) {
                delegate?.setAddress(info: addressinfo[indexPath.section] as! Dictionary<String,AnyObject>)
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
}
extension AddressViewController : UITableViewDataSource
{
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10.0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1 + addressinfo.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section < addressinfo.count{
            if indexPath.row == 0 {
                return 60.0
            }
            return 44.0
        }
        return 44.0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if section < addressinfo.count{
            return 2
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        //        creditTop
        if indexPath.section < addressinfo.count {
            let addInfo = self.addressinfo[indexPath.section] as! Dictionary<String,AnyObject>
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "addressCell", for: indexPath)
                let nameLab = cell.contentView.viewWithTag(1) as! UILabel
                
                nameLab.text = "\(addInfo["name"] as! String)   \(addInfo["phone"] as! String)"
                
                let addressLab = cell.contentView.viewWithTag(2) as! UILabel
                
                addressLab.text = addInfo["address"] as? String
                
                if let editBtn = cell.contentView.viewWithTag(3) as? UIButton
                {
                    editBtn.tag = indexPath.section + 1
                    editBtn.addTarget(self, action: #selector(AddressViewController.editAddress(sender:)), for: .touchUpInside)
                }
                
                return cell
            }
            else{
                let cell = tableView.dequeueReusableCell(withIdentifier: "operateCell", for: indexPath)
                var defaultBtn : UIButton?
                if let tmpBtn = cell.contentView.viewWithTag(1) as? UIButton{
                    defaultBtn = tmpBtn
                }else{
                    defaultBtn = cell.contentView.viewWithTag(indexPath.section + 100) as? UIButton
                    
                }
//                if let defaultBtn = cell.contentView.viewWithTag(11) as? UIButton
//                {
//                let defaultBtn = cell.contentView.viewWithTag(1) as! UIButton
                    defaultBtn?.tag = indexPath.section + 100
                    defaultBtn?.addTarget(self, action: #selector(AddressViewController.setDefault(sender:)), for: .touchUpInside)
                    let butImage = UIImage(named: "noselect")
                    let selectImage = UIImage(named: "selected")
                     let isdefaultString = (addInfo["is_default"] as! NSNumber).stringValue
                
                        if isdefaultString == "1"{
                            defaultBtn?.setImage(selectImage, for: .normal)
                            defaultBtn?.setTitleColor(mainColor, for: .normal)
                        }else{
                            defaultBtn?.setImage(butImage, for: .normal)
                            defaultBtn?.setTitleColor(UIColor.gray, for: .normal)
                        }
//                    }
                    
//                }
                
                
//                if
                var deleteBtn : UIButton?
                    if let tbtn = cell.contentView.viewWithTag(2) as? UIButton
                {
                    deleteBtn = tbtn
                    }else{
                     deleteBtn = cell.contentView.viewWithTag(indexPath.section + 1000) as? UIButton
                }
                deleteBtn?.tag = indexPath.section + 1000
                deleteBtn?.addTarget(self, action: #selector(AddressViewController.deleteInfo(sender:)), for: .touchUpInside)
                return cell
            }
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "btnCell", for: indexPath)
            
            let btn = cell.contentView.viewWithTag(1) as! UIButton
            btn.backgroundColor = btnColor
            btn.layer.cornerRadius = 5.0
            btn.layer.masksToBounds = true
            btn.addTarget(self, action: #selector(AddressViewController.newAddress), for: .touchUpInside)
            return cell
        }
    }
    
}
