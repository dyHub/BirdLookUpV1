//
//  ViewController.swift
//  BirdLookupPart0
//
//  Created by Kareem Moussa on 6/25/15.
//  Copyright (c) 2015 Kareem Moussa. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate{
    
    //this captures the camera input like a "live" vid stream
    var captureSession : AVCaptureSession?
    //this is for capturing the image
    var stillImageOutput : AVCaptureStillImageOutput?
    //this is for rendering the view
    var previewLayer : AVCaptureVideoPreviewLayer?
    //this is the jpeg to send to the next view controller
    var imageData : NSData?
    
        
    @IBOutlet var cameraView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        //set the view to the previewLayer which holds input
        previewLayer?.frame = cameraView.bounds
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationItem.title = "Camera"
        captureSession = AVCaptureSession()
        captureSession?.sessionPreset = AVCaptureSessionPreset1920x1080
        
        var backCamera = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        
        var error : NSError?
        // & means pass by value by reference, similar to C/C++
        var input = AVCaptureDeviceInput(device: backCamera, error: &error)
        
        if (error == nil && captureSession?.canAddInput(input) != nil){
            
            //connect to video input stream
            captureSession?.addInput(input)
            
            //take a pic once
            stillImageOutput = AVCaptureStillImageOutput()
            stillImageOutput?.outputSettings = [AVVideoCodecKey : AVVideoCodecJPEG]
            
            if (captureSession?.canAddOutput(stillImageOutput) != nil){
                
                //set output of vid stream as image
                captureSession?.addOutput(stillImageOutput)
                
                //set the layer
                previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
                previewLayer?.videoGravity = AVLayerVideoGravityResizeAspect
                previewLayer?.connection.videoOrientation = AVCaptureVideoOrientation.Portrait
                cameraView.layer.addSublayer(previewLayer)
                
                captureSession?.startRunning()
                
            }
            
        }
        
        
    }
    
    @IBOutlet var tempImageView: UIImageView!
    @IBOutlet var sendButton: UIButton!
    
    func didPressTakePhoto(){
        
        if let videoConnection = stillImageOutput?.connectionWithMediaType(AVMediaTypeVideo){
            
            videoConnection.videoOrientation = AVCaptureVideoOrientation.Portrait
            //take pic with async callback (closure)
            stillImageOutput?.captureStillImageAsynchronouslyFromConnection(videoConnection, completionHandler: {
                (sampleBuffer, error) in
                
                if sampleBuffer != nil {
                    
                    //convert from jpeg to CGImage
                    self.imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(sampleBuffer)
                    var dataProvider  = CGDataProviderCreateWithCFData(self.imageData)
                    var cgImageRef = CGImageCreateWithJPEGDataProvider(dataProvider, nil, true, kCGRenderingIntentDefault)
                    
                    //full size img
                    var image = UIImage(CGImage: cgImageRef, scale: 1.0, orientation: UIImageOrientation.Right)
                    
                    //must use self. because we are in closure
                    self.tempImageView.image = image
                    self.tempImageView.hidden = false
                    self.sendButton.hidden = false
                    
                }
                
                
            })
        }
        
        
    }
    
    var didTakePhoto = Bool()
    
    func didPressTakeAnother(){
        if didTakePhoto == true{
            tempImageView.hidden = true
            sendButton.hidden = true
            didTakePhoto = false
        }
        else{
            captureSession?.startRunning()
            didTakePhoto = true
            didPressTakePhoto()
        }        
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        didPressTakeAnother()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var DestViewController : View2 = segue.destinationViewController as! View2
        DestViewController.imageData = self.imageData
        
    }
    
    
}


