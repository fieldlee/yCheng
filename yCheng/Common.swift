//
//  Common.swift
//  yCheng
//
//  Created by De Peng Li on 2017/3/20.
//  Copyright © 2017年 De Peng Li. All rights reserved.
//

import Foundation
import UIKit

var isRemeber = false
//let url_boot = "http://localhost:6005"

let url_boot = "http://api.azhongzhi.com/api"
let url_home_image = "/home/imageList.htm"
let url_product_recomment = "/home/product.htm"
let url_product_others = "/home/productList.htm"
let url_my_credit = "/shop/getCredit.htm"
let url_shop_images = "/shop/imageList.htm"
let url_shop_products = "/shop/productList.htm"
let url_my_credit_list = "/shop/creditList.htm"
let url_my_allow_exchange_list = "/shop/myProductList.htm"
let url_product_detail = "/shop/product.htm"
let url_getAreas = "/shop/area.htm"
let url_setDefaultAddress = "/shop/setDefaultAddress.htm"
let url_deleteAddress = "/shop/delAddress.htm"
let url_setAddress = "/shop/setAddress.htm"
let url_getAddresses = "/shop/getAddress.htm"
let url_shop_addOrder = "/shop/addOrder.htm"
let url_product_productInfo = "/product/product.htm"
let url_product_productlist = "/product/productList.htm"

let url_credit_unused = "/coupon/usable.htm"
let url_credit_used = "/coupon/used.htm"
let url_credit_expired = "/coupon/expired.htm"
let url_login_code = "/user/loginMoblie.htm"
let url_my_home = "/my/home.htm"
let url_feedback = "/my/feedback.htm"
let url_submit_order = "/order/addOrder.htm"

let url_my_asset = "/asset/getAsset.htm"

let url_cash_out = "/asset/cashOut.htm"
let url_cash_in = "/asset/cashIn.htm"
let url_order_record = "/order/orderList.htm"
let url_trade_record = "/shop/orderList.htm"
let url_set_money = "/order/setMoney.htm"
let url_get_money = "/order/getMoney.htm"
let url_get_defaultAddress = "/shop/buyAddress.htm"
let url_login = "/user/login.htm"
let url_register = "/user/register.htm"
let url_test = "/api/home"
let url_logout = "/user/logout.htm"
let url_earn_list = "/asset/profitList.htm"
let url_new_category = "/notice/classList.htm"
let url_new_class = "/notice/noticeList.htm"
let url_new_read = "/notice/read.htm"
let url_sms_code = "/sms/login.htm"
let url_sms_register = "/sms/register.htm"
let url_sms_forget = "/sms/forget.htm"
let url_modify_password = "/my/editPassWord.htm"
let url_forget_password = "/my/editPassWord.htm"

let T_Version = "1.0.0"
let T_device_type = "ios"

// 数据表常量表名

let T_SQLITE_IMAGE = "IMAGEINFOTABLE"
let T_SQLITE_PRODUCT = "PRODUCTINFOTABLE"
let T_SQLITE_SHOP_PRODUCTS = "SHOPPRODUCTSINFOTABLE"
let T_SQLITE_EX_SHOP_PRODUCTS = "EXCHANGESHOPPRODUCTSINFOTABLE"
let T_SQLITE_SHOP_IMAGELIST = "SHOPIMAGELISTINFOTABLE"
let T_SQLITE_CREDIT_LIST = "CREDITLISTINFOTABLE"
let T_SQLITE_ADDRESS_LIST = "ADDRESSLISTINFOTABLE"
let T_SQLITE_Ticket_LIST = "TICKETLISTINFOTABLE"
let T_SQLITE_PRODCUT_LIST = "PRODUCTLISTINFOTABLE"
// 常量变量名
let T_Device_Token = "Device_Token"
let T_Accept_Number = "Accept-Number"
let T_Token = "Token"
let T_Default_Token = "1D42D87380C555CDA8E13A1DB233C89D"
let T_Sign = "Sign"
let T_User_Name = "User_Name"
let T_User_Code = "User_Code"
let T_User_phoneNumber = "User_phoneNumber"
let T_User_password = "User_password"
let T_Today_Sign = "today_Sign"
let T_Credit = "my_Credit"
let T_My_Asset = "my_Asset"

let ConstantDict : [String:Any] = ["deviceToken":getDeviceToken ?? "JuShou",
                           "version":T_Version,
                           "deviceType":T_device_type]

let getDeviceToken = { () -> String? in
    let defaults = UserDefaults.standard
    let token = defaults.value(forKey: T_Device_Token) as! String?
    return token
}()

let getToken = { () -> String? in
    let defaults = UserDefaults.standard
    let token = defaults.value(forKey: T_Token) as! String?
    return token
}()

let getisLogin = { () -> Bool in
    let defaults = UserDefaults.standard
    let token = defaults.value(forKey: T_Token) as! String?
    if (token != nil) && token != "" {
        return true
    }else{
        return false
    }
}

let mainColor = UIColor(red: 0/255, green: 158/255, blue: 255/255, alpha: 1.0)

let backColor = UIColor(red: 239/255, green: 240/255, blue: 241/255, alpha: 1.0)

let fontColor = UIColor(red: 51/255, green: 51/255, blue: 51/255, alpha: 1.0)
//204,141,14
let codeBtnColor = UIColor(red: 204/255.0, green: 141/255.0, blue: 14/255.0, alpha: 1.0)

