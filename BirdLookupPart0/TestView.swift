//
//  TestView.swift
//  BirdLookupPart0
//
//  Created by seab on 12/7/15.
//  Copyright © 2015 Kareem Moussa. All rights reserved.
//


import UIKit

class TestView: UIViewController {
    
    // Mark: Properties
    @IBOutlet weak var TestImage: UIImageView!
    @IBOutlet weak var HomeButton: UIBarButtonItem!

    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        TestImage.hidden = false
        
    }
    
    // Mark: Action
    // Home button present home view
    @IBAction func backHome(sender: UIBarButtonItem) {
        let HomeVC = self.storyboard?.instantiateViewControllerWithIdentifier("homeView") as!HomeView
        self.presentViewController(HomeVC, animated: true, completion: nil)
    }
    
}