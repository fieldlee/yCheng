//
//  StroeMoneyViewController.swift
//  yCheng
//
//  Created by De Peng Li on 2017/4/28.
//  Copyright © 2017年 De Peng Li. All rights reserved.
//

import UIKit

class StroeMoneyViewController: UIViewController {
    lazy var appDelegate :AppDelegate = {
        return UIApplication.shared.delegate as! AppDelegate
    }()
    @IBOutlet weak var tableview: UITableView!
    var yeNum : Float?
    var savelab :UILabel?
    var banklab :UILabel?
    var moneyTextField :UITextField?
    var money : Float?
    var bankInof : Dictionary<String,AnyObject>?
    override func viewDidLoad() {
        super.viewDidLoad()
        tableview.delegate = self
        tableview.dataSource = self
        tableview.backgroundColor = UIColor.groupTableViewBackground
        title = "我要充值"
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
    func submitMoney() -> Void {
        var moneyDic = ConstantDict
        moneyDic["money"] = moneyTextField?.text
        if moneyTextField?.text == "" {
            
            Drop.down("请输入要充值的金额", state: .error)
            return
        }else{
            if (moneyTextField?.text?.floatValue)! <= Float(0.0) {
                Drop.down("请输入有效的充值金额", state: .error)
                return
            }
        }
        
        
        let alert = UIAlertController(title: "确认", message: "确认要充值\(self.moneyTextField?.text ?? "")元？", preferredStyle: .alert)
        let sureAction = UIAlertAction(title: "确定", style: .default) { (action) in
            Http.Http_PostInfo(post: url_boot+url_cash_in, parameters: moneyDic) { (responseDic) in
                print(responseDic)
                if responseDic["result"] as! NSNumber == 0 {
                    if let tmpDic = responseDic["body"] as? Dictionary<String,AnyObject> {
                        if tmpDic["isLogin"] as! NSNumber == 1 {
                            self.navigationController?.popViewController(animated: true)
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
        
        let cancelAction = UIAlertAction(title: "取消", style: .cancel) { (action) in
            
        }
        alert.addAction(sureAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
}

extension StroeMoneyViewController : UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell1", for: indexPath)
            savelab = cell.contentView.viewWithTag(1) as? UILabel
            if yeNum != nil {
                savelab?.text = "\(yeNum!)元"
            }else{
                savelab?.text = ""
            }
            return cell
        }
        else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell2", for: indexPath)
            banklab = cell.contentView.viewWithTag(1) as? UILabel
            if bankInof != nil {
                
            }else{
                banklab?.text = ""
            }
            return cell
        }else if indexPath.row == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell3", for: indexPath)
            moneyTextField = cell.contentView.viewWithTag(1) as? UITextField
            
            if money != nil {
                moneyTextField?.text = "\(money!)"
            }
            
            return cell
        }else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell4", for: indexPath)
            let submitBtn = cell.contentView.viewWithTag(1) as! UIButton
            submitBtn.backgroundColor = btnColor
            submitBtn.layer.cornerRadius = 5.0
            submitBtn.layer.masksToBounds=true
            submitBtn.addTarget(self, action: #selector(StroeMoneyViewController.submitMoney), for: .touchUpInside)
            return cell
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10.0
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10.0
    }
}
extension StroeMoneyViewController : CardViewControllerDelegate
{
    func selectCard(cardinfo: Dictionary<String, AnyObject>) {
        bankInof = cardinfo
        
        self.navigationController?.popViewController(animated: true)
        tableview.reloadData()
        
    }
}

extension StroeMoneyViewController : UITableViewDelegate
{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("indexPath:\(indexPath)")
        let cell = tableView.cellForRow(at: indexPath)
        cell?.setSelected(false, animated: false)
        if indexPath.row == 1 {
            if moneyTextField?.text != "" {
                money = moneyTextField?.text?.floatValue
            }
            
            let navView = self.storyboard?.instantiateViewController(withIdentifier: "CardView") as? CardViewController
            navView?.delegate = self
            navigationController?.pushViewController(navView!, animated: true)
        }
    }
}
