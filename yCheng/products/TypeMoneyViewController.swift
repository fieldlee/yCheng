//
//  TypeMoneyViewController.swift
//  yCheng
//
//  Created by De Peng Li on 2017/4/24.
//  Copyright © 2017年 De Peng Li. All rights reserved.
//

import UIKit

class TypeMoneyViewController: UIViewController {
    var productInfo : Dictionary<String,AnyObject>?
    @IBOutlet weak var moneyTableView: UITableView!
    var buyMoneyField:UITextField?
    var least : Float?
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "填写购买金额"
        if let t = productInfo?["lowest"] as? String{
            least = t.floatValue
        }
        
        // Do any additional setup after loading the view.
        moneyTableView.delegate = self
        moneyTableView.dataSource = self
        moneyTableView.backgroundColor = UIColor.groupTableViewBackground
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func nextStep() {
        if let moneyString = buyMoneyField?.text {
            if moneyString.floatValue >= least! {
                
                var moneyDic = ConstantDict
                moneyDic["product"] = productInfo?["id"]
                moneyDic["money"] = moneyString.floatValue
                
                Http.Http_PostInfo(post: url_boot + url_set_money, parameters: moneyDic, completionHandler: { (responseDic) in
                    print(responseDic)
                    if responseDic["result"] as! NSNumber == 0 {
                        if let tmpDic = responseDic["body"] as? Dictionary<String,AnyObject> {
                            
                            if tmpDic["isLogin"] as! NSNumber == 1 {
                                let payViewController = self.storyboard?.instantiateViewController(withIdentifier: "payView") as? PayViewController
                                payViewController?.payMoney = moneyString.floatValue
                                payViewController?.productInfo = self.productInfo
                                self.navigationController?.pushViewController(payViewController!, animated: true)
                            }
                        }
                    }else{
                        Drop.down(responseDic["msg"] as! String, state: .error)
                    }
                })
                
                
                
                
            }else{
                Drop.down("购买金额必须大于\((least! as NSNumber).stringValue)元", state: .error)
                return
            }
        }else{
            Drop.down("购买金额必须大于\((least! as NSNumber).stringValue)元", state: .error)
            return
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
extension TypeMoneyViewController : UITableViewDelegate
{
    
}
extension TypeMoneyViewController : UITableViewDataSource
{
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10.0
    }
    

    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44.0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "nameCell", for: indexPath)
            let namelAB = cell.contentView.viewWithTag(1) as! UILabel
            namelAB.text = productInfo?["product_name"] as? String
            return cell
            
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "moneyCell", for: indexPath)
            buyMoneyField = cell.contentView.viewWithTag(1) as? UITextField
            
            buyMoneyField?.placeholder = "\((least! as NSNumber).stringValue)元起购"
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 100.0
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0.0, y: 0.0, width: tableView.frame.size.width, height: 100.0))
        view.backgroundColor = litColor
        view.isUserInteractionEnabled = true
        
       let btn = UIButton(frame: CGRect(x: 20.0, y: 40.0, width: tableView.frame.size.width-40, height: 35.0))
        btn.setTitle("下一步", for: UIControlState.normal)
        btn.addTarget(self, action: #selector(TypeMoneyViewController.nextStep), for: .touchUpInside)
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.backgroundColor = btnColor
        btn.layer.cornerRadius = 5.0
        view.addSubview(btn)
        return view
    }
}
