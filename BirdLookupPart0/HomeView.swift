//
//  HomeView.swift
//  BirdLookupPart0
//
//  Created by seab on 12/7/15.
//  Copyright © 2015 Kareem Moussa. All rights reserved.
//

import UIKit

class HomeView: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {


    // MARK: Properties
    @IBOutlet weak var HomeImage: UIImageView!
    var imageData : NSData?
    

    // ---------- default override function ---------//
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // ---------------- functions for image picker ----------------- //
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        // Dismiss the picker if user canceled. This code animates the dismissal of the image picker controller.
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // called when a user selects a photo
    func imagePickerController(picker: UIImagePickerController,  didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        // The info dictionary contains multiple representations of the image, and this uses the original.
        let selectedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        // Dismiss the picker.
        dismissViewControllerAnimated(true, completion: nil)
        
        // connect the code with the view2 story board
        let View2VC = self.storyboard?.instantiateViewControllerWithIdentifier("view2") as!View2
        
        // Set the imageData field, which is View2's UIImageView image
        View2VC.imageData = UIImageJPEGRepresentation(selectedImage, 1.0)

        let navigationController = UINavigationController(rootViewController: View2VC)
        
        // show view2 view controller
        presentViewController(navigationController, animated: true, completion: nil)
    }
    
    
    // MARK: Action
    // ----------------- selection functions ------------------------ //
    @IBAction func selectSearchChoice(sender: UITapGestureRecognizer) {
        // Show Action Sheet
        let optionMenu = UIAlertController(title: nil, message: "Choose Option", preferredStyle: .ActionSheet)
        
        // Choice of using camera
        let CameraAction = UIAlertAction(title: "Camera", style: .Default, handler: {
            (alert: UIAlertAction!) -> Void in
            print("Camera")
            let CameraVC = self.storyboard?.instantiateViewControllerWithIdentifier("viewController") as!ViewController
            let navigationController = UINavigationController(rootViewController: CameraVC)
            // show camera view controller
            self.presentViewController(navigationController, animated: true, completion: nil)
        })
        
        
        
        // Choice of choosing existent photo
        let PhotoLibraryAction = UIAlertAction(title: "Photo Library", style: .Default, handler: {
            (alert: UIAlertAction!) -> Void in
            print("Photo Library")
            // UIImagePickerController is a view controller that lets a user pick media from their photo library
            let imagePickerController = UIImagePickerController()
            
            // Only allow photos to be picked, not taken
            imagePickerController.sourceType = .PhotoLibrary
            
            // Mke sure ViewController is notified when the user picks an image
            imagePickerController.delegate = self
            
            // show photo library
            self.presentViewController(imagePickerController, animated: true, completion: nil)
            
        })
        
        
        // Choice of selecting attributes
        let AttributesAction = UIAlertAction(title: "Attributes", style: .Default, handler: {
            (alert: UIAlertAction!) -> Void in
            print("Attributes")
            // connect attribute storyboard to Home view
            let AttributeStoryboard = UIStoryboard(name: "Attribute", bundle: nil)
            // connect attribute view from code to attribute storyboard
            let AttributeVC = AttributeStoryboard.instantiateViewControllerWithIdentifier("attributeView") as!AttributeView
            let navigationController = UINavigationController(rootViewController: AttributeVC)
            // show attribute option
            self.presentViewController(navigationController, animated: true, completion: nil)

            
        })
        
        
        // A test image choice for debugging means
        let TestImageAction = UIAlertAction(title: "Test Image", style: .Default, handler: {
            (alert:UIAlertAction!) -> Void in
            // connect TestVC from code to storyboard
            let TestVC = self.storyboard?.instantiateViewControllerWithIdentifier("testView") as!TestView
            let navigationController = UINavigationController(rootViewController: TestVC)
            //navigationController.navigationItem.backBarButtonItem=UIBarButtonItem()
            self.presentViewController(navigationController, animated: true, completion: nil)
            
        })
        
        
        // Cancel selections
        let CancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: {
            (alert: UIAlertAction!) -> Void in
            //self.dismissViewControllerAnimated(true, completion: nil)
        })
        
    
        // Adding actions to choice lists
        optionMenu.addAction(CameraAction)
        optionMenu.addAction(PhotoLibraryAction)
        optionMenu.addAction(AttributesAction)
        optionMenu.addAction(TestImageAction)
        optionMenu.addAction(CancelAction)
        
        // Present option menu
        self.presentViewController(optionMenu, animated: true, completion: nil)
    }
    
}