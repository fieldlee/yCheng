//
//  AreaListTableViewController.swift
//  yCheng
//
//  Created by De Peng Li on 2017/4/19.
//  Copyright © 2017年 De Peng Li. All rights reserved.
//

import UIKit
protocol AreaListDelegate {
    func callbackSetArea(backMsg:String,areaid:String)
}

class AreaListTableViewController: UITableViewController {
    var areaList = [AnyObject]()
    var province :String?
    var city:String?
    var district : String?
    var type = 1
    var delegateArealist : AreaListDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "选择地区"
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
         getDataAndLoad(type: "1" , areaid: "1")
    }

    
    func getDataAndLoad(type:String,areaid : String) -> Void {
        var areaDic = ConstantDict
        areaDic["type"] = type
        areaDic["areaId"] = areaid
        Http.Http_PostInfo(post: url_boot + url_getAreas, parameters: areaDic) { (responseDic) in
            print(responseDic)
            if responseDic["result"] as! NSNumber == 0 {
                if let tmpArr = responseDic["body"] as? NSArray {
                    
                    self.areaList = tmpArr as [AnyObject]
                    self.tableView.reloadData()
                }
            }else{
                Drop.down(responseDic["msg"] as! String, state: .error)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return areaList.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        let textLab = cell.contentView.viewWithTag(1) as! UILabel
        textLab.text = areaList[indexPath.row]["district"] as? String
        cell.accessoryType = .none
        cell.selectionStyle = .none
        return cell
    }
 
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.accessoryType = .checkmark
        
        let tmpareaDic = areaList[indexPath.row] as! Dictionary<String,AnyObject>
        let areaid = tmpareaDic["id"]?.stringValue
        
        if type == 1{
            province = areaList[indexPath.row]["district"] as? String
            type = 2
             getDataAndLoad(type: "\(type)" , areaid: areaid!)
        }else if type == 2 {
            city = areaList[indexPath.row]["district"] as? String
            type = 3
             getDataAndLoad(type: "\(type)" , areaid: areaid!)
        }
        else if type == 3 {
            district = areaList[indexPath.row]["district"] as? String
            
            if delegateArealist != nil {
                delegateArealist?.callbackSetArea(backMsg: province!+city!+district!,areaid: areaid!)
                self.navigationController?.popViewController(animated: true)
            }
            
        }
       
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
