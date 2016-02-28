//
//  UploadFileVC.swift
//  DownloadTestApp
//
//  Created by 也许、 on 16/2/28.
//  Copyright © 2016年 K. All rights reserved.
//

import UIKit

class UploadFileVC: UIViewController,UINavigationControllerDelegate,UIImagePickerControllerDelegate {
    
    // 显示选择图片
    @IBOutlet weak var imageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // 添加手势
        self.imageView.userInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: "choosePhoto")
        self.imageView.addGestureRecognizer(tapGesture)
        
    }
    
    /**
        上传图片
     */
    @IBAction func uploadPhoto(sender: UIButton) {
        
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        config.timeoutIntervalForRequest = 10
        let session = NSURLSession(configuration: config)
        
        let url = NSURL(string: "http://192.168.1.101:8080/ajaxFileUpload/upload")
        let request = NSMutableURLRequest(URL: url!, cachePolicy: .ReloadIgnoringLocalCacheData, timeoutInterval: 10)
        request.HTTPMethod = "POST"
        
        // 分隔符
        let boundary = "uploader"
        
        // 上传文件名称
        let uploadFileName = "upload.png"
        var bodyData = NSMutableData()
        
        // 1.  \r\n---(可以随便写,但是不能写中文)\r\n
        let step1 =  String(format: "\r\n--%@\r\n", boundary)
        bodyData.appendData(step1.dataUsingEncoding(NSUTF8StringEncoding)!)
        
        // 2.  Content-Disposition: form-data; name="fileToUpload"; filename="11.png"\r\n
        let step2 = String(format: "Content-Disposition: form-data; name=\"userfile\"; filename=\"%@\" \r\n", uploadFileName)
        bodyData.appendData(step2.dataUsingEncoding(NSUTF8StringEncoding)!)
        
        // 3.  Content-Type: application/octet-stream\r\n\r\n
        let step3 = "Content-Type: application/octet-stream\r\n\r\n"
        bodyData.appendData(step3.dataUsingEncoding(NSUTF8StringEncoding)!)
        
        // 4.  上传文件的二进制流
        let imgData = UIImagePNGRepresentation(self.imageView.image!)
        bodyData.appendData( imgData! )
        
        // 5.  \r\n--(可以随便写,但是不能写中文)--\r\n
        let step5 =  String(format: "\r\n--%@--\r\n", boundary)
        bodyData.appendData(step5.dataUsingEncoding(NSUTF8StringEncoding)!)
        
        // 6. 设置请求头 multipart/form-data; boundary=---------------------------121472129018411726481496825313
        let contentType = String(format: "multipart/form-data; boundary=%@", boundary)
        request.setValue(contentType, forHTTPHeaderField: "Content-Type")
        
        session.uploadTaskWithRequest(request, fromData: bodyData) { (data, response, error) -> Void in
            print(data,response,error)
            bodyData = NSMutableData()
        }.resume()
        
    }
    
    // 从图库中选择图片
    func choosePhoto() {
        
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .PhotoLibrary
        imagePickerController.delegate = self
        
        self.presentViewController(imagePickerController, animated: true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        
        self.imageView.image = image
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
