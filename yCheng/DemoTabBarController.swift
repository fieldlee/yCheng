//
//  DemoTabBarController.swift
//  ClubHouse
//
//  Created by De Peng Li on 16/9/9.
//  Copyright © 2016年 De Peng Li. All rights reserved.
//

import UIKit

class DemoTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
//        delegate = self
//        self.tabBar.isCustomizing
 
//        self.tabBar.barTintColor = UIColor.clearColor()
        // Do any additional setup after loading the view.
        
     let dic = NSDictionary(object: mainColor,forKey:NSForegroundColorAttributeName as NSCopying)
     UITabBarItem.appearance().setTitleTextAttributes(dic as? [String : AnyObject], for: UIControlState.selected)
        
        let items = self.tabBar.items
        for item in items! {
            switch item.tag {
            case 1:
                item.title = "首页"
                var image = UIImage(named: "home")
                image = image?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
            
                item.image = image
                
                var selectImage = UIImage(named: "home_selected")
                selectImage = selectImage?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
                item.selectedImage = selectImage
           
                break
              
            case 2:
                item.title = "产品"
                
                var image = UIImage(named: "products")
                image = image?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
                item.image = image
                
                var selectImage = UIImage(named: "products_selected")
                selectImage = selectImage?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
                item.selectedImage = selectImage
                
                break
            case 3:
                
                
                item.title = "资产"
                
                var image = UIImage(named: "property")
                image = image?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
                item.image = image
                
                var selectImage = UIImage(named: "property_selected")
                selectImage = selectImage?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
                item.selectedImage = selectImage
                
                break
            case 4:
                item.title = "我的"
                
                var image = UIImage(named: "personal-center")
                image = image?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
                item.image = image
                
                var selectImage = UIImage(named: "personal_selected")
                selectImage = selectImage?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
                item.selectedImage = selectImage
                break
            default: break
                
            }
        }
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

//extension DemoTabBarController:UITabBarControllerDelegate
//{
//    func tabBarController(tabBarController: UITabBarController, didSelectViewController viewController: UIViewController)
//    {
//        print("tabBarController:\(tabBarController.selectedIndex)")
//    }
//}
