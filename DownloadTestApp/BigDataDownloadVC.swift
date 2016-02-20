//
//  BigDataDownloadVC.swift
//  DownloadTestApp
//
//  Created by 也许、 on 16/2/19.
//  Copyright © 2016年 K. All rights reserved.
//

import UIKit

class BigDataDownloadVC: UIViewController,NSURLConnectionDataDelegate {
    
    // 下载进度条
    @IBOutlet var downloadProgress: UIView!
    
    // 下载文件路径
    let filePath = "http://9.qqmp3.com:82/gg2015/music2013/20151214/n03.mp3"
    
    // 写入文件路径
    var targetFilePath:String?
    
    // 文件大小
    var contentLength:String?
    
    // 当前接收到的数据大小
    var currentLength:Float?
    
    // 文件处理对象
    var fileHandle:NSFileHandle?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 下载文件
        download()
        
    }
    
    func download() {
        
        // 下载请求
        let request = NSURLRequest(URL: NSURL(string: filePath)!)
        NSURLConnection(request: request, delegate: self)
        
        // 设置写入文件路径
        let cachePath = NSSearchPathForDirectoriesInDomains(.CachesDirectory, .UserDomainMask, true).last! as NSString
        
        self.targetFilePath = cachePath.stringByAppendingPathComponent("bigData.mp3")
        
    }
    
    /**
        接收数据
     */
    func connection(connection: NSURLConnection, didReceiveData data: NSData) {
        
        self.currentLength! += Float(data.length)
        
        // 写入坐标 移动至文件末尾
        self.fileHandle?.seekToEndOfFile()
        // 直接写入沙盒文件中
        self.fileHandle?.writeData(data)
        
        let percentum = self.currentLength! / Float(self.contentLength!)!
        
        print( String(format: "已下载%.2f%%", percentum * 100))
        
        
    }
    
    func connection(connection: NSURLConnection, didFailWithError error: NSError) {
        print("下载失败")
    }
    
    /**
        响应数据
     */
    func connection(connection: NSURLConnection, didReceiveResponse response: NSURLResponse) {
        
        // 获取下载文件大小
        let connResp = response as! NSHTTPURLResponse
        let responseDic = connResp.allHeaderFields as NSDictionary
        self.contentLength = responseDic.objectForKey("Content-Length") as? String
        self.currentLength = 0
        
        // 创建空文件
        NSFileManager.defaultManager().createFileAtPath(self.targetFilePath!, contents: nil, attributes: nil)
        
        // 创建文件处理对象
        self.fileHandle = NSFileHandle(forWritingAtPath: self.targetFilePath!)
        
    }
    
    /**
        接收完成
     */
    func connectionDidFinishLoading(connection: NSURLConnection) {
        
        print("download finished")
        self.fileHandle?.closeFile()
        self.fileHandle = nil
        self.contentLength = nil
        print(self.targetFilePath)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
