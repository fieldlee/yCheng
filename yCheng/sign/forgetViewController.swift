//
//  forgetViewController.swift
//  yCheng
//
//  Created by De Peng Li on 2017/3/23.
//  Copyright © 2017年 De Peng Li. All rights reserved.
//

import UIKit

class forgetViewController: UIViewController {
    var codeField : UITextField?
    var newField : UITextField?
    var resetField : UITextField?
    var resentBtn : UIButton?
    var timer : Timer?
    var secondnum = 59
    @IBAction func resend(_ sender: Any) {
        
    }
    @IBOutlet weak var tableview: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "忘记登录密码"
        view.backgroundColor = backColor
        tableview.dataSource = self
        tableview.delegate = self
        tableview.backgroundColor = litColor
        // Do any additional setup after loading the view.
//        addTimer()
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
        let Timers = Timer(timeInterval: 1.0, target: self, selector: #selector(forgetViewController.changeTitle), userInfo: nil, repeats:true)
        RunLoop.main.add(Timers, forMode: RunLoopMode.commonModes)
        timer = Timers
    }
    func removeTimer(){
        if let _ = timer {
            timer!.invalidate()
        }
    }
    func resentInfomation() -> Void {
        var codeDic = ConstantDict
        let defaults = UserDefaults.standard
        let phoneString = defaults.string(forKey: T_User_phoneNumber)
        codeDic["mobile"] = phoneString
        Http.Http_PostInfo(post: url_boot + url_sms_forget, parameters: codeDic) { (reponseDic) in
            print(reponseDic)
            if reponseDic["result"] as! NSNumber == 0 {
                Drop.down(reponseDic["msg"] as! String, state: .success)
                self.addTimer()
            }else{
                Drop.down(reponseDic["msg"] as! String, state: .error)
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
    func resetPassword() -> Void {
        
        if codeField?.text == "" {
            Drop.down("请输入验证码", state: .error)
            return
        }
        if newField?.text == "" {
            Drop.down("请输入新密码", state: .error)
            return
        }
        if resetField?.text == "" {
            Drop.down("请输入确认密码", state: .error)
            return
        }
        var modifyDic = ConstantDict
        modifyDic["verifyCode"] = codeField?.text
        modifyDic["word"] = newField?.text
        modifyDic["rptWord"] = resetField?.text
        Http.Http_PostInfo(post: url_boot + url_forget_password, parameters: modifyDic) { (reponseDic) in
            print(reponseDic)
            if reponseDic["result"] as! NSNumber == 0 {
                if let tmpDic = reponseDic["body"] as? Dictionary<String,AnyObject> {
                    if tmpDic["isLogin"] as! NSNumber == 1 {
                        let defaults = UserDefaults.standard
                        defaults.setValue(self.newField?.text, forKey: T_User_password)
                        defaults.synchronize()
                        self.navigationController?.popViewController(animated: true)
                    }else{
                        //                        没有登录
                        let signStoryBoard = UIStoryboard(name: "sign", bundle: nil)
                        let rootViewControler = signStoryBoard.instantiateViewController(withIdentifier: "realityVerifyNav")
                        self.present(rootViewControler, animated: true) {
                            
                        }
                    }
                }
            }else{
                Drop.down(reponseDic["msg"] as! String, state: .error)
            }
        }
    }
}



extension forgetViewController : UITableViewDelegate
{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.setSelected(false, animated: false)
    }
}
extension forgetViewController : UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 3
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "yzCell", for: indexPath)
            cell.backgroundColor = UIColor.white
//            cell.isUserInteractionEnabled = false
            codeField = cell.contentView.viewWithTag(2) as? UITextField
            codeField?.isUserInteractionEnabled = true
            
            resentBtn = cell.contentView.viewWithTag(3) as? UIButton
            resentBtn?.setTitleColor(codeBtnColor, for: .normal)
            resentBtn?.addTarget(self, action: #selector(forgetViewController.resentInfomation), for: .touchUpInside)
            
            return cell
        }else if indexPath.row == 1{
            let cell = tableView.dequeueReusableCell(withIdentifier: "passwordCell", for: indexPath)
            cell.backgroundColor = UIColor.white
//            cell.isUserInteractionEnabled = false
            newField = cell.contentView.viewWithTag(2) as? UITextField
            newField?.isUserInteractionEnabled = true
            return cell
        }else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "passwordCell", for: indexPath)
            cell.backgroundColor = UIColor.white
            //            cell.isUserInteractionEnabled = false
            resetField = cell.contentView.viewWithTag(2) as? UITextField
            resetField?.isUserInteractionEnabled = true
            return cell
        }
        
        
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 80.0
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 100.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0.0, y: 0.0, width: tableView.frame.size.width, height: 80.0))
        view.backgroundColor = litColor
        view.isUserInteractionEnabled = true
        
        let phonelabel = UILabel(frame: CGRect(x: 20.0, y: 25.0, width: tableView.frame.size.width-40, height: 35.0))
        phonelabel.font = UIFont(name: "Arial", size: 20.0)
        phonelabel.textAlignment = .center
        
        let defaults = UserDefaults.standard
        let phoneString = defaults.string(forKey: T_User_phoneNumber)
//        defaults.setValue(self.phoneNo, forKey: T_User_phoneNumber)
        phonelabel.text = phoneString?.hiddenPhone()
        phonelabel.textColor = UIColor.black
        phonelabel.backgroundColor = UIColor.clear
        phonelabel.layer.cornerRadius = 5.0
        view.addSubview(phonelabel)
        
        
        let describLabel = UILabel(frame: CGRect(x: 20.0, y: 65.0, width: 160, height: 10.0))
        describLabel.font = UIFont(name: "Arial", size: 12.0)
        describLabel.textAlignment = .left
        describLabel.text = "已向你的手机发送6位验证码"
        describLabel.textColor = UIColor.darkGray
        describLabel.backgroundColor = UIColor.clear
        describLabel.layer.cornerRadius = 5.0
        view.addSubview(describLabel)
        
        return view
        
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0.0, y: 0.0, width: tableView.frame.size.width, height: 100.0))
        view.backgroundColor = litColor
        view.isUserInteractionEnabled = true
        
        
        
        let btn = UIButton(frame: CGRect(x: 20.0, y: 40.0, width: tableView.frame.size.width-40, height: 35.0))
        btn.setTitle("完成设置", for: UIControlState.normal)
        btn.addTarget(self, action: #selector(forgetViewController.resetPassword), for: .touchUpInside)
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.backgroundColor = btnColor
        btn.layer.cornerRadius = 5.0
        view.addSubview(btn)
        return view
    }
    
}

extension String {
    func hiddenPhone() -> String {
        var formatString = ""
        var i = 0
        for character in self.characters{
            i += 1
            
            if i >= 4 && i <= 7{
                formatString += "*"
            }else{
                if i==3 {
                    formatString += String(character)+" "
                }else if i==8 {
                    formatString += " "+String(character)
                }else{
                    formatString += String(character)
                }
            }
        }
        return formatString
    }
}
