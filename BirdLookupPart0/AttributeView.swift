//
//  AttributeView.swift
//  BirdLookupPart0
//
//  Created by Yuhan Dai on 12/15/15.
//  Copyright © 2015 Yuhan Dai. All rights reserved.
//

import UIKit

class AttributeView: UIViewController, UITextFieldDelegate {
    
    //MARK: Properties
    @IBOutlet weak var HomeButton: UIBarButtonItem!
    @IBOutlet weak var SizeText: UITextField!
    @IBOutlet weak var HeadText: UITextField!
    @IBOutlet weak var BreastText: UITextField!
    @IBOutlet weak var WingText: UITextField!
    @IBOutlet weak var EyeText: UITextField!
    
    @IBOutlet weak var SearchButton: UIButton!
    
    // override functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        SizeText.delegate = self
        HeadText.delegate = self
        BreastText.delegate = self
        WingText.delegate = self
        EyeText.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: UITextFieldDelegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        //Hide the keyboard.
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(textField: UITextField) {

    }
    
    //MARK: Actions
    // Home button action that send us back to home page
    @IBAction func backHome(sender: UIBarButtonItem) {
        // declare variable connect to home screen
        let MainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
        // connect home view to attrivute view
        let HomeVC = MainStoryBoard.instantiateViewControllerWithIdentifier("homeView") as!HomeView
        // show home view
        self.presentViewController(HomeVC, animated: true, completion: nil)
    }
    
    // Search Action that searchs birds based on the given attibute
    @IBAction func SearchAction(sender: UIButton) {
        let searchVC = self.storyboard?.instantiateViewControllerWithIdentifier("searchView") as!SearchView
        let navigationController = UINavigationController(rootViewController: searchVC)
        self.presentViewController(navigationController, animated: true, completion: nil)
    }
    
}
