//
//  SecondViewController.swift
//  Segues play
//
//  Created by Jaypee Umandap on 6/15/20.
//  Copyright © 2020 Jervy Umandap. All rights reserved.
//

import UIKit

// create a protocol
protocol CanReceive {
    func dataReceived(data : String)
}

class SecondViewController: UIViewController {
    
    // create property that is of type CanReceive?, optioanal so it might be nil
    var delegate : CanReceive?
    var message : String = ""
    
    @IBOutlet weak var secondVClabel: UILabel!
    @IBOutlet weak var secondVCTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        secondVClabel.text = message
        
    }
    
    @IBAction func secondVCPassButtonWasPressed(_ sender: UIButton) {
        delegate?.dataReceived(data: secondVCTextField.text!)
        dismiss(animated: true, completion: nil)
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
