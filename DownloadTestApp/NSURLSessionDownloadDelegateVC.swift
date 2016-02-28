//
//  NSURLSessionDownloadDelegate.swift
//  DownloadTestApp
//
//  Created by 也许、 on 16/2/24.
//  Copyright © 2016年 K. All rights reserved.
//

import UIKit

class NSURLSessionDownloadDelegateVC: UIViewController, NSURLSessionDownloadDelegate {
    
    var downloadSession:NSURLSession?
    
    // 文件存放地址
    var filePath:String?
    
    // 下载文件路径
    let downloadPath = "http://lx.cdn.baidupcs.com/file/504c1c334bd8badf2f6ca629a6a7ab73?bkt=p2-nj-739&xcode=d557991a5defc4904e57792e42712478c9c6b3b6f80269560b2977702d3e6764&fid=338912528-250528-148928864421093&time=1456321074&sign=FDTAXGERBH-DCb740ccc5511e5e8fedcff06b081203-OjULrsW8S57Ic93h4ZaG5Drm00o%3D&to=hc&fm=Nin,B,G,bs&sta_dx=9&sta_cs=1328&sta_ft=mp4&sta_ct=7&fm2=Ningbo,B,G,bs&newver=1&newfm=1&secfm=1&flow_ver=3&pkey=000037d201d339a43d9acda3474a97b2b65a&expires=8h&rt=pr&r=448261041&mlogid=1273316784693583088&vuk=338912528&vbdid=2235946378&fin=04-数字格式.mp4&uta=0&rtype=0&iv=1&isw=0&dp-logid=1273316784693583088&dp-callid=0.1.1"
    
    let imageUrl = "http://img3.douban.com/view/photo/photo/public/p2154674813.jpg"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 下载
        download()

    }
    
    /**
        下载
     */
    func download() {
        
        // 请求地址转码
        let url = NSURL(string: imageUrl.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!)
        
        // 声明配置对象
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        
        // 声明session
        self.downloadSession = NSURLSession(configuration: config, delegate: self, delegateQueue: nil)

        // 创建下载任务
        let task = self.downloadSession!.downloadTaskWithURL(url!)

        // 任务开始
        task.resume()
        
    }
    
    func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didFinishDownloadingToURL location: NSURL) {
        
        print("完成下载","把存在临时文件夹中的文件移动到指定文件夹中")
        
        let cachePath = NSString(string: NSSearchPathForDirectoriesInDomains(.CachesDirectory, .UserDomainMask, true).last!)
        
        self.filePath = cachePath.stringByAppendingPathComponent( downloadTask.response!.suggestedFilename! )
        
        let mgr = NSFileManager.defaultManager()
        
        print("下载文件存放地址",self.filePath)
        
        print("临时文件夹地址",location.path)
        
        do {
            try mgr.moveItemAtPath(location.path!, toPath: self.filePath!)
        } catch {
            print("移动文件时,发生错误")
        }
        
    }
    
    func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didResumeAtOffset fileOffset: Int64, expectedTotalBytes: Int64) {
        
        print("继续下载")
    
    }
    
    func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        
        let precent = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)
        print("已下载", String(format: "%.2f%%", precent * 100 ))
        
    }
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

}
