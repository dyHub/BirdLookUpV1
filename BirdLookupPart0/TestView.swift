//
//  TestView.swift
//  BirdLookupPart0
//
//  Created by seab on 12/7/15.
//  Copyright © 2015 Kareem Moussa. All rights reserved.
//


import UIKit

class TestView: UIViewController {
    
    @IBOutlet weak var TestImage: UIImageView!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        TestImage.hidden = false
    }
    
}