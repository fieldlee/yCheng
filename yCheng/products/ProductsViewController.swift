//
//  ProductsViewController.swift
//  yCheng
//
//  Created by De Peng Li on 2017/3/21.
//  Copyright © 2017年 De Peng Li. All rights reserved.
//

import UIKit

class ProductsViewController: UIViewController {
    var Products = [AnyObject]()
    var cellColor : UIColor?
    @IBOutlet weak var productCollectionView: UICollectionView!
 
    @IBOutlet weak var flowLayout: LNICoverFlowLayout!
    var originalItemSize : CGSize?
    var originalCollectionViewSize :CGSize?
    lazy var appDelegate :AppDelegate = {
        return UIApplication.shared.delegate as! AppDelegate
    }()

    var curProduct : Dictionary<String,AnyObject>?
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "产品"
        view.backgroundColor = backColor
        // Do any additional setup after loading the view.
        self.Products = self.appDelegate.SQLiteDb.getData(T_SQLITE_PRODCUT_LIST)

        
        productCollectionView.delegate = self
        productCollectionView.dataSource = self
        productCollectionView.isPagingEnabled = true
        productCollectionView.showsHorizontalScrollIndicator=false
        productCollectionView.showsVerticalScrollIndicator = false
//        productCollectionView.isPagingEnabled = true
        productCollectionView.backgroundColor = UIColor.groupTableViewBackground
        
        originalItemSize = flowLayout.itemSize
        originalCollectionViewSize = productCollectionView.bounds.size
        
        getDataAndLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(2 * NSEC_PER_SEC)) / Double(NSEC_PER_SEC)) {
            self.productCollectionView.reloadData()
        }

    }

//    -(void)layoutSubviews {
//    [super layoutSubviews];
//    self.collectionView.bounds = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height -20);
//    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        flowLayout.invalidateLayout()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        productCollectionView.bounds.size = CGSize(width: view.bounds.size.width, height: view.bounds.height - 64.0 - 44.0)
        
        flowLayout.itemSize = CGSize(width: productCollectionView.bounds.size.width * (originalItemSize?.width)!/(originalCollectionViewSize?.width)!, height: productCollectionView.bounds.size.height * (originalItemSize?.height)! / (originalCollectionViewSize?.height)!)
        
        print(flowLayout.itemSize)
        
        setInitialValues()
        
        
//
        
        productCollectionView.setNeedsLayout()
        productCollectionView.layoutIfNeeded()
        productCollectionView.reloadData()
        
//        if Products.count >  0 {
//            let indexPath = NSIndexPath(item: 500*Products.count, section: 0)
//            productCollectionView.scrollToItem(at: indexPath as IndexPath, at: UICollectionViewScrollPosition.centeredHorizontally, animated: false)
//        }
    }
 
    
    fileprivate func setInitialValues() {
        flowLayout.maxCoverDegree = 45
        flowLayout.coverDensity = 0.05
        flowLayout.minCoverScale = 0.8
        flowLayout.minCoverOpacity = 0.8
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem

        if let cell = sender as? ProductCollectionViewCell{
            let index = productCollectionView.indexPath(for: cell)
            let tmpProduct = Products[(index?.row)! % Products.count] as! Dictionary<String,AnyObject>
            if let productDetailView =  segue.destination as? ProductDetailViewController {
                productDetailView.productInfo = tmpProduct
            }
        }
        
        
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
        Http.Http_PostInfo(post: url_boot + url_product_productlist, parameters: ConstantDict) { (responseDic) in
            print(responseDic)
            if responseDic["result"] as! NSNumber == 0 {
                if let tmpdic = responseDic["body"] as? Dictionary<String,AnyObject> {
                    self.cellColor = UIColor.colorWithHexString(hex: tmpdic["bgColor"] as! String)
                    self.productCollectionView.backgroundColor = self.cellColor
                    self.view.backgroundColor = self.cellColor
//                    self.view.backgroundColor =
                    if let tmpArr = tmpdic["list"] as? [AnyObject] {
                        self.Products = tmpArr as [AnyObject]
                        self.appDelegate.SQLiteDb.deleteData(T_SQLITE_PRODCUT_LIST, whereStr: "")
                        for t in self.Products
                        {
                            self.appDelegate.SQLiteDb.Insert(tablename: T_SQLITE_PRODCUT_LIST, insertValue: t as! Dictionary<String, AnyObject>)
                        }
                        self.productCollectionView.reloadData()
                    }
                    
                }
            }else{
                Drop.down(responseDic["msg"] as! String, state: .error)
            }
        }
    }
    
}
extension ProductsViewController : UICollectionViewDataSource
{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CarouselCollectionViewCell", for: indexPath) as! ProductCollectionViewCell
        
        cell.layer.cornerRadius = 5.0
        cell.layer.masksToBounds = true
        cell.layer.borderColor = UIColor.lightGray.cgColor
        cell.layer.borderWidth = 0.5
        cell.backgroundColor = UIColor.white
        
