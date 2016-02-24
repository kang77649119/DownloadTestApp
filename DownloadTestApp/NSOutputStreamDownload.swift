//
//  NSOutputStreamDownload.swift
//  DownloadTestApp
//
//  Created by 也许、 on 16/2/24.
//  Copyright © 2016年 K. All rights reserved.
//

import UIKit

class NSOutputStreamDownload: UIViewController,NSURLConnectionDataDelegate {

    // 下载文件路径
    let downloadPath = "http://lx.cdn.baidupcs.com/file/de8d8796ee546c5ae370f8f0e45537fb?bkt=p2-nj-739&xcode=1791e8c49ea567e02748e632bc49b8aa229dcdb90ad0ed12837047dfb5e85c39&fid=338912528-250528-293914034843258&time=1456304580&sign=FDTAXERBH-DCb740ccc5511e5e8fedcff06b081203-Mwm%2Bc7vJ4cpA9ztP9riKtvdqc%2FM%3D&to=hc&fm=Nin,B,U,nc&sta_dx=10&sta_cs=502&sta_ft=mp4&sta_ct=7&fm2=Ningbo,B,U,nc&newver=1&newfm=1&secfm=1&flow_ver=3&expires=8h&rt=pr&r=770951300&mlogid=1268889184745400944&vuk=338912528&vbdid=2235946378&fin=01-语法须知.mp4&uta=0&rtype=0&iv=1&isw=0&dp-logid=1268889184745400944&dp-callid=0.1.1"
    
    // 文件存放路径
    var filePath:String?
    
    // 文件大小
    var contentLength:Int?
    
    // 当前文件大小
    var currentLength:Int = 0
    
    // 文件流
    var outputStream:NSOutputStream?
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 发送下载请求
        let request = NSURLRequest(URL: NSURL(string: downloadPath.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!)!)
        
        NSURLConnection(request: request, delegate: self)
        
    }
    
    // 接收响应
    func connection(connection: NSURLConnection, didReceiveResponse response: NSURLResponse) {
        
        let connResp = response as! NSHTTPURLResponse
        
        // 文件大小
        self.contentLength = connResp.allHeaderFields["Content-Length"]?.integerValue
        
        // 文件存放路径
        let documentPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).last! as NSString
        
        // 使用 connResp.suggestedFilename 拿到的文件名会乱码 还没解决 T^T
        self.filePath = documentPath.stringByAppendingPathComponent( "视频.mp4" )
        
        // 创建文件流
        self.outputStream = NSOutputStream(toFileAtPath: self.filePath!, append: true)
        
    }
    
    // 下载数据
    func connection(connection: NSURLConnection, didReceiveData data: NSData) {
        
        // 计算下载进度
        self.currentLength += data.length
        let percent = Float(self.currentLength) / Float(self.contentLength!)
        print( String(format: "已下载:%.2f%%", percent * 100) )
        
        
        // 文件不存在则创建新文件
        self.outputStream!.open()
        
        self.outputStream!.write(UnsafePointer<UInt8>(data.bytes), maxLength: data.length)
        
    }
    
    // 连接失败
    func connection(connection: NSURLConnection, didFailWithError error: NSError) {
        
        print("下载失败")
        self.outputStream?.close()
        self.outputStream = nil
        
    }
    
    // 完成下载
    func connectionDidFinishLoading(connection: NSURLConnection) {
        print("下载完成")
        self.outputStream?.close()
        self.outputStream = nil
    }
}
