//
//  Attribute.swift
//  BirdLookupPart0
//
//  Created by seab on 12/15/15.
//  Copyright © 2015 Kareem Moussa. All rights reserved.
//


import UIKit

class Attribute: UIViewController {
    
    //MARK: Properties
    
    @IBOutlet weak var HomeButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Handle the text field's user input through delegate callbacks.
        
    }
    
    //MARK: Action
    
    @IBAction func backHome(sender: UIBarButtonItem) {
        let HomeVC = self.storyboard?.instantiateViewControllerWithIdentifier("homeView") as!HomeView
        self.presentViewController(HomeVC, animated: true, completion: nil)
    }
    
}