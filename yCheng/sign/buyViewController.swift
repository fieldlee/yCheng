//
//  buyViewController.swift
//  yCheng
//
//  Created by De Peng Li on 2017/3/25.
//  Copyright © 2017年 De Peng Li. All rights reserved.
//

import UIKit

class buyViewController: UIViewController {

    @IBOutlet weak var tableview: UITableView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
view.backgroundColor = backColor
        tableview.dataSource = self
        tableview.delegate = self
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

}
extension buyViewController : UITableViewDelegate
{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.setSelected(false, animated: false)
    }
}
extension buyViewController : UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if section == 0 {
            return 1
        }else if section == 1 {
            return 2
        }else{
            return 1
        }
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "amountCell", for: indexPath)
            cell.backgroundColor = UIColor.white
            
            return cell
        }
        else if indexPath.section == 1 {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "payCell", for: indexPath)
                cell.backgroundColor = UIColor.white
                
                return cell
            }else{
                let cell = tableView.dequeueReusableCell(withIdentifier: "cardCell", for: indexPath)
                cell.backgroundColor = UIColor.white
                
                return cell
            }
        }
        else  {
            let cell = tableView.dequeueReusableCell(withIdentifier: "discountCell", for: indexPath)
            cell.backgroundColor = UIColor.white
            return cell
        }
        
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int
    {
        return 3
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 100.0
        }else{
            if section == 1 {
                return 30.0
            }
            return 10.0
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 2 {
            return 80.0
        }
        return 0.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            let view = UIView(frame: CGRect(x: 0.0, y: 0.0, width: tableView.frame.size.width, height: 80.0))
            view.backgroundColor = litColor
            view.isUserInteractionEnabled = true
            
            return view

        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section == 2 {
            let view = UIView(frame: CGRect(x: 0.0, y: 0.0, width: tableView.frame.size.width, height: 100.0))
            view.backgroundColor = litColor
            view.isUserInteractionEnabled = true
            
            let btn = UIButton(frame: CGRect(x: 20.0, y: 40.0, width: tableView.frame.size.width-40, height: 35.0))
            btn.setTitle("完成设置", for: UIControlState.normal)
            btn.setTitleColor(UIColor.white, for: .normal)
            btn.backgroundColor = btnColor
            btn.layer.cornerRadius = 5.0
            view.addSubview(btn)
            return view
        }
        return nil
    }
    
}
