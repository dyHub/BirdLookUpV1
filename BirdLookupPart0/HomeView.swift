//
//  HomeView.swift
//  BirdLookupPart0
//
//  Created by seab on 12/7/15.
//  Copyright © 2015 Kareem Moussa. All rights reserved.
//

import UIKit

class HomeView: UIViewController {

    // MARK: Properties
    
    @IBOutlet weak var HomeImage: UIImageView!
    
    // MARK: Action
    
    @IBAction func selectSearchChoice(sender: UITapGestureRecognizer) {
        // Show Action Sheet
        let optionMenu = UIAlertController(title: nil, message: "Choose Option", preferredStyle: .ActionSheet)
        
        // Choice of using camera
        let CameraAction = UIAlertAction(title: "Camera", style: .Default, handler: {
            (alert: UIAlertAction!) -> Void in
            print("Camera")
            let CameraVC = ViewController()
            var navigationController = UINavigationController(rootViewController: CameraVC)
            self.presentViewController(navigationController , animated: true, completion: nil)
        })
        
        // Choice of choosing existent photo
        let PhotoLibraryAction = UIAlertAction(title: "Photo Library", style: .Default, handler: {
            (alert: UIAlertAction!) -> Void in
            print("Photo Library")
        })
        
        // Choice of selecting attributes
        let AttributesAction = UIAlertAction(title: "Attributes", style: .Default, handler: {
            (alert: UIAlertAction!) -> Void in
            print("Attributes")
        })
        
        let TestImageAction = UIAlertAction(title: "Test Image", style: .Default, handler: {
            (alert:UIAlertAction!) -> Void in
            let TestVC = TestView()
            var navigationController = UINavigationController(rootViewController: TestVC)
            self.presentViewController(navigationController , animated: true, completion: nil)
            
        })
        
        // Cancel selections
        let CancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: {
            (alert: UIAlertAction!) -> Void in
            self.dismissViewControllerAnimated(true, completion: nil)
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