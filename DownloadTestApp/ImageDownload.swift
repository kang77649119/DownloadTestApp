//
//  ImageDownload.swift
//  DownloadTestApp
//
//  Created by 也许、 on 16/2/24.
//  Copyright © 2016年 K. All rights reserved.
//

import UIKit

class ImageDownload: UIViewController {

    // 图片地址
    let imageUrl = "http://img3.douban.com/view/photo/photo/public/p2154674813.jpg"
    
    @IBOutlet weak var imgView: UIImageView!
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 异步下载
        downloadImgWithNSURLConn()
        
        // 同步下载 缺点：线程阻塞
        // downloadImg()
        
    }
    
    /**
     使用NSURLConnection下载
     */
    func downloadImgWithNSURLConn() {
        
        let request = NSURLRequest(URL: NSURL(string: imageUrl)!)
        
        // 异步请求下载数据 不适合下载大文件,因为这种请求会等待数据全部响应后才调用block
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) { (response, data, error) -> Void in
            
            if error == nil && data != nil {
                self.imgView.image = UIImage(data: data!)
            }
            
        }
        
    }
    
    /**
     缺点：不能停止下载，会导致线程阻塞
     */
    func downloadImg() {
        let url = NSURL(string: imageUrl)
        
        let data = NSData(contentsOfURL: url!)
        
        guard let _ = data else {
            print("图片下载失败")
            return
        }
        
        self.imgView.image = UIImage(data: data!)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
