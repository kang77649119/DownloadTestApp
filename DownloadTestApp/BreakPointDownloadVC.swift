//
//  BreakPointDownloadVC.swift
//  DownloadTestApp
//
//  Created by 也许、 on 16/2/28.
//  Copyright © 2016年 K. All rights reserved.
//

import UIKit

class BreakPointDownloadVC: UIViewController,NSURLSessionDownloadDelegate {
    
    // 显示下载进度
    @IBOutlet weak var progressLabel: UILabel!
    
    // 当前下载的数据
    var currentData:NSMutableData = NSMutableData()
    
    // 存储已下载的文件路径
    let contentPath = NSString(string: NSSearchPathForDirectoriesInDomains(.CachesDirectory, .UserDomainMask, true).last!).stringByAppendingPathComponent("temp.data")
    
    var downloadTask:NSURLSessionDownloadTask?
    
    let url = "http://lx.cdn.baidupcs.com/file/504c1c334bd8badf2f6ca629a6a7ab73?bkt=p2-nj-739&xcode=7df69d45fa313142b72b3440ae166b725ee46d3d72a255e5837047dfb5e85c39&fid=338912528-250528-148928864421093&time=1456638864&sign=FDTAXGERLBH-DCb740ccc5511e5e8fedcff06b081203-nj9YhbhfzYbJV56mnPYM00c1g7E%3D&to=lc&fm=Nin,B,G,bs&sta_dx=9&sta_cs=1330&sta_ft=mp4&sta_ct=7&fm2=Ningbo,B,G,bs&newver=1&newfm=1&secfm=1&flow_ver=3&pkey=000037d201d339a43d9acda3474a97b2b65a&sl=76218446&expires=8h&rt=pr&r=700072984&mlogid=1358622714126751411&vuk=338912528&vbdid=2235946378&fin=04-数字格式.mp4&slt=pm&uta=0&rtype=1&iv=0&isw=0&dp-logid=1358622714126751411&dp-callid=0.1.1"
    
    /**
        开始下载
     */
    @IBAction func startDownload(sender: UIButton) {
        
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: config, delegate: self, delegateQueue: NSOperationQueue())
        
        // 检测临时文件是否存在,如果存在继续下载,否则重新下载
        let fileData = NSData(contentsOfFile: self.contentPath)
        if fileData == nil {
            
            // 重新下载
            let fileUrl = NSURL(string: url.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!)
            
            self.downloadTask = session.downloadTaskWithURL(fileUrl!)
            
        } else {
            self.currentData.appendData(fileData!)
            self.downloadTask = session.downloadTaskWithResumeData(fileData!)
        }
        
        self.downloadTask!.resume()
    }
    
    /**
        暂停下载
     */
    @IBAction func pauseDownload(sender: UIButton) {
        
        self.downloadTask?.cancelByProducingResumeData({ (data) -> Void in
            print(data?.length)
            self.currentData.appendData(data!)
            self.currentData.writeToFile(self.contentPath, atomically: true)
        })
        
    }
    
    /**
        继续下载
     */
    @IBAction func resumeDownload(sender: UIButton) {
        self.downloadTask!.resume()
    }
    
    /**
        监测下载进度
     */
    func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        
        let percent = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)
        print("已下载", String(format: "%.2f%%", percent * 100))

        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            self.progressLabel.text = String(format: "%.2f%%", percent * 100)
        }
        
    }
    
    
    func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didResumeAtOffset fileOffset: Int64, expectedTotalBytes: Int64) {
        
        let percent = Float(fileOffset) / Float(expectedTotalBytes)
        print("继续下载", String(format: "%.2f%%", percent * 100 ))
        
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            self.progressLabel.text = String(format: "%.2f%%", percent * 100)
        }
        
    }
    
    func URLSession(session: NSURLSession, task: NSURLSessionTask, didCompleteWithError error: NSError?) {
        
    }
    
    func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didFinishDownloadingToURL location: NSURL) {
        
        print(location)
        
        print("下载完成")
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
