//
//  ViewController.swift
//  HelloWorld
//
//  Created by Oliver Kramer on 07/02/2020.
//  Copyright © 2020 Oliver Kramer. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var inputField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


    @IBAction func btnPressed(_ sender: UIButton) {
        if let name = nameLabel.text {
           nameLabel.text = "Hello \(name)"
        }
    }
}
