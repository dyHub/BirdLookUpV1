//
//  View2.swift
//  BirdLookupPart0
//
//  Created by Kareem Moussa on 6/25/15.
//  Copyright (c) 2015 Kareem Moussa. All rights reserved.
//

import UIKit

class View2: UIViewController {
    
    //passed from main VC
    var imageData : NSData?
    var imgToken : NSString? //from api call
    
    @IBOutlet var cameraImage: UIImageView!
    @IBOutlet var imgDescription: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        //waiting for img desc
        imgDescription.text = "[waiting]"
        if(imageData != nil){
            cameraImage.image = UIImage(data: imageData!, scale: 1.0)
        }
        makeRequestToCloudSight()
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //this is a post/get request chain that will find an image Description
    func makeRequestToCloudSight(){
        
        postToGetToken()
        getToGetDescription()
        
        
    }
    
    //------------------POST REQUEST AND GET TOKEN--------------------------//
    
    func postToGetToken(){
        var url = "https://camfind.p.mashape.com/image_requests"
        var request = NSMutableURLRequest(URL: NSURL(string: url)!)
        var session = NSURLSession.sharedSession()
        request.HTTPMethod = "POST"
        
        //method must take data object. make params here
        var str1 = "image_request[image]="; var str2 = "image_request[locale]=en";
        var params = NSMutableData()
        params.appendData(str1.dataUsingEncoding(NSUTF8StringEncoding)!)
        params.appendData(imageData!)
        params.appendData(str2.dataUsingEncoding(NSUTF8StringEncoding)!)
        
        var err: NSError?
        request.HTTPBody = params
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("c5eVWXdxDrmshSeRT8T8gNADl9sxp1emHCSjsnHNNryWRMUztq",
            forHTTPHeaderField: "X-Mashape-Key")
        
        //response
        var task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            
            var strData = NSString(data: data, encoding: NSUTF8StringEncoding)
            var err: NSError?
            var json = NSJSONSerialization.JSONObjectWithData(data, options: .MutableLeaves, error: &err) as? NSDictionary
            
            // error
            if(err != nil) {
                let jsonStr = NSString(data: data, encoding: NSUTF8StringEncoding)
                println("Error with json")
            }
            else {
                
                //get the token
                if let parseJSON = json {
                    var success = parseJSON["token"] as? NSString
                    self.imgToken = success!
                }
                
            }
        })
        
        task.resume()
    }
    
    //-----------------------------GET REQUEST TO FIND DESCRIPTION------------------------//

    func getToGetDescription(){
        var url = "https://camfind.p.mashape.com/image_responses/" + (imgToken! as String)
        var request = NSMutableURLRequest(URL: NSURL(string: url)!)
        var session = NSURLSession.sharedSession()
        request.HTTPMethod = "POST"
      
        //no params this time
        
        var err: NSError?
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("c5eVWXdxDrmshSeRT8T8gNADl9sxp1emHCSjsnHNNryWRMUztq",
            forHTTPHeaderField: "X-Mashape-Key")
        
        //response
        var task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            
            var strData = NSString(data: data, encoding: NSUTF8StringEncoding)
            var err: NSError?
            var json = NSJSONSerialization.JSONObjectWithData(data, options: .MutableLeaves, error: &err) as? NSDictionary
            
            // error
            if(err != nil) {
                let jsonStr = NSString(data: data, encoding: NSUTF8StringEncoding)
                println("Error with json")
            }
            else {
                
                //get the token
                if let parseJSON = json {
                    var success = parseJSON["name"] as? String
                    
                    //YYEEESS. this is where we set the img description label
                    self.imgDescription.text = success
                }
                
            }
        })
        
        task.resume()
        
    }
    
}
