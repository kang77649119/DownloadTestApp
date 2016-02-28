//
//  NSURLSessionDownloadTask.swift
//  DownloadTestApp
//
//  Created by 也许、 on 16/2/24.
//  Copyright © 2016年 K. All rights reserved.
//

import UIKit

class NSURLSessionDownloadTaskVC: UIViewController {
    
    // 下载文件路径
    let downloadPath = "http://lx.cdn.baidupcs.com/file/504c1c334bd8badf2f6ca629a6a7ab73?bkt=p2-nj-739&xcode=d557991a5defc4904e57792e42712478c9c6b3b6f80269560b2977702d3e6764&fid=338912528-250528-148928864421093&time=1456321074&sign=FDTAXGERBH-DCb740ccc5511e5e8fedcff06b081203-OjULrsW8S57Ic93h4ZaG5Drm00o%3D&to=hc&fm=Nin,B,G,bs&sta_dx=9&sta_cs=1328&sta_ft=mp4&sta_ct=7&fm2=Ningbo,B,G,bs&newver=1&newfm=1&secfm=1&flow_ver=3&pkey=000037d201d339a43d9acda3474a97b2b65a&expires=8h&rt=pr&r=448261041&mlogid=1273316784693583088&vuk=338912528&vbdid=2235946378&fin=04-数字格式.mp4&uta=0&rtype=0&iv=1&isw=0&dp-logid=1273316784693583088&dp-callid=0.1.1"

    override func viewDidLoad() {
        super.viewDidLoad()

        download()
        
    }
    
    /**
        下载
     */
    func download() {
        
        let url = NSURL(string: downloadPath.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!)
        let session = NSURLSession.sharedSession()
        // location是临时文件夹路径,下载完成,需要将文件移动至其他目录中才能保存下载,临时文件夹中的文件会自动被删除
        let task = session.downloadTaskWithURL(url!) { (location, response, error) -> Void in
            if error == nil {
                
                // 移动到缓存文件夹中
                let cachePath = NSSearchPathForDirectoriesInDomains(.CachesDirectory, .UserDomainMask, true).last! as NSString
                let filePath = cachePath.stringByAppendingPathComponent(response!.suggestedFilename!)
                let mgr = NSFileManager.defaultManager()
                try! mgr.moveItemAtURL(location!, toURL: NSURL(fileURLWithPath: filePath))
                
                print(location)
            }
        }
        
        task.resume()
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
