//
//  Db.swift
//  ClubHouse
//
//  Created by De Peng Li on 16/9/7.
//  Copyright © 2016年 De Peng Li. All rights reserved.
//

import Foundation
import FMDB
//var logs = [FeedLog]()

class SQLiteManager: NSObject {

    static let sharedManager = SQLiteManager()
    
    let dbQueue: FMDatabaseQueue
    var sqls = [String]()
    override init() {
        
        let documentPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).last! as NSString
        
        let path = documentPath.appendingPathComponent("yCheng.db")
        print("path: \(path)")

        dbQueue = FMDatabaseQueue(path: path)
        
        super.init()
        // 创建数据表
        createTable()
    }
    
    fileprivate func createTable() {
//        image info table
//        {
//            "img_path" = "http://my.image.ezhi.com/201704/58f1d9db15029.jpg";
//            "img_thumb_path" = "http://my.image.ezhi.com/201704/58f1d9db15029_415_178.jpg";
//            "info_url" = 111;
        //            obj =     {
//        id = 0;
//        type = web;
//        url = "http://m.azhongzhi.com";
//    };
//        }
        let sql1 = "CREATE TABLE IF NOT EXISTS \(T_SQLITE_IMAGE) ( id TEXT PRIMARY KEY,item TEXT, img_path TEXT, img_thumb_path TEXT, info_url TEXT,type TEXT,objectId Text)"
        dbQueue.inDatabase { (db) -> Void in
            db?.executeStatements(sql1)
        }
//        推荐产品 和 其他产品
//        "day_no" = 11;
//        id = 8;
//        lowest = 11;
//        "product_name" = "\U4e59\U665f\U77ed\U671f\U5e74\U5316";
//        profit = 11;
//        item = "1"
        let sql2 = "CREATE TABLE IF NOT EXISTS \(T_SQLITE_PRODUCT) ( id TEXT PRIMARY KEY, day_no TEXT, lowest TEXT, product_name TEXT, profit TEXT,item TEXT )"
        dbQueue.inDatabase { (db) -> Void in

            db?.executeStatements(sql2)

        }

        //        "credit": 2222,//所需要积分
//        "id": 19,
//        "product_img": "http://my.image.ezhi.com/201704/58ec30b48e4ef.jpg",//原图
//        "product_name": "2222222",//产品名称
//        "product_thumb_img": "http://my.ima
        let sql3 = "CREATE TABLE IF NOT EXISTS \(T_SQLITE_SHOP_PRODUCTS) ( id TEXT PRIMARY KEY, credit TEXT, product_img TEXT, product_name TEXT, product_thumb_img TEXT )"
        dbQueue.inDatabase { (db) -> Void in
            
            db?.executeStatements(sql3)
            
        }
        
//        T_SQLITE_SHOP_IMAGELIST
//        "img_path": "http://my.image.ezhi.com/201704/58ec7df8ba12d.png",
//        "img_thumb_path": "http://my.image.ezhi.com/201704/58ec7df8ba12d_415_178.png",
//        "info_url": "/product/product.htm?id=1"
        let sql4 = "CREATE TABLE IF NOT EXISTS \(T_SQLITE_SHOP_IMAGELIST) ( id TEXT PRIMARY KEY, img_path TEXT, img_thumb_path TEXT, info_url TEXT)"
        dbQueue.inDatabase { (db) -> Void in
            
            db?.executeStatements(sql4)
            
        }
        
//        {
//            "create_time": "2017-04-10 19:06:18",//时间
//            "credit": 20,//积分变化值
//            "type_name": "注册送积分"//描述
//        }
        let sql5 = "CREATE TABLE IF NOT EXISTS \(T_SQLITE_CREDIT_LIST) ( id TEXT PRIMARY KEY, create_time TEXT, credit TEXT, type_name TEXT)"
        dbQueue.inDatabase { (db) -> Void in
            db?.executeStatements(sql5)
        }
        
        
//   可以兑换的产品列表
        let sql6 = "CREATE TABLE IF NOT EXISTS \(T_SQLITE_EX_SHOP_PRODUCTS) ( id TEXT PRIMARY KEY, credit TEXT, product_img TEXT, product_name TEXT, product_thumb_img TEXT )"
        dbQueue.inDatabase { (db) -> Void in
            db?.executeStatements(sql6)
        }
        
//       地址
        
//        "address": "河北省 邢台 威县 天河小区121号1901",//详细地址
//        "is_default": 1,//是否默认；（1：默认；0：普通）
//        "name": "小李",//联系人
//        "phone": "13100000000"//联系人手机号
        
        //                            "address": "天河小区121号1901",
        //                            "district": "河北省 邢台 威县",

        //                            "name": "小李",
        //                            "phone": "13100000000",
        //                            "sys_district_id": 1231,
        //                            "users_id": 25
        let sql7 = "CREATE TABLE IF NOT EXISTS \(T_SQLITE_ADDRESS_LIST) ( id TEXT PRIMARY KEY, address TEXT,district TEXT, district_id TEXT, is_default TEXT, name TEXT, phone TEXT,sys_district_id TEXT,users_id TEXT )"
        dbQueue.inDatabase { (db) -> Void in
            db?.executeStatements(sql7)
        }
//        "category": "直减券",//优惠券类型文字显示
//        "content": "移动用户专用",//其它说明
//        "coupon_name": "30元直减券",//优惠券名称
//        "coupon_type": 1,//优惠券类型（0：加息券；1：直减券；2：满减券）
//        "coupon_value": 30,//优惠券值（加息时为加息百分比，其它为优惠值）
//        "end_time": "2017-04-20"//过期日期
        let sql8 = "CREATE TABLE IF NOT EXISTS \(T_SQLITE_Ticket_LIST) ( id TEXT PRIMARY KEY, category TEXT,content TEXT, coupon_name TEXT, coupon_type TEXT, coupon_value TEXT,end_time TEXT,type TEXT )"
        dbQueue.inDatabase { (db) -> Void in
            db?.executeStatements(sql8)
        }
        
//        "count": "10",//30天销售数量
//        "day_no": "1",//投资期限
//        "end_time": "2017-04-21",//到期日期
//        "id": 9,//id
//        "lowest": "1",//起购金额
//        "product_name": "新手专享",//产品名称
//        "profit": "1.00",//预期年化收益
//        "start_time": "2017-04-19"//起息日期
        let sql9 = "CREATE TABLE IF NOT EXISTS \(T_SQLITE_PRODCUT_LIST) ( id TEXT PRIMARY KEY, count TEXT,day_no TEXT, end_time TEXT, lowest TEXT, product_name TEXT,profit TEXT,start_time TEXT )"
        dbQueue.inDatabase { (db) -> Void in
            db?.executeStatements(sql9)
        }
    }
    
    func getData(_ tableName:String) -> [AnyObject] {
        let sql = "Select * from \(tableName)"
        
        var results = [AnyObject]()
        
        dbQueue.inDatabase { (db) -> Void in

            let rs = db?.executeQuery(sql, withArgumentsIn: nil)
            if rs != nil {
                let cols = rs?.columnCount()
                while (rs?.next())! {
                    let dic  = NSMutableDictionary()
                    
                    for i in 0...cols!-1
                    {
                        dic.setValue(rs?.string(forColumnIndex: i), forKey: (rs?.columnName(for: i))!)
                    }
                    results.append(dic)
                }
            }

        }
       
        return results
    }
    func deleteData(_ tableName:String,whereStr:String) -> Void {
        //DELETE FROM Person WHERE LastName = 'Wilson'
        var deletesql = ""
        if whereStr == ""  {
            deletesql = "DELETE FROM \(tableName)"
        }
        else{
            deletesql = "DELETE FROM \(tableName) where \(whereStr)"
        }
        dbQueue.inDatabase { (db) -> Void in
            let _ = db?.executeUpdate(deletesql, withArgumentsIn: nil)

        }
        
    }
    func getData(_ tableName:String,whereStr:String) -> [AnyObject] {
        let sql = "Select * from \(tableName) where \(whereStr)"
        
        var results = [AnyObject]()
        
        dbQueue.inDatabase { (db) -> Void in
            
            let rs = db?.executeQuery(sql, withArgumentsIn: nil)
            if rs != nil {
                let cols = rs?.columnCount()
                while (rs?.next())! {
                    let dic  = NSMutableDictionary()
                    
                    for i in 0...cols!-1
                    {
                        dic.setValue(rs?.string(forColumnIndex: i), forKey: (rs?.columnName(for: i))!)
                    }
                    results.append(dic)
                }
            }
            
        }
        
        return results
    }
    
    func Insert(tablename name:String, insertValue dic:Dictionary<String,AnyObject>) {
        // sql
        var tableColumns = ""
        var valueColumns = ""
        var updateColumns = ""
        var updateValueColumns = [String]()
        let keys = dic.keys
        for key in keys {
            
            
            if tableColumns.isEmpty {
                tableColumns = key
            }else{
                tableColumns += " , "+key
            }
            
            let value = dic[key]

            switch value {
            case is NSDictionary:
                
                if valueColumns.isEmpty {
                    valueColumns = "'\(JSONStringify(dic[key]!,prettyPrinted: false)  )'"
                }else{
                    valueColumns += " , '\(JSONStringify(dic[key]!,prettyPrinted: false) )'"
                }
                break
            case is String:
                if valueColumns.isEmpty {
                    valueColumns = "'\(dic[key] as! String)'"
                }else{
                    if dic[key] is String {
                        valueColumns += " , '\(dic[key] as! String)'"
                    }
                    
                }
                break
            case is Int :
                if valueColumns.isEmpty {
                    valueColumns = dic[key] as! String
                }else{
                    if dic[key] is String {
                        valueColumns += " , \(dic[key] as! String)"
                    }else{
                        if dic[key] is NSNumber {
                            valueColumns += " , \((dic[key]?.stringValue)! as String)"
                        }
                        else{
                            valueColumns += " , \(dic[key] as! String)"
                        }
                    }
                }
                break
            default:
                break
            }
            
            
            
//            get update sql conditions
            if key != "id"{
                if updateColumns.isEmpty {
                    updateColumns =  " \(key)=? "
                }else{
                    updateColumns += " , \( key )=? "
                }
                
                if dic[key] is String {
                    updateValueColumns.append(dic[key] as! String)
                    
                }else if (dic[key] is NSNumber){
                    updateValueColumns.append((dic[key]?.stringValue)! as String)
                }
            }
            
        }
        
        dbQueue.inDatabase { (db) -> Void in
            var sql = ""
            var rows = 0
            let rs = db?.executeQuery("select * from \(name) where id = ? ", withArgumentsIn: [dic["id"]!])

            if rs != nil {
                
                while (rs?.next())! {
                    rows += 1
                }
            }
            
            if rows > 0 {
                sql = "UPDATE \(name) SET \(updateColumns) where id = '\(dic["id"]!)'"
//                do {
//                    try db.executeUpdate(sql, values: updateValueColumns)
//                }catch{
//                    
//                }
                print("update : \(sql)");
                db?.executeUpdate(sql, withArgumentsIn: updateValueColumns)

            }else{
                sql = "INSERT INTO \(name) (\(tableColumns)) VALUES (\(valueColumns));"
                print("insert : \(sql)");
                db?.executeStatements(sql)
            }
        }
    }
}
