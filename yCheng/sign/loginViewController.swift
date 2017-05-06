//
//  loginViewController.swift
//  yCheng
//
//  Created by De Peng Li on 2017/3/23.
//  Copyright © 2017年 De Peng Li. All rights reserved.
//

import UIKit

class loginViewController: UIViewController {
    lazy var appDelegate :AppDelegate = {
        return UIApplication.shared.delegate as! AppDelegate
    }()
    var phoneFieldText : UITextField?
    var codeFieldText : UITextField?
    var resentBtn : UIButton?
    var timer : Timer?
    var secondnum = 59
    @IBOutlet weak var tableview: UITableView!
    @IBAction func cancel(_ sender: Any) {
        
        let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
        let rootViewControler = mainStoryBoard.instantiateInitialViewController()
        appDelegate.window?.rootViewController = rootViewControler
    }
    
    @IBOutlet weak var registerBtn: UIBarButtonItem!
    @IBAction func pushRegister(_ sender: Any) {
        let registerView = self.storyboard?.instantiateViewController(withIdentifier: "registerView")
        navigationController?.pushViewController(registerView!, animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "用户登录"
        view.backgroundColor = backColor
        // Do any additional setup after loading the view.
        tableview.dataSource = self
        tableview.delegate = self
        tableview.backgroundColor = litColor
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
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
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

    }
    
    override func shouldPerformSegue(withIdentifier identifier: String?, sender: Any?) -> Bool {
        if let ident = identifier {
            if ident == "loginToPassword" {
                return false
            }
        }
        return true
    }
    func passwordLogin()  {
        let passwordView = self.storyboard?.instantiateViewController(withIdentifier: "passwordView")
        self.navigationController?.pushViewController(passwordView!, animated: true)
    }
    func push() -> Void {
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

        if  codeFieldText?.text != "" {
            dict["verifyCode"] = codeFieldText?.text
        }else{
            Drop.down("请输入验证码", state: .error)
            return
        }
        
        print("dict:\(dict)")

        
        Http.Http_PostInfo(post: url_boot+url_login_code, parameters: dict ) { (responseDict) in
            print("responseDict:\(responseDict)")
            
            if responseDict["result"] as! NSNumber == 0 {
                if let body = responseDict["body"] {
                    let defaults = UserDefaults.standard
                  
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
    
    func sendCode() -> Void {
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
        dict["mobile"] = phoneFieldText?.text
        Http.Http_PostInfo(post: url_boot+url_sms_code, parameters: dict ) { (responseDict) in
            print("responseDict:\(responseDict)")
            
            if responseDict["result"] as! NSNumber == 0 {
                Drop.down(responseDict["msg"] as! String, state: .success)
                self.addTimer()
            }else{
                Drop.down(responseDict["msg"] as! String, state: .error)
            }
        }
    }
}

extension loginViewController : UITableViewDelegate
{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.setSelected(false, animated: false)
    }
}
extension loginViewController : UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 2
    }
    
    @available(iOS 2.0, *)
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.backgroundColor = UIColor.white
            phoneFieldText = cell.contentView.viewWithTag(2) as? UITextField
            phoneFieldText?.text =  UserDefaults.standard.string(forKey: T_User_phoneNumber)
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "codeCell", for: indexPath)
            cell.backgroundColor = UIColor.white
            codeFieldText = cell.contentView.viewWithTag(1) as? UITextField
            resentBtn = cell.contentView.viewWithTag(2) as? UIButton
            resentBtn?.setTitleColor(codeBtnColor, for: .normal)
            resentBtn?.addTarget(self, action: #selector(loginViewController.sendCode), for: .touchUpInside)
            return cell
        }
    }
    
    
    @available(iOS 2.0, *)
    public func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50.0
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 120.0
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0.0, y: 0.0, width: tableView.frame.size.width, height: 100.0))
        view.backgroundColor = litColor
        view.isUserInteractionEnabled = true
        
        let btn = UIButton(frame: CGRect(x: 20.0, y: 30.0, width: tableView.frame.size.width-40, height: 35.0))
        btn.setTitle("登录", for: UIControlState.normal)
        btn.addTarget(self, action: #selector(loginViewController.push), for: UIControlEvents.touchUpInside)
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.backgroundColor = btnColor
        btn.layer.cornerRadius = 5.0
        view.addSubview(btn)
        
        
        let passwordloginbtn = UIButton(frame: CGRect(x: view.bounds.size.width - 20 - 90, y: 80.0, width: 90.0, height: 30))
        passwordloginbtn.setTitle("密码登录", for: UIControlState.normal)
        passwordloginbtn.addTarget(self, action: #selector(loginViewController.passwordLogin), for: UIControlEvents.touchUpInside)
        passwordloginbtn.setTitleColor(mainColor, for: .normal)
        passwordloginbtn.backgroundColor = UIColor.clear
        passwordloginbtn.titleLabel?.font = UIFont(name: "Arial", size: 13.0)
        view.addSubview(passwordloginbtn)
        
        return view
    }
    
}
