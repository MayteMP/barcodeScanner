//
//  ViewController.swift
//  BarcodeScanner
//
//  Created by Mayte Mejia Palacios on 26/02/18.
//  Copyright © 2018 Mayte. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    @IBOutlet weak var square: UIImageView!
    var video = AVCaptureVideoPreviewLayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let session = AVCaptureSession()
        
        let captureDevice = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        
        do{
            let input = try AVCaptureDeviceInput(device: captureDevice)
            session.addInput(input)
        }catch{
            print("ERROR")
        }
        
        let output = AVCaptureMetadataOutput()
        
        session.addOutput(output)
        
        output.setMetadataObjectsDelegate(self, queue: dispatch_get_main_queue())
        //output.metadataObjectTypes = [AVMetadataObjectTypeQRCode] //change the code
        output.metadataObjectTypes = [AVMetadataObjectTypeEAN13Code]
        video = AVCaptureVideoPreviewLayer(session: session)
        video.frame = view.layer.bounds
        view.layer.addSublayer(video)
        self.view.bringSubviewToFront(square)
        session.startRunning()
    }
    
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!) {
        if metadataObjects != nil && metadataObjects.count != 0 {
            if let object = metadataObjects[0] as? AVMetadataMachineReadableCodeObject{
                //if object.type == AVMetadataObjectTypeQRCode{
                if object.type == AVMetadataObjectTypeEAN13Code {
                    let alert = UIAlertController(title: "EAN113 Code", message: object.stringValue, preferredStyle: .Alert)
                    alert.addAction(UIAlertAction(title: "Retake", style: .Default, handler:  nil))
                    alert.addAction(UIAlertAction(title: "Copy", style: .Default, handler:  { (nil) in
                        UIPasteboard.generalPasteboard()
                    }))
                    presentViewController(alert, animated: true, completion: nil)
                }
            }
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

