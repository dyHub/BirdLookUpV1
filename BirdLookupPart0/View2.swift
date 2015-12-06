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
        
        postToGetToken(getToGetDescription)
//        getToGetDescription()
        
        
    }
    
    //------------------POST REQUEST AND GET TOKEN--------------------------//
    
    func postToGetToken(callback: (Void) -> Void){
        var url = "https://camfind.p.mashape.com/image_requests/"
        var request = NSMutableURLRequest(URL: NSURL(string: url)!)
        var session = NSURLSession.sharedSession()
        request.HTTPMethod = "POST"
    
        //method must take data object. make params here
        let str1 = "image_request[image]="
        let str2 = "image_request[locale]=en_US"
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
            
            var strData = NSString(data: data!, encoding: NSUTF8StringEncoding)
            var err: NSError?
            var json : NSDictionary?
            do{
                json = try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableLeaves) as? NSDictionary
            }
            catch _ {}
            
            
            // error
            if(err != nil) {
//                let jsonStr = NSString(data: data!, encoding: NSUTF8StringEncoding)
                print("Error with json")
            }
            else {
                
                //get the token
                if let parseJSON = json {
                    let success = parseJSON["token"] as? NSString
                    self.imgToken = success!
                    print("ye%@", self.imgToken)
                    
                    //this is the get req
                    callback()
                }
                
            }
        })
        
        task.resume()
    }
    
    //-----------------------------GET REQUEST TO FIND DESCRIPTION------------------------//

    func getToGetDescription(){
        print(imgToken)
        let url = "https://camfind.p.mashape.com/image_responses/" + (imgToken! as String)
//        let url = "https://camfind.p.mashape.com/image_responses/" + String(data: imgToken!, encoding: NSUTF8StringEncoding)
        var request = NSMutableURLRequest(URL: NSURL(string: url)!)
        var session = NSURLSession.sharedSession()
        request.HTTPMethod = "GET"
      
        //no params this time
        
        var err: NSError?
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("c5eVWXdxDrmshSeRT8T8gNADl9sxp1emHCSjsnHNNryWRMUztq",
            forHTTPHeaderField: "X-Mashape-Key")
        
        //response
        var task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            
            var strData = NSString(data: data!, encoding: NSUTF8StringEncoding)
            //var err: NSError?
            var json: NSDictionary!
            do{
                json = try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableLeaves)
                as! NSDictionary
            }catch{}
            
            // error
            if(err != nil) {
                let jsonStr = NSString(data: data!, encoding: NSUTF8StringEncoding)
                print("Error with json")
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
