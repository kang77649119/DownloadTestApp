//
//  SmallDataDownloadVC.swift
//  DownloadTestApp
//
//  Created by 也许、 on 16/2/17.
//  Copyright © 2016年 K. All rights reserved.
//

import UIKit

class SmallDataDownloadVC: UIViewController,NSURLConnectionDataDelegate {
    
    let filePath = "http://9.qqmp3.com:82/gg2015/music2013/20151214/n03.mp3"
    
    var contentLength:String?
    
    // 存储接收到的二进制数据
    var fileData:NSMutableData?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = NSURL(string: filePath)
        
        let request = NSURLRequest(URL: url!)
        
        NSURLConnection(request: request, delegate: self)
       
    }
    
    // 响应开始
    func connection(connection: NSURLConnection, didReceiveResponse response: NSURLResponse) {
        
        
        let connResponse = response as! NSHTTPURLResponse
        
        print(connResponse)
        
        contentLength = (connResponse.allHeaderFields as NSDictionary).objectForKey("Content-Length") as? String
        print(contentLength)
        fileData = NSMutableData()
        
        print("响应开始")
        
        
    }
    
    // 接收数据
    func connection(connection: NSURLConnection, didReceiveData data: NSData) {
        
        fileData?.appendData(data)
        let present = 1.0 * Float(fileData!.length) / Float(contentLength!)!
        
        print(NSString(format: "已下载%.2f%%", present * 100))
    }
    
    // 接收完成
    func connectionDidFinishLoading(connection: NSURLConnection) {
        
        print("下载完成")
        
        let cachePath = NSSearchPathForDirectoriesInDomains(.CachesDirectory, .UserDomainMask, true).last! as NSString
        
        print("沙盒路径------\(cachePath)")
        
        // 文件路径
        let targetPath = cachePath.stringByAppendingPathComponent("music.mp3")
        
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
