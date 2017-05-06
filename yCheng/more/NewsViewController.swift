//
//  NewsViewController.swift
//  yCheng
//
//  Created by De Peng Li on 2017/4/29.
//  Copyright © 2017年 De Peng Li. All rights reserved.
//

import UIKit

class NewsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var newList : [AnyObject] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor.groupTableViewBackground
        title = "消息中心"
        // Do any additional setup after loading the view.
        getDataAndLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    func getDataAndLoad() -> Void {
        let newDic = ConstantDict

        
        Http.Http_PostInfo(post: url_boot + url_new_category, parameters: newDic) { (responseDic) in
            print(responseDic)
            if responseDic["result"] as! NSNumber == 0 {
                if let tmpDic = responseDic["body"] as? Dictionary<String,AnyObject> {
                    self.newList = tmpDic["list"] as! [AnyObject]
                    self.tableView.reloadData()
                }
            }else{
                Drop.down(responseDic["msg"] as! String, state: .error)
            }
        }
    }

}

extension NewsViewController : UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return newList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell1", for: indexPath)
        let tmpdic = newList[indexPath.row] as? Dictionary<String,AnyObject>
        let lab = cell.contentView.viewWithTag(1) as! UILabel
        lab.text = tmpdic?["name"] as? String
        return cell
        
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

extension NewsViewController : UITableViewDelegate
{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("indexPath:\(indexPath)")
        let cell = tableView.cellForRow(at: indexPath)
        cell?.setSelected(false, animated: false)
        
        let tmpdic = newList[indexPath.row] as? Dictionary<String,AnyObject>
        
        let subView = self.storyboard?.instantiateViewController(withIdentifier: "subView") as! SubNewsViewController
        subView.titleString = tmpdic?["name"] as? String
        subView.info = tmpdic
        navigationController?.pushViewController(subView, animated: true)
    }
}