let signColor = UIColor(red: 255/255, green: 144/255, blue: 101/255, alpha: 1.0)

let btnColor = UIColor(red: 248/255, green: 89/255, blue: 72/255, alpha: 1.0)

let yearColor = UIColor(red: 154/255, green: 174/255, blue: 219/255, alpha: 1.0)


let borderColor = UIColor(red: 233/255, green: 233/255, blue: 233/255, alpha: 1.0)

let grayColor = UIColor(red: 153/255, green: 153/255, blue: 153/255, alpha: 1.0)

let simpleFont = UIFont(name: "Arial", size: 12.0)

let litColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1.0)

let usedColor = UIColor(red: 205/255.0, green: 205/255.0, blue: 205/255.0, alpha: 1.0)

let subtractColor = UIColor(red: 255.0/255.0, green: 0.0, blue: 0.0, alpha: 1.0)

let mSubtractColor = UIColor(red: 255.0/255.0, green: 75.0/255.0, blue: 63.0/255.0, alpha: 0.0)

let workingQueue = DispatchQueue(label: "my_queue", attributes: [])

func getFileDicrectry() -> String {
    return NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
}

func saveImageFile(imageName name:String, imageData image:UIImage, Type type:String) -> Void {
    if type.lowercased() == "png" {
        do {
            try UIImagePNGRepresentation(image)?.write(to: URL(fileURLWithPath: getFileDicrectry() + "/\(name).\(type.lowercased())"), options: .atomicWrite)
        }catch{
            
        }
        
    }else{
        do {
            try UIImageJPEGRepresentation(image, 1.0)?.write(to: URL(fileURLWithPath: getFileDicrectry() + "/\(name).\(type.lowercased())"), options: .atomicWrite)
        }catch{
            
        }
        
    }
}
func loadImage(imageName name:String , ofType type:String) -> AnyObject {
    let filePath = getFileDicrectry() + "/\(name).\(type.lowercased())"
    let fileManager = FileManager.default
    if (fileManager.fileExists(atPath: filePath)){
        return UIImage(contentsOfFile: getFileDicrectry() + "/\(name).\(type.lowercased())")!
    }else{
        return UIImage()
    }
    
}


func JSONStringify(_ value: AnyObject,prettyPrinted:Bool = false) -> String{
    
    let options = prettyPrinted ? JSONSerialization.WritingOptions.prettyPrinted : JSONSerialization.WritingOptions(rawValue: 0)
    
    
    if JSONSerialization.isValidJSONObject(value) {
        do{
            let data = try JSONSerialization.data(withJSONObject: value, options: options)
            //            NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8Encoding];
            
            return String(data: data, encoding: String.Encoding.utf8)!
        }catch let error as NSError{
            print("\(error)")
            //Access error here
        }
        
    }
    return ""
}

func StringToJSON(_ data:Data) -> Dictionary<String,AnyObject> {
    
    //    let data = value.dataUsingEncoding(NSUTF8StringEncoding)
    do{
        let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
        
        return (json as? Dictionary<String,AnyObject>)!
    }
    catch let error as NSError{
        print("\(error)")
    }
    return Dictionary()
}

func isExistPath(_ namefile:String) -> (Bool,String) {
    let documentsDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
    let imageSubdirectory = documentsDirectory[0] + ("/"+namefile)
    if !FileManager().fileExists(atPath: imageSubdirectory){
        FileManager().createFile(atPath: imageSubdirectory, contents: nil, attributes: nil)
    }else{
        return (true,imageSubdirectory)
    }
    return (false,imageSubdirectory)
}



func random(_ min:UInt32,max:UInt32)->UInt32{
    return  arc4random_uniform(max-min)+min
}
func randomString(_ len:Int)->String{
    let min:UInt32=97,max:UInt32=122
    var string=""
    for _ in 0..<len{
        string.append(String(describing: UnicodeScalar(random(min,max:max))))
    }
    return string
    
}
extension String {
    var floatValue: Float {
        return (self as NSString).floatValue
    }
}

func validateMobile(phoneNum:String)-> Bool {
    
    // 手机号以 13 14 15 18 开头   八个 \d 数字字符
    
    let phoneRegex = "^((13[0-9])|(17[0-9])|(14[^4,\\D])|(15[^4,\\D])|(18[0-9]))\\d{8}$|^1(7[0-9])\\d{8}$";
    
    let phoneTest = NSPredicate(format: "SELF MATCHES %@" , phoneRegex)
    
    return (phoneTest.evaluate(with: phoneNum));
    
}


extension Int
{
    func hexedString() -> String
    {
        return NSString(format:"%02x", self) as String
    }
}

extension NSData
{
    func hexedString() -> String
    {
        var string = String()
        let unsafePointer = bytes.assumingMemoryBound(to: UInt8.self)
        for i in UnsafeBufferPointer<UInt8>(start:unsafePointer, count: length)
        {
            string += Int(i).hexedString()
        }
        return string
    }
    func MD5() -> NSData
    {
        let result = NSMutableData(length: Int(CC_MD5_DIGEST_LENGTH))!
        let unsafePointer = result.mutableBytes.assumingMemoryBound(to: UInt8.self)
        CC_MD5(bytes, CC_LONG(length), UnsafeMutablePointer<UInt8>(unsafePointer))
        return NSData(data: result as Data)
    }
}

extension String
{
    func MD5() -> String
    {
        let data = (self as NSString).data(using: String.Encoding.utf8.rawValue)! as NSData
        return data.MD5().hexedString()
    }
}
