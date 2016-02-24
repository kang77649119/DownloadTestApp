//
//  ViewController.swift
//  DownloadTestApp
//
//  Created by 也许、 on 16/2/17.
//  Copyright © 2016年 K. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    let cellId = "cellId"
    
    let datas = ["图片下载","小文件下载","大文件下载","使用NSOutputStream下载"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let table = UITableView(frame: CGRectMake(0, 0, self.view.frame.size.width , self.view.frame.height ), style: .Plain)
        
        table.delegate = self
        table.dataSource = self
        
        self.view.addSubview(table)
        
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datas.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCellWithIdentifier(self.cellId)
        if cell == nil {
            cell = UITableViewCell(style: .Default, reuseIdentifier: self.cellId)
            cell?.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        }
        
        cell?.textLabel?.text = self.datas[indexPath.row]
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        switch indexPath.row {
            
        case 0:
                let imageDownloadVC = ImageDownload(nibName: "ImageDownload", bundle: NSBundle.mainBundle())
                self.navigationController?.pushViewController(imageDownloadVC, animated: true)
            
            case 1:
                let smallDownloadVC = SmallDataDownload(nibName: "SmallDataDownload", bundle: NSBundle.mainBundle())
                smallDownloadVC.title = self.datas[indexPath.row]
                self.navigationController?.pushViewController(smallDownloadVC, animated: true)
                
            case 2:
                let bigDownloadVC = BigDataDownload(nibName: "BigDataDownload", bundle: NSBundle.mainBundle())
                bigDownloadVC.title = self.datas[indexPath.row]
                self.navigationController?.pushViewController(bigDownloadVC, animated: true)
                
            case 3:
                let outputStreamDownloadVC = NSOutputStreamDownload(nibName: "BigDataDownload", bundle: NSBundle.mainBundle())
                outputStreamDownloadVC.title = self.datas[indexPath.row]
                self.navigationController?.pushViewController(outputStreamDownloadVC, animated: true)
                
            default:
                return
        }
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

