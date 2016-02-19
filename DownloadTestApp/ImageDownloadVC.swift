//
//  ImageDownloadVC.swift
//  DownloadTestApp
//
//  Created by 也许、 on 16/2/17.
//  Copyright © 2016年 K. All rights reserved.
//

import UIKit

class ImageDownloadVC: UIViewController {
    
    // 图片地址
    let imageUrl = "http://img3.douban.com/view/photo/photo/public/p2154674813.jpg"
    
    @IBOutlet weak var imgView: UIImageView!

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