        let tmpProduct = Products[indexPath.row % Products.count] as! Dictionary<String,AnyObject>
        //        "count": "10",//30天销售数量
        //        "day_no": "1",//投资期限
        //        "end_time": "2017-04-21",//到期日期
        //        "id": 9,//id
        //        "lowest": "1",//起购金额
        //        "product_name": "新手专享",//产品名称
        //        "profit": "1.00",//预期年化收益
        //        "start_time": "2017-04-19"//起息日期
        let nameLab = cell.contentView.viewWithTag(1) as! UILabel
        
        let numLab = cell.contentView.viewWithTag(2) as! UILabel
        let descripeLab = cell.contentView.viewWithTag(3) as! UILabel
        
        
        
        let countstr = "最近30天已经有\(tmpProduct["count"] as? String ?? "")人购买该系列产品"
        let attcount = NSMutableAttributedString(string: countstr)
        
        attcount.addAttributes([NSForegroundColorAttributeName:UIColor.black], range: NSMakeRange(0, 8))
        attcount.addAttributes([NSForegroundColorAttributeName:UIColor.red], range: NSMakeRange(8, countstr.characters.count-16))
        attcount.addAttributes([NSForegroundColorAttributeName:UIColor.black], range: NSMakeRange(countstr.characters.count-8, 8))
        descripeLab.attributedText = attcount

        
        
        
        let mjBtn = cell.contentView.viewWithTag(4) as! UIButton
        let zjBtn = cell.contentView.viewWithTag(5) as! UIButton
        let jxBtn = cell.contentView.viewWithTag(6) as! UIButton
        mjBtn.layer.cornerRadius = 2.0
        mjBtn.layer.masksToBounds = true
        mjBtn.layer.borderColor = UIColor.gray.cgColor
        mjBtn.layer.borderWidth = 0.5
        zjBtn.layer.cornerRadius = 2.0
        zjBtn.layer.masksToBounds = true
        zjBtn.layer.borderColor = UIColor.gray.cgColor
        zjBtn.layer.borderWidth = 0.5
        jxBtn.layer.cornerRadius = 2.0
        jxBtn.layer.masksToBounds = true
        jxBtn.layer.borderColor = UIColor.gray.cgColor
        jxBtn.layer.borderWidth = 0.5
        let qxLab = cell.contentView.viewWithTag(7) as! UILabel
        let qixiLab = cell.contentView.viewWithTag(8) as! UILabel
        let qgLab = cell.contentView.viewWithTag(9) as! UILabel
        let dqLab = cell.contentView.viewWithTag(10) as! UILabel
        
        
        
        nameLab.text = tmpProduct["product_name"] as? String
//        numLab.text =  tmpProduct["profit"] as? String
        if let profit = tmpProduct["profit"] as? String {
            
            let numstr = "\(String(format: "%.2f", profit.floatValue))%"
            
            let att = NSMutableAttributedString(string: numstr)
            
            att.addAttributes([NSFontAttributeName:UIFont(name: "Arial", size: 30.0) ?? ""], range: NSMakeRange(0, numstr.characters.count-1))
            
            att.addAttributes([NSFontAttributeName:UIFont(name: "Arial", size: 15.0) ?? ""], range: NSMakeRange(numstr.characters.count-1, 1))
            numLab.attributedText = att
        }
//        let profit = tmpProduct["profit"] as! Float
       
        
        
        qxLab.text = "\(tmpProduct["day_no"] as? String ?? "")天"
        qixiLab.text = tmpProduct["start_time"] as? String
        qgLab.text = "\(tmpProduct["lowest"] as? String ?? "")元"
        
        dqLab.text = tmpProduct["end_time"] as? String
        
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollView.contentOffset = CGPoint(x: scrollView.contentOffset.x, y: 0.0)
    }
    

    
}
extension ProductsViewController : UICollectionViewDelegateFlowLayout
{
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
//    {
//        return CGSize(width: view.bounds.width - 80 , height: collectionView.bounds.size.height - 20)
//    }
}
extension ProductsViewController : UICollectionViewDelegate
{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

    }
}

extension UIColor {
    
    /**
     Make color with hex string
     - parameter hex: 16进制字符串
     - returns: RGB
     */
    static func colorWithHexString (hex: String) -> UIColor {
        
        var cString: String = hex.uppercased()
        
        if (cString.hasPrefix("#")) {
            cString = (cString as NSString).substring(from: 1)
        }
        
        if (cString.characters.count != 6) {
            return UIColor.gray
        }
        
        let rString = (cString as NSString).substring(to: 2)
        let gString = ((cString as NSString).substring(from: 2) as NSString).substring(to: 2)
        let bString = ((cString as NSString).substring(from: 4) as NSString).substring(to: 2)
        
        var r:CUnsignedInt = 0, g:CUnsignedInt = 0, b:CUnsignedInt = 0;
        Scanner(string: rString).scanHexInt32(&r)
        Scanner(string: gString).scanHexInt32(&g)
        Scanner(string: bString).scanHexInt32(&b)
        
        return UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: CGFloat(1))
    }
}
