//
//  passwordViewController.swift
//  yCheng
//
//  Created by De Peng Li on 2017/3/23.
//  Copyright © 2017年 De Peng Li. All rights reserved.
//

import UIKit

class passwordViewController: UIViewController {
    
    lazy var appDelegate :AppDelegate = {
        return UIApplication.shared.delegate as! AppDelegate
    }()
    
    @IBOutlet weak var tableview: UITableView!
    
    var phoneNo : String?
    var phoneFieldText : UITextField?
    var passwordFieldText : UITextField?
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "登录密码"
        view.backgroundColor = backColor
        // Do any additional setup after loading the view.
        tableview.dataSource = self
        tableview.delegate = self
        tableview.backgroundColor = litColor
        // Do any additional setup after loading the view.
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func pushForgetView() -> Void {

        let storyBoard = UIStoryboard.init(name: "sign", bundle: nil)
        let passwordView = storyBoard.instantiateViewController(withIdentifier: "forgetView")
        //        let passwordView = passwordViewController()
        navigationController?.pushViewController(passwordView, animated: true)
    }
    
    func login() -> Void {
        
        var dict = ConstantDict

//        phoneFieldText
        if ((phoneFieldText?.text) != nil) && phoneFieldText?.text?.characters.count == 11 {
            if validateMobile(phoneNum: (phoneFieldText?.text)!) {
                dict["mobile"] = (phoneFieldText?.text)!
            }else{
                Drop.down("请输入正确的手机号码", state: .error)
                return
            }
        }
        if ((passwordFieldText?.text) != nil) && passwordFieldText?.text != "" {
            dict["password"] = passwordFieldText?.text?.MD5()
        }else{
            Drop.down("请输入密码", state: .error)
            return
        }
//        dict["verifyCode"] = "1234"
        print("dict:\(dict)")
        

        Http.Http_PostInfo(post: url_boot+url_login, parameters: dict ) { (responseDict) in
            print("responseDict:\(responseDict)")
            
            if responseDict["result"] as! NSNumber == 0 {
                if let body = responseDict["body"] {
                    let defaults = UserDefaults.standard
                    defaults.setValue(self.passwordFieldText?.text, forKey: T_User_password)
                    defaults.setValue(self.phoneFieldText?.text, forKey: T_User_phoneNumber)
                    defaults.setValue(body["token"]!, forKey: T_Token)
                    defaults.setValue(body["user_name"]!, forKey: T_User_Name)
                    defaults.setValue(body["user_code"]!, forKey: T_User_Code)
                    defaults.synchronize()
                    
                    let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
                    let rootViewControler = mainStoryBoard.instantiateInitialViewController()
                    self.appDelegate.window?.rootViewController = rootViewControler
                }
            }else{
                Drop.down(responseDict["msg"] as! String, state: .error)
            }
        }

    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "passwordToForget" {
            return 
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String?, sender: Any?) -> Bool {
        if let ident = identifier {
            if ident == "passwordToForget" {
                return false
            }
        }
        return true
    }
}

extension passwordViewController : UITableViewDelegate
{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.setSelected(false, animated: false)
    }
}
extension passwordViewController : UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 2
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "phoneCell", for: indexPath)
            cell.backgroundColor = UIColor.white
            
            phoneFieldText = cell.contentView.viewWithTag(1) as? UITextField
            phoneFieldText?.isUserInteractionEnabled = true
            let defaults = UserDefaults.standard
            phoneFieldText?.text = defaults.value(forKey: T_User_phoneNumber) as? String
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.backgroundColor = UIColor.white
            //        cell.isUserInteractionEnabled = false
            passwordFieldText = cell.contentView.viewWithTag(2) as? UITextField
            passwordFieldText?.isUserInteractionEnabled = true
            let defaults = UserDefaults.standard
            passwordFieldText?.text = defaults.value(forKey: T_User_password) as? String
            return cell
        }
        
        
    }

    public func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50.0
    }
    
    
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let view = UIView(frame: CGRect(x: 0.0, y: 0.0, width: tableView.frame.size.width, height: 80.0))
//        view.backgroundColor = litColor
//        view.isUserInteractionEnabled = true
//        
//        let phonelabel = UILabel(frame: CGRect(x: 20.0, y: 30.0, width: tableView.frame.size.width-40, height: 30.0))
//        phonelabel.font = UIFont(name: "Arial", size: 20.0)
//        phonelabel.textAlignment = .center
//        
//
//        phonelabel.text = "18616017950".convertPhone()
//        phonelabel.textColor = UIColor.black
//        phonelabel.backgroundColor = UIColor.clear
//        phonelabel.layer.cornerRadius = 5.0
//        view.addSubview(phonelabel)
//        return view
//
//    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 100.0
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0.0, y: 0.0, width: tableView.frame.size.width, height: 100.0))
        view.backgroundColor = litColor
        view.isUserInteractionEnabled = true
        
        let forgetLabel = UILabel(frame: CGRect(x: tableView.frame.size.width - 20 - 100, y: 10.0, width: 100, height: 20.0))
        forgetLabel.textColor = UIColor.blue
        forgetLabel.textAlignment = .right
        forgetLabel.text = "忘记密码"
        forgetLabel.font = UIFont(name: "Arial", size: 13.0)
        forgetLabel.isUserInteractionEnabled = true
        let gesture = UITapGestureRecognizer(target: self, action: #selector(passwordViewController.pushForgetView))
        forgetLabel.addGestureRecognizer(gesture)
        view.addSubview(forgetLabel)
        
        let btn = UIButton(frame: CGRect(x: 20.0, y: 40.0, width: tableView.frame.size.width-40, height: 35.0))
        btn.setTitle("登录", for: UIControlState.normal)
        btn.addTarget(self, action: #selector(passwordViewController.login), for: .touchUpInside)
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.backgroundColor = btnColor
        btn.layer.cornerRadius = 5.0
        view.addSubview(btn)
        return view
    }
    
}

extension String {
    func convertPhone() -> String {
        var formatString = ""
        var i = 0
        for character in self.characters{
            i += 1
            
            if i == 3 || i == 7{
                formatString += String(character) + " "
            }else{
                formatString += String(character)
            }
        }
        return formatString
    }
}
