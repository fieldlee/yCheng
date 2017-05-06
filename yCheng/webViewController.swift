//
//  webViewController.swift
//  yCheng
//
//  Created by De Peng Li on 2017/3/26.
//  Copyright © 2017年 De Peng Li. All rights reserved.
//

import UIKit

class webViewController: UIViewController {

    @IBOutlet weak var webView: UIWebView!
    var url : String?
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.delegate = self
        view.backgroundColor = UIColor.white
        title = "加载中..."
        // Do any additional setup after loading the view.
        
        let urlR = NSURL(string: url!)
        let request = NSURLRequest(url: urlR! as URL)
        webView.loadRequest(request as URLRequest)
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


extension webViewController : UIWebViewDelegate
{
     func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool
     {
        let requestUrl = request.url?.absoluteString

        if requestUrl == "ys://productHome" {
//            查看产品首页
            self.tabBarController?.selectedIndex = 1
            navigationController?.popToRootViewController(animated: true)
            
            return false
        }
        if requestUrl == "ys://assetHome" {
            //            查看产品首页
            self.tabBarController?.selectedIndex = 2
            navigationController?.popToRootViewController(animated: true)
            
            
            return false
        }
        
        if requestUrl == "ys://exchange"{
//            兑换记录
            for tView in (navigationController?.viewControllers)!
            {
                if tView.isKind(of: totalStoreViewController.self){
                    (tView as? totalStoreViewController)?.pushRecord = "1"
                navigationController?.popToViewController(tView, animated: true)
                }
            }
            return false
        }
        
        
        if requestUrl == "ys://shopHome"{
            for tView in (navigationController?.viewControllers)!
            {
                if tView.isKind(of: totalStoreViewController.self){
                  navigationController?.popToViewController(tView, animated: true)
                }
            }
            
            
//            var myCredit : String?
//            let defaults = UserDefaults.standard
//            if let  _ = defaults.string(forKey: T_Credit){
//                myCredit = defaults.string(forKey: T_Credit)
//            }
//            let RecordsView = self.storyboard?.instantiateViewController(withIdentifier: "CreditRecords") as! CreditRecordsViewController
//            RecordsView.myCredit = myCredit
//            //        RecordsView.myCreditList = self.myCreditList
//            navigationController?.pushViewController(RecordsView, animated: true)
            return false
        }
        
        return true
    }
    
    @available(iOS 2.0, *)
    func webViewDidStartLoad(_ webView: UIWebView){
        
    }
    
    @available(iOS 2.0, *)
    func webViewDidFinishLoad(_ webView: UIWebView){
        let titleString = webView.stringByEvaluatingJavaScript(from: "document.title")
        title = titleString
    }
    
    @available(iOS 2.0, *)
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error){
        
    }
}

