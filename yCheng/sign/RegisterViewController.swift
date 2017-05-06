//
//  RegisterViewController.swift
//  yCheng
//
//  Created by De Peng Li on 2017/4/24.
//  Copyright © 2017年 De Peng Li. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {
    lazy var appDelegate :AppDelegate = {
        return UIApplication.shared.delegate as! AppDelegate
    }()

    @IBOutlet weak var registerTableView: UITableView!
    var phoneFieldText : UITextField?
    var passwordField : UITextField?
    var codeField : UITextField?
    var resentBtn : UIButton?
    var yqCode : UITextField?
    var timer : Timer?
    var secondnum = 59
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "用户注册"
        // Do any additional setup after loading the view.
        registerTableView.delegate = self
        registerTableView.dataSource = self
        
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
//        navigationController?.navigationBar.isHidden = false
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func changeTitle() -> Void {
        secondnum = secondnum - 1
        if secondnum > 0 {
            self.resentBtn?.setTitleColor(UIColor.gray, for: .normal)
            self.resentBtn?.setTitle("\(secondnum)S", for: .normal)
            self.resentBtn?.isEnabled = false
        }else{
            removeTimer()
            secondnum = 59
            self.resentBtn?.setTitleColor(codeBtnColor, for: .normal)
            self.resentBtn?.setTitle("获取验证码", for: .normal)
            self.resentBtn?.isEnabled = true
        }
    }
    func addTimer(){
        let Timers = Timer(timeInterval: 1.0, target: self, selector: #selector(loginViewController.changeTitle), userInfo: nil, repeats:true)
        RunLoop.main.add(Timers, forMode: RunLoopMode.commonModes)
        timer = Timers
    }
    func removeTimer(){
        if let _ = timer {
            timer!.invalidate()
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
    func register() {
        var dict = ConstantDict
        if ((phoneFieldText?.text) != "") && phoneFieldText?.text?.characters.count == 11 {
            if validateMobile(phoneNum: (phoneFieldText?.text)!) {
                dict["mobile"] = (phoneFieldText?.text)!
            }else{
                Drop.down("请输入正确的手机号码", state: .error)
                return
            }
        }else{
            Drop.down("请输入正确的手机号码", state: .error)
            return
        }
        
        if ((passwordField?.text) != nil) && phoneFieldText?.text != "" {
            dict["password"] = passwordField?.text?.MD5()
        }else{
            Drop.down("请输入密码", state: .error)
            return
        }
        if  codeField?.text != "" {
            dict["verifyCode"] = codeField?.text
        }else{
            Drop.down("请输入验证码", state: .error)
            return
        }
        
        print("dict:\(dict)")
        
        
        Http.Http_PostInfo(post: url_boot+url_register, parameters: dict ) { (responseDict) in
            print("responseDict:\(responseDict)")
            
            if responseDict["result"] as! NSNumber == 0 {
                if let body = responseDict["body"] {
                    let defaults = UserDefaults.standard
                    defaults.setValue(self.passwordField?.text, forKey: T_User_password)
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
    
    func getCode() {
        var dict = ConstantDict
        if ((phoneFieldText?.text) != "") && phoneFieldText?.text?.characters.count == 11 {
            if validateMobile(phoneNum: (phoneFieldText?.text)!) {
                dict["mobile"] = (phoneFieldText?.text)!
            }else{
                Drop.down("请输入正确的手机号码", state: .error)
                return
            }
        }else{
            Drop.down("请输入正确的手机号码", state: .error)
            return
        }
        
        print("dict:\(dict)")

        Http.Http_PostInfo(post: url_boot+url_sms_register, parameters: dict ) { (responseDict) in
            print("responseDict:\(responseDict)")
            
            if responseDict["result"] as! NSNumber == 0 {
                Drop.down(responseDict["msg"] as! String, state: .success)
                self.addTimer()
            }else{
                Drop.down(responseDict["msg"] as! String, state: .error)
            }
        }
    }
    
    
    func service()  {
        let protocolView = self.storyboard?.instantiateViewController(withIdentifier: "protocolView")
        self.navigationController?.pushViewController(protocolView!, animated: true)
    }
}

extension RegisterViewController : UITableViewDelegate
{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.setSelected(false, animated: false)
        
    }
}
extension RegisterViewController : UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 5
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 4 {
            return 85.0
        }else{
            return 44.0
        }
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
//        phoneCell
//        yzCell
//        passwordCell
//        yqCell
//        btnCell
        if indexPath.row == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "phoneCell", for: indexPath)
            
            phoneFieldText = cell.contentView.viewWithTag(1) as? UITextField
            return cell
        }else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "yzCell", for: indexPath)
            codeField = cell.contentView.viewWithTag(1) as? UITextField
            resentBtn = cell.contentView.viewWithTag(2) as? UIButton
            resentBtn?.setTitleColor(codeBtnColor, for: .normal)
            resentBtn?.addTarget(self, action: #selector(RegisterViewController.getCode), for: .touchUpInside)
            return cell
        }else if indexPath.row == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "passwordCell", for: indexPath)
            passwordField = cell.contentView.viewWithTag(1) as? UITextField
 
            return cell
        }else if indexPath.row == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "yqCell", for: indexPath)
            yqCode = cell.contentView.viewWithTag(1) as? UITextField
            
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "btnCell", for: indexPath)
            let submitBtn = cell.contentView.viewWithTag(1) as! UIButton
            submitBtn.layer.cornerRadius = 5.0
            submitBtn.layer.masksToBounds = true
            submitBtn.backgroundColor = btnColor
            submitBtn.addTarget(self, action: #selector(RegisterViewController.register), for: .touchUpInside)
            
            
            let xyBtn = cell.contentView.viewWithTag(2) as! UIButton
            
            xyBtn.addTarget(self, action: #selector(RegisterViewController.service), for: .touchUpInside)
            
            return cell
        }

    }
    

    public func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10.0
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10.0
    }
    
    
}
