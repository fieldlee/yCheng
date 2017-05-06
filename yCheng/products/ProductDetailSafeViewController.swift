//
//  ProductDetailSafeViewController.swift
//  yCheng
//
//  Created by De Peng Li on 2017/4/21.
//  Copyright © 2017年 De Peng Li. All rights reserved.
//

import UIKit

class ProductDetailSafeViewController: UIViewController {
    var productInfo : Dictionary<String,AnyObject>?
    var textView : UITextView?
    override func viewDidLoad() {
        super.viewDidLoad()
        title = productInfo?["product"]?["product_name"] as? String
        textView = view.viewWithTag(1) as? UITextView
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
