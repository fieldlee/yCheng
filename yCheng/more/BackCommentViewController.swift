//
//  BackCommentViewController.swift
//  yCheng
//
//  Created by De Peng Li on 2017/4/20.
//  Copyright © 2017年 De Peng Li. All rights reserved.
//

import UIKit

class BackCommentViewController: UIViewController,UITextViewDelegate {

    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var commentTextView: UITextView!
    
    @IBAction func submit(_ sender: Any) {
        
        var feedbackDic = ConstantDict
        if commentTextView.text == "用着不爽？你来吐槽，我来改进"{
            Drop.down("请输入吐槽", state: .info)
            return
        }
        feedbackDic["content"] = commentTextView.text
        feedbackDic["link"] = phoneTextField.text
        Http.Http_PostInfo(post: url_boot + url_feedback, parameters: feedbackDic) { (responseDic) in
            if responseDic["result"] as! NSNumber == 0 {
                if let tmpDic = responseDic["body"] as? Dictionary<String,AnyObject> {
                    if tmpDic["success"] as! NSNumber == 1 {
                        Drop.down("您的吐槽我已收到，谢谢", state:.success, duration: 1.0, action: {
                            
                        })
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            }else{
                Drop.down(responseDic["msg"] as! String, state: .error)
            }
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "吐个槽"
        // Do any additional setup after loading the view.
        
//        commentTextView.layer.cornerRadius = 5.0
//        commentTextView.layer.masksToBounds = true
//        commentTextView.layer.borderColor = UIColor.lightGray.cgColor
//        commentTextView.layer.borderWidth = 1.0
        commentTextView.delegate = self
        
        
        submitBtn.backgroundColor = btnColor
        submitBtn.layer.cornerRadius = 5.0
        submitBtn.layer.masksToBounds = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    public func textViewShouldBeginEditing(_ textView: UITextView) -> Bool
    {
        if textView.text == "用着不爽？你来吐槽，我来改进"{
            textView.text = ""
            textView.textColor = UIColor.black
        }
        return true
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
