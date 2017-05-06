//
//  accountViewController.swift
//  yCheng
//
//  Created by De Peng Li on 2017/3/26.
//  Copyright © 2017年 De Peng Li. All rights reserved.
//

import UIKit

class accountViewController: UIViewController {

    @IBOutlet weak var tableview: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "我的账号"
        view.backgroundColor = backColor
        tableview.dataSource = self
        tableview.delegate = self
        tableview.backgroundColor = litColor
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
    }
    
    func verify() -> Void {
        let signStoryBoard = UIStoryboard(name: "sign", bundle: nil)
        let rootViewControler = signStoryBoard.instantiateViewController(withIdentifier: "realityVerifyNav")
        self.present(rootViewControler, animated: true) {
            
        }
    }
    
    
    func modifyPassword() -> Void {
        let signStoryBoard = UIStoryboard(name: "sign", bundle: nil)
        let rootViewControler = signStoryBoard.instantiateViewController(withIdentifier: "ModifyView")
        navigationController?.pushViewController(rootViewControler, animated: true)
    }
    
    func forgotPassword() -> Void {
        let signStoryBoard = UIStoryboard(name: "sign", bundle: nil)
        let rootViewControler = signStoryBoard.instantiateViewController(withIdentifier: "forgetView")
        
        navigationController?.pushViewController(rootViewControler, animated: true)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    func logout() -> Void {
        let logoutDic = ConstantDict
        
        Http.Http_PostInfo(post: url_boot+url_logout, parameters: logoutDic) { (responseDic) in
            print("responseDict:\(responseDic)")

            if responseDic["result"] as! NSNumber == 0 {
                if let body = responseDic["body"] {
                    if let isLogin = body["isLogin"] as? NSNumber{
                        if isLogin == 0 {
                            let defaults = UserDefaults.standard
                            defaults.removeObject(forKey: T_User_password)
                            defaults.removeObject(forKey: T_User_phoneNumber)
                            defaults.removeObject(forKey: T_Token)
                            defaults.removeObject(forKey: T_User_Name)
                            defaults.removeObject(forKey: T_User_Code)
                            defaults.synchronize()
                            self.navigationController?.popViewController(animated: true)
                        }
                    }
                }
            }else{
                Drop.down(responseDic["msg"] as! String, state: .error)
            }
        }
    }
}

extension accountViewController : UITableViewDelegate
{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.setSelected(false, animated: false)
        
        if indexPath.section == 0 && indexPath.row == 0 {
            verify()
        }
        if  indexPath.section == 1 && indexPath.row == 0 {
            modifyPassword()
        }
        if  indexPath.section == 2 && indexPath.row == 0 {
            forgotPassword()
        }
    }
}
extension accountViewController : UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.backgroundColor = UIColor.white
            
            
            
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.backgroundColor = UIColor.white
            
            let lab1 = cell.contentView.viewWithTag(1) as! UILabel
            let lab2 = cell.contentView.viewWithTag(2) as! UILabel
            lab2.text = ""
            
            if indexPath.section == 1 {
                lab1.text = "修改密码"
            }
            if indexPath.section == 2 {
                lab1.text = "忘记密码"
            }
            return cell
        }
        
        
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int
    {
        return 3
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
             return 80.0
        }
        return 10.0
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 2 {
            return 100.0
        }
        return 0.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            let view = UIView(frame: CGRect(x: 0.0, y: 0.0, width: tableView.frame.size.width, height: 80.0))
            view.backgroundColor = litColor
            view.isUserInteractionEnabled = true
            
            let phonelabel = UILabel(frame: CGRect(x: 20.0, y: 25.0, width: tableView.frame.size.width-40, height: 35.0))
            phonelabel.font = UIFont(name: "Arial", size: 20.0)
            phonelabel.textAlignment = .center
            
            
            phonelabel.text = "18616017950".hiddenPhone()
            phonelabel.textColor = UIColor.black
            phonelabel.backgroundColor = UIColor.clear
            phonelabel.layer.cornerRadius = 5.0
            view.addSubview(phonelabel)
            
            
            return view
        }else{
            return nil
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section == 2 {
            let view = UIView(frame: CGRect(x: 0.0, y: 0.0, width: tableView.frame.size.width, height: 100.0))
            view.backgroundColor = litColor
            view.isUserInteractionEnabled = true
            
            
            
            let btn = UIButton(frame: CGRect(x: 20.0, y: 40.0, width: tableView.frame.size.width-40, height: 35.0))
            btn.setTitle("安全退出", for: UIControlState.normal)
            btn.setTitleColor(UIColor.white, for: .normal)
            btn.addTarget(self, action: #selector(accountViewController.logout), for: .touchUpInside)
            btn.backgroundColor = btnColor
            btn.layer.cornerRadius = 5.0
            view.addSubview(btn)
            return view
        }
        else{
            return nil
        }
    }
    
}

