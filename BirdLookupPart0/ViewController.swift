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
    
    // IB Attributes
    @IBOutlet var cameraView: UIView!
    @IBOutlet var tempImageView: UIImageView!
    @IBOutlet var sendButton: UIButton!
    @IBOutlet weak var backButton: UIBarButtonItem!
    
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
        self.sendButton.hidden = true
        
        captureSession = AVCaptureSession()
        captureSession?.sessionPreset = AVCaptureSessionPreset1920x1080
        
        let backCamera = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        
        var error : NSError?
        // & means pass by value by reference, similar to C/C++
        var input: AVCaptureDeviceInput!
        do {
            input = try AVCaptureDeviceInput(device: backCamera)
        } catch let error1 as NSError {
            error = error1
            input = nil
        }
        
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
                cameraView.layer.addSublayer(previewLayer!)
                
                captureSession?.startRunning()
                
            }
            
        }
        
        
    }
    
    
    
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
                    var cgImageRef = CGImageCreateWithJPEGDataProvider(dataProvider, nil, true, CGColorRenderingIntent.RenderingIntentDefault)
                    
                    //full size img
                    var image = UIImage(CGImage: cgImageRef!, scale: 1.0, orientation: UIImageOrientation.Right)
                    
                    //must use self. because we are in closure
                    //self.cameraView.hidden = true
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
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        didPressTakeAnother()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let DestViewController : View2 = segue.destinationViewController as! View2
        DestViewController.imageData = self.imageData
        
    }
    
    // IB Action
    // home button present home view
    @IBAction func backHome(sender: UIBarButtonItem) {
        let homeVC = self.storyboard?.instantiateViewControllerWithIdentifier("homeView") as!HomeView
        self.presentViewController(homeVC, animated: true, completion: nil)
    }
    
}


