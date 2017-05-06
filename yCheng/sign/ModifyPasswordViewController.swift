//
//  ModifyPasswordViewController.swift
//  yCheng
//
//  Created by De Peng Li on 2017/4/3.
//  Copyright © 2017年 De Peng Li. All rights reserved.
//

import UIKit

class ModifyPasswordViewController: UIViewController {
    var oldPasswordField :UITextField?
    var newPasswordField : UITextField?
    var resetPasswordField : UITextField?
    @IBOutlet weak var tableview: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = backColor
        title = "修改密码"
        tableview.delegate = self
        tableview.dataSource = self
        tableview.backgroundColor = litColor
        // Do any additional setup after loading the view.
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
    func modifyPassword() -> Void {
        
        if oldPasswordField?.text == "" {
            Drop.down("请输入原密码", state: .error)
            return
        }
        if newPasswordField?.text == "" {
            Drop.down("请输入新密码", state: .error)
            return
        }
        if resetPasswordField?.text == "" {
            Drop.down("请输入确认密码", state: .error)
            return
        }
        var modifyDic = ConstantDict
        modifyDic["passWord"] = oldPasswordField?.text
        modifyDic["word"] = newPasswordField?.text
        modifyDic["rptWord"] = resetPasswordField?.text
        Http.Http_PostInfo(post: url_boot + url_modify_password, parameters: modifyDic) { (reponseDic) in
            print(reponseDic)
            if reponseDic["result"] as! NSNumber == 0 {
                if let tmpDic = reponseDic["body"] as? Dictionary<String,AnyObject> {
                    if tmpDic["isLogin"] as! NSNumber == 1 {
                        let defaults = UserDefaults.standard
                        defaults.setValue(self.newPasswordField?.text, forKey: T_User_password)
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

extension ModifyPasswordViewController : UITableViewDelegate
{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.setSelected(false, animated: false)
    }
}
extension ModifyPasswordViewController : UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 3
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell1", for: indexPath)
            cell.backgroundColor = UIColor.white
            //            cell.isUserInteractionEnabled = false
            oldPasswordField = cell.contentView.viewWithTag(2) as? UITextField
            oldPasswordField?.isUserInteractionEnabled = true
            return cell
        }else if indexPath.row == 1{
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell2", for: indexPath)
            cell.backgroundColor = UIColor.white
            //            cell.isUserInteractionEnabled = false
            newPasswordField = cell.contentView.viewWithTag(2) as? UITextField
            newPasswordField?.isUserInteractionEnabled = true
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell3", for: indexPath)
            cell.backgroundColor = UIColor.white
            //            cell.isUserInteractionEnabled = false
            resetPasswordField = cell.contentView.viewWithTag(2) as? UITextField
            resetPasswordField?.isUserInteractionEnabled = true
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
        return 100.0
    }
    
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0.0, y: 0.0, width: tableView.frame.size.width, height: 100.0))
        view.backgroundColor = litColor
        view.isUserInteractionEnabled = true
        
        
        
        let btn = UIButton(frame: CGRect(x: 20.0, y: 40.0, width: tableView.frame.size.width-40, height: 35.0))
        btn.setTitle("确认修改", for: UIControlState.normal)
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.addTarget(self, action: #selector(ModifyPasswordViewController.modifyPassword), for: .touchUpInside)
        btn.backgroundColor = btnColor
        btn.layer.cornerRadius = 5.0
        view.addSubview(btn)
        return view
    }
    
}
