//
//  CardViewController.swift
//  yCheng
//
//  Created by De Peng Li on 2017/4/3.
//  Copyright © 2017年 De Peng Li. All rights reserved.
//

import UIKit
protocol CardViewControllerDelegate {
    func selectCard(cardinfo:Dictionary<String,AnyObject>)
}
class CardViewController: UIViewController {

    @IBOutlet weak var tableview: UITableView!
    var delegate : CardViewControllerDelegate?
    var cardsinfo : [AnyObject]?
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "银行卡"
        // Do any additional setup after loading the view.
        tableview.dataSource = self
        tableview.delegate = self
        self.cardsinfo?.append("" as AnyObject)
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

extension CardViewController : UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 7
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let backView = cell.contentView.viewWithTag(1) as! UIView
        let imageView = cell.contentView.viewWithTag(2) as! UIImageView
        let nameLabel = cell.contentView.viewWithTag(3) as! UILabel
        let noLable = cell.contentView.viewWithTag(4) as! UILabel
        
        backView.backgroundColor  = UIColor.red
        backView.layer.cornerRadius = 5.0
        
        
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}

extension CardViewController : UITableViewDelegate
{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.setSelected(false, animated: false)
        
        //        if indexPath.row == 1 {
        //            let webView = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "webView")
        //            navigationController?.pushViewController(webView, animated: true)
        //        } CardView
        
        
        if (delegate != nil) {
            delegate?.selectCard(cardinfo: cardsinfo?[indexPath.row] as! Dictionary<String, AnyObject>)
        }
        
        if indexPath.row == 0 {
            
        }else if indexPath.row == 1 {
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 80.0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        return 10.0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat
    {
        //        if section == 2 {
        //            return 0.0
        //        }
        return 0.0
    }
}
