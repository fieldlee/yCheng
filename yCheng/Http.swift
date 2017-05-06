 //
 //  Http.swift
 //  ClubHouse
 //
 //  Created by De Peng Li on 16/9/6.
 //  Copyright © 2016年 De Peng Li. All rights reserved.
 //
 
 import Foundation
 import AFNetworking
 
 class Http: NSObject {
    class func Http_GetInfo(from url:String,parameters param : Dictionary<String,Any>,completionHandler:@escaping (Dictionary<String,AnyObject>)-> Void) {
        //        ActivityIndicatorView.show()
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 10
        configuration.httpMaximumConnectionsPerHost = 1
        let manager = AFURLSessionManager(sessionConfiguration: configuration)
        let requestManager = AFHTTPRequestSerializer.init()
        requestManager.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        
        let acceptNum = String(Int(Date().timeIntervalSince1970))
        requestManager.setValue(acceptNum, forHTTPHeaderField: T_Accept_Number)
        
        
        if (UserDefaults.standard.value(forKey: T_Token) != nil) {
            let token = UserDefaults.standard.value(forKey: T_Token) as! String
            requestManager.setValue(token, forHTTPHeaderField: T_Token)
        }else{
            requestManager.setValue(T_Default_Token, forHTTPHeaderField: T_Token)
        }
        
        if (UserDefaults.standard.value(forKey: T_Sign) != nil) {
            let sign = UserDefaults.standard.value(forKey: T_Sign) as! String
            requestManager.setValue(sign, forHTTPHeaderField: T_Sign)
        }else{
            requestManager.setValue("test 12345678", forHTTPHeaderField: T_Sign)
        }
        
        let request :NSMutableURLRequest = requestManager.request(withMethod: "GET", urlString: url, parameters: param, error: nil)
        let dataTask : URLSessionDataTask = manager.dataTask(with: request as URLRequest) { (respone, dicObj, error) in
            
            
            guard let responseData = dicObj else {
                //                ActivityIndicatorView.stop()
                print("Error: did not receive data")
                return
            }
            guard error == nil else {
                //                ActivityIndicatorView.stop()
                print(error ?? "")
                return
            }
            // parse the result as JSON, since that's what the API provides
            
            if responseData is Dictionary<String,AnyObject>
            {
                completionHandler(responseData as! Dictionary<String, AnyObject>)
            }
            //            ActivityIndicatorView.stop()
            //            let post: NSDictionary
            //            do {
            //                post = try NSJSONSerialization.JSONObjectWithData(responseData as! NSData, options: []) as! NSDictionary
            //                completionHandler(post as! Dictionary<String, AnyObject>)
            //            } catch  {
            //                print("error trying to convert data to JSON")
            //                return
            //            }
            
        }
        
        AFNetworkActivityIndicatorManager.shared().isEnabled = true
        
        dataTask.resume()
    }
    
    
    class func Http_PostInfo(post url:String, parameters param : Any,completionHandler:@escaping (Dictionary<String,AnyObject>)->Void)  {
        //        ActivityIndicatorView.show()
        let configuration = URLSessionConfiguration.default
//        configuration.timeoutIntervalForRequest = 6
//        configuration.httpMaximumConnectionsPerHost = 1
        let manager = AFURLSessionManager(sessionConfiguration: configuration)
        
        let requestManager = AFHTTPRequestSerializer.init()
        
        requestManager.setValue("application/x-www-form-urlencoded",forHTTPHeaderField: "Content-Type")
        let acceptNum = String(Int(Date().timeIntervalSince1970))
        requestManager.setValue(acceptNum, forHTTPHeaderField: T_Accept_Number)
            print(acceptNum)
        
        if (UserDefaults.standard.value(forKey: T_Token) != nil) {
            let token = UserDefaults.standard.value(forKey: T_Token) as! String
            requestManager.setValue(token, forHTTPHeaderField: T_Token)
        }else{
            
            requestManager.setValue(T_Default_Token, forHTTPHeaderField: T_Token)
        }
        
        if (UserDefaults.standard.value(forKey: T_Sign) != nil) {
            let sign = UserDefaults.standard.value(forKey: T_Sign) as! String
            requestManager.setValue(sign, forHTTPHeaderField: T_Sign)
        }else{
            requestManager.setValue("test 12345678", forHTTPHeaderField: T_Sign)
        }
        
        let request :NSMutableURLRequest = requestManager.request(withMethod: "POST", urlString: url, parameters: param, error: nil)
        print("url:\(url)")
        print("param:\(param)")
        let dataTask : URLSessionDataTask = manager.dataTask(with: request as URLRequest) { (respone, dicObj, error) in
            guard let responseData = dicObj else {
                //                ActivityIndicatorView.stop()
                Drop.down("Error: did not receive data!", state: .error)
                print("Error: did not receive data")
                return
            }
            guard error == nil else {
                //                ActivityIndicatorView.stop()
                Drop.down("unkown error", state: .error)
                print(error ?? "")
                return
            }
            // parse the result as JSON, since that's what the API provides
            //            let post: NSDictionary
            //            do {
            //                post = try NSJSONSerialization.JSONObjectWithData(responseData as! NSData, options: []) as! NSDictionary
            //                completionHandler(post as! Dictionary<String, AnyObject>)
            //            } catch  {
            //                print("error trying to convert data to JSON")
            //                return
            //            }
            if responseData is Dictionary<String, AnyObject>
            {
                completionHandler(responseData as! Dictionary<String, AnyObject>)
            }
            //            ActivityIndicatorView.stop()
        }
        dataTask.resume()
    }
    
    class func Http_UploadFile(uploadUrl url : String,filePath path:String,completionHandler:@escaping (Dictionary<String,AnyObject>)->Void)  {
        //        ActivityIndicatorView.show()
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 10
        configuration.httpMaximumConnectionsPerHost = 1
        let manager = AFURLSessionManager(sessionConfiguration: configuration)
        let request = URLRequest(url: URL(string: url)!)
        let filePath = URL(fileURLWithPath: path)
        
        let uploadTask = manager.uploadTask(with: request, fromFile: filePath, progress: { (progress) in
            
        }) { (respone, dicObject, err) in
            guard let responseData = dicObject else {
                //                    ActivityIndicatorView.stop()
                print("Error: did not receive data")
                return
            }
            guard err == nil else {
                //                    ActivityIndicatorView.stop()
                print(err ?? "")
                return
            }
            // parse the result as JSON, since that's what the API provides
            let post: NSDictionary
            do {
                post = try JSONSerialization.jsonObject(with: responseData as! Data, options: []) as! NSDictionary
                completionHandler(post as! Dictionary<String, AnyObject>)
            } catch  {
                print("error trying to convert data to JSON")
                return
            }
            //                ActivityIndicatorView.stop()
        }
        
        uploadTask.resume()
    }
    
    class func Http_UploadFile(uploadUrl url : String,fileData data:Data,completionHandler:@escaping (Dictionary<String,AnyObject>)->Void) {
        
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 10
        configuration.httpMaximumConnectionsPerHost = 1
        let manager = AFURLSessionManager(sessionConfiguration: configuration)
        let request = URLRequest(url: URL(string: url)!)
        let uploadTask = manager.uploadTask(with: request, from: data, progress: { (progress) in
            
        }) { (re, dicObject, err) in
            guard let responseData = dicObject else {
                print("Error: did not receive data")
                return
            }
            guard err == nil else {
                print(err ?? "")
                return
            }
            // parse the result as JSON, since that's what the API provides
            let post: NSDictionary
            do {
                post = try JSONSerialization.jsonObject(with: responseData as! Data, options: []) as! NSDictionary
                completionHandler(post as! Dictionary<String, AnyObject>)
            } catch  {
                print("error trying to convert data to JSON")
                return
            }
        }
        uploadTask.resume()
    }
 }
