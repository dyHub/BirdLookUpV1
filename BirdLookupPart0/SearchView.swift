//
//  SearchView.swift
//  BirdLookupPart0
//
//  Created by seab on 12/15/15.
//  Copyright © 2015 Kareem Moussa. All rights reserved.
//

import UIKit

class SearchView: UIViewController, UINavigationControllerDelegate {
    
    
    // MARK: Properties
    @IBOutlet weak var BackButton: UINavigationItem!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Action
    // back to the attribute view
    @IBAction func back(sender: UIBarButtonItem) {
        let AttributeVC = self.storyboard?.instantiateViewControllerWithIdentifier("attributeView") as!AttributeView
        let navigationController = UINavigationController(rootViewController: AttributeVC)
        self.presentViewController(navigationController, animated: true, completion: nil)
    }
}