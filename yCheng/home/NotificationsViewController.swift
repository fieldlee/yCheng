//
//  NotificationsViewController.swift
//  yCheng
//
//  Created by De Peng Li on 2017/3/25.
//  Copyright © 2017年 De Peng Li. All rights reserved.
//

import UIKit

class NotificationsViewController: UIViewController {
    
    @IBOutlet weak var notificationList: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = backColor
        notificationList.delegate = self
        
        notificationList.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
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
extension NotificationsViewController : UITableViewDelegate
{
    
}
extension NotificationsViewController : UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return 1
    }
    
  
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
     {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        return cell
    }
    

     func numberOfSections(in tableView: UITableView) -> Int {
        return 10
    }// Default is 1 if not implemented
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10.0
    }
}
