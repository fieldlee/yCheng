//
//  verifyViewController.swift
//  yCheng
//
//  Created by De Peng Li on 2017/3/23.
//  Copyright © 2017年 De Peng Li. All rights reserved.
//

import UIKit

class verifyViewController: UIViewController {
    @IBOutlet weak var table: UITableView!
    
    @IBAction func leftClick(_ sender: Any) {
        self.dismiss(animated: true) { 
//            
        }
    }
    
    
    func NextToPay() -> Void {
        let buyView = UIStoryboard.init(name: "sign", bundle: nil).instantiateViewController(withIdentifier: "buyView")
        navigationController?.pushViewController(buyView, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "实名认证"
        view.backgroundColor = backColor
        table.delegate = self
        table.dataSource = self
        table.backgroundColor = litColor
        view.backgroundColor = litColor
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "" {
            
        }
        
    }
    
    
}

extension verifyViewController : UITableViewDelegate
{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.setSelected(false, animated: false)
        
    }
}
extension verifyViewController : UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 2
    }
    
    @available(iOS 2.0, *)
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if indexPath.row == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.backgroundColor = UIColor.white
//            let field = cell.contentView.viewWithTag(2) as! UITextField
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "idCell", for: indexPath)
            cell.backgroundColor = UIColor.white
//            let field = cell.contentView.viewWithTag(2) as! UITextField
            return cell
        }
        
    }
    
    
    @available(iOS 2.0, *)
    public func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 100.0
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 100.0
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0.0, y: 0.0, width: tableView.frame.size.width, height: 100.0))
        view.backgroundColor = litColor
        view.isUserInteractionEnabled = true
        let btn = UIButton(frame: CGRect(x: 20.0, y: 30.0, width: tableView.frame.size.width-40, height: 35.0))
        btn.setTitle("下一步", for: UIControlState.normal)
        btn.addTarget(self, action: #selector(verifyViewController.NextToPay), for: .touchUpInside)
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.backgroundColor = btnColor
        btn.layer.cornerRadius = 5.0
        view.addSubview(btn)
        return view
    }
    
}
