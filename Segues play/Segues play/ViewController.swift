//
//  ViewController.swift
//  Segues play
//
//  Created by Jaypee Umandap on 6/15/20.
//  Copyright © 2020 Jervy Umandap. All rights reserved.
//

import UIKit

// conform to protocol CanReceive
class ViewController: UIViewController, CanReceive {
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var textField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }

    
    @IBAction func passButtonWasPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "sendDataForwards", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "sendDataForwards" {
            
            // grab hold to the reference to the SecondViewController
            let secondVC = segue.destination as! SecondViewController
            
            secondVC.message = textField.text!
            
            //set the secondVC delegate as this current VC
            secondVC.delegate = self
                        
        }
    }
    
    // implement the required delegate method
    func dataReceived(data: String) {
        label.text = data
    }
    
    @IBAction func changeColorWasPressed(_ sender: UIButton) {
        view.backgroundColor = UIColor.blue
    }
    
    
}

