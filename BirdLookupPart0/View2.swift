//
//  View2.swift
//  BirdLookupPart0
//
//  Created by Kareem Moussa on 6/25/15.
//  Copyright (c) 2015 Kareem Moussa. All rights reserved.
//

import UIKit
import Alamofire

class View2: UIViewController {
    
    //passed from main VC
    var imageData : NSData?
    
    @IBOutlet var cameraImage: UIImageView!
    @IBOutlet var imgDescription: UILabel!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        imgDescription.text = "[waiting]"
        
        //TODO: Make sure the image doesn't get too stretched. Play around with scale
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
        
    }
    
    //------------------POST REQUEST AND GET TOKEN--------------------------//
    func postToGetToken(callback: (String) -> Void){
        let url = "https://camfind.p.mashape.com/image_requests"
        
        //TODO: instead of taking an image url, send post request using image as jpg or png
        let params = [
            "image_request[remote_image_url]": "http://www.thinkwoof.com/dog-breed-images/golden-retriever.jpg",
            "image_request[locale]": "en_US"
        ]
        let headers = [
            "X-Mashape-Key": "c5eVWXdxDrmshSeRT8T8gNADl9sxp1emHCSjsnHNNryWRMUztq",
            "Content-Type": "application/x-www-form-urlencoded",
            "Accept": "application/json"
        ]
        
        Alamofire.request(.POST, url, headers: headers, parameters: params).responseJSON {
            (response) -> Void in
            
            //response.result.value is the JSON response
            
            //TODO: clean up if statements
            if let JSON = response.result.value{
                debugPrint(JSON)

                //get the token
                if let token = JSON["token"] {
                    callback(token as! String)
                }
                else{
                    self.imgDescription.text = "Error: Post request didn't return token"
                }
                
            }
            else {
                print("Error: Couldn't get token")
            }
            
        }

    }
    
    //-----------------------------GET REQUEST TO FIND DESCRIPTION------------------------//

    func getToGetDescription(token: String) {
        let url = "https://camfind.p.mashape.com/image_responses/" + token
        
        let headers = [
            "X-Mashape-Key": "c5eVWXdxDrmshSeRT8T8gNADl9sxp1emHCSjsnHNNryWRMUztq",
            "Accept": "application/json"
        ]
        
        Alamofire.request(.GET, url, headers: headers).responseJSON {
            (response) -> Void in
            
            //TODO: clean up if statements
            if let JSON = response.result.value{
                
                if let description = JSON["name"]{
                    self.imgDescription.text = description as! String
                } else {
                    self.imgDescription.text = "Error getting image description"
                }

            } else {
                self.imgDescription.text = "Error getting image description"
            }
            
        }
    }
    
}
