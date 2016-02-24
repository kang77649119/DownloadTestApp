//
//  BigDataDownload.swift
//  DownloadTestApp
//
//  Created by 也许、 on 16/2/24.
//  Copyright © 2016年 K. All rights reserved.
//

import UIKit

class BigDataDownload: UIViewController,NSURLConnectionDataDelegate {

    // 下载进度条
    @IBOutlet var downloadProgress: UIView!
    
    // 下载文件路径
    let filePath = "http://lx.cdn.baidupcs.com/file/de8d8796ee546c5ae370f8f0e45537fb?bkt=p2-nj-739&xcode=1791e8c49ea567e02748e632bc49b8aa229dcdb90ad0ed12837047dfb5e85c39&fid=338912528-250528-293914034843258&time=1456304580&sign=FDTAXERBH-DCb740ccc5511e5e8fedcff06b081203-Mwm%2Bc7vJ4cpA9ztP9riKtvdqc%2FM%3D&to=hc&fm=Nin,B,U,nc&sta_dx=10&sta_cs=502&sta_ft=mp4&sta_ct=7&fm2=Ningbo,B,U,nc&newver=1&newfm=1&secfm=1&flow_ver=3&expires=8h&rt=pr&r=770951300&mlogid=1268889184745400944&vuk=338912528&vbdid=2235946378&fin=01-语法须知.mp4&uta=0&rtype=0&iv=1&isw=0&dp-logid=1268889184745400944&dp-callid=0.1.1"
    
    // 写入文件路径
    var targetFilePath:String?
    
    // 文件大小
    var contentLength:Int?
    
    // 当前接收到的数据大小
    var currentLength:Float?
    
    // 文件处理对象
    var fileHandle:NSFileHandle?
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 下载文件
        download()
        
    }
    
    func download() {
        
        // 下载请求
        let request = NSURLRequest(URL: NSURL(string: filePath.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!)!)
        NSURLConnection(request: request, delegate: self)
        
        // 设置写入文件路径
        let cachePath = NSSearchPathForDirectoriesInDomains(.CachesDirectory, .UserDomainMask, true).last! as NSString
        
        self.targetFilePath = cachePath.stringByAppendingPathComponent("bigData.mp4")
        
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
        
        let percentum = self.currentLength! / Float(self.contentLength!)
        
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
        self.contentLength = connResp.allHeaderFields["Content-Length"]?.integerValue
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

}
