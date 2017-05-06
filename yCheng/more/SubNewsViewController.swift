//
//  SubNewsViewController.swift
//  yCheng
//
//  Created by De Peng Li on 2017/4/29.
//  Copyright © 2017年 De Peng Li. All rights reserved.
//

import UIKit

class SubNewsViewController: UIViewController {
    var titleString : String?
    var info : Dictionary<String,AnyObject>?
    var list :[AnyObject] = []
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        title = titleString
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor.groupTableViewBackground
        getDataAndLoad()
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
    func getDataAndLoad() {
        var feedbackDic = ConstantDict
        feedbackDic["noticeClass"] = info?["id"]
        feedbackDic["page"] = 1
        
        Http.Http_PostInfo(post: url_boot + url_new_class, parameters: feedbackDic) { (responseDic) in
            print(responseDic)
            if responseDic["result"] as! NSNumber == 0 {
                if let tmpDic = responseDic["body"] as? Dictionary<String,AnyObject> {
                    self.list = tmpDic["list"] as! [AnyObject]
                    self.tableView.reloadData()
                }
            }else{
                Drop.down(responseDic["msg"] as! String, state: .error)
            }
        }

    }
}

extension SubNewsViewController : UITableViewDataSource
{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70.0
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let dic = list[indexPath.row] as? Dictionary<String,AnyObject>
        let label = cell.contentView.viewWithTag(1) as! UILabel
        label.text = dic?["msgContent"] as? String
        let Timelabel = cell.contentView.viewWithTag(2) as! UILabel
        Timelabel.text = dic?["createTime"] as? String
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

extension SubNewsViewController : UITableViewDelegate
{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("indexPath:\(indexPath)")
        let cell = tableView.cellForRow(at: indexPath)
        cell?.setSelected(false, animated: false)
        
    }
}
