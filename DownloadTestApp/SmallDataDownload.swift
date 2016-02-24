//
//  SmallDataDownload.swift
//  DownloadTestApp
//
//  Created by 也许、 on 16/2/24.
//  Copyright © 2016年 K. All rights reserved.
//

import UIKit

class SmallDataDownload: UIViewController,NSURLConnectionDataDelegate {

    let filePath = "http://mp4.68mtv.com/mp46/%E6%9B%BE%E6%98%A5%E5%B9%B4-%E5%8F%AB%E4%BD%A0%E4%B8%80%E5%A3%B0%E8%80%81%E5%A9%86dj%5B68mtv.com%5D.mp4"
    
    var contentLength:Int?
    
    // 存储接收到的二进制数据
    var fileData:NSMutableData?
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = NSURL(string: filePath)
        
        let request = NSURLRequest(URL: url!)
        
        // 定义请求
        NSURLConnection(request: request, delegate: self)
        
    }
    
    // 响应开始
    func connection(connection: NSURLConnection, didReceiveResponse response: NSURLResponse) {
        
        
        let connResponse = response as! NSHTTPURLResponse
        
        self.contentLength = connResponse.allHeaderFields["Content-Length"]?.integerValue
        
        print(contentLength)
        fileData = NSMutableData()
        
        print("响应开始")
    }
    
    // 接收数据
    func connection(connection: NSURLConnection, didReceiveData data: NSData) {
        
        fileData?.appendData(data)
        let present = 1.0 * Float(fileData!.length) / Float(contentLength!)
        
        print(NSString(format: "已下载%.2f%%", present * 100))
    }
    
    // 接收完成
    func connectionDidFinishLoading(connection: NSURLConnection) {
        
        print("下载完成")
        
        let cachePath = NSSearchPathForDirectoriesInDomains(.CachesDirectory, .UserDomainMask, true).last! as NSString
        
        print("沙盒路径------\(cachePath)")
        
        // 文件路径
        let targetPath = cachePath.stringByAppendingPathComponent("music.mp4")
        
        guard let _ = fileData else {
            print("数据为空")
            return
        }
        
        fileData!.writeToFile(targetPath, atomically: true)
        fileData = nil
        
    }
    
    func connection(connection: NSURLConnection, didFailWithError error: NSError) {
        print("连接失败")
    }

}
