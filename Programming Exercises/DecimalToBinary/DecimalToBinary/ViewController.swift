//
//  ViewController.swift
//  DecimalToBinary
//
//  Created by Juliana Strawn on 5/12/17.
//  Copyright © 2017 JStrawn. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var numberTextField: UITextField!
    @IBOutlet weak var binaryLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    var isNonBinary = true
    var userInput: String!
    var binaryOutput: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        isNonBinary = false
        binaryLabel.layer.cornerRadius = 10
        view.backgroundColor = UIColor.lightGray
        
        
    }
    
    @IBAction func getBinary(_ sender: UIButton) {
        
        binaryOutput = ""
        userInput = numberTextField.text
        var userInt = Int(userInput)

        while userInt! > 0 {
            userInt = isOdd(integer: userInt!)
            userInt = userInt!/2
        }
        
        binaryLabel.text = binaryOutput
        
    }
    
    func isOdd(integer: Int) -> Int {
        if integer % 2 == 0 {
            // even number
            binaryOutput.insert("0", at: binaryOutput.startIndex)
            return integer
        } else {
            // odd number
            binaryOutput.insert("1", at: binaryOutput.startIndex)
            return integer - 1
        }
    }
    
    @IBAction func getNonbinary(_ sender: UIButton) {
        if isNonBinary == false {
            imageView.isHidden = false
            imageView.image = #imageLiteral(resourceName: "Transgender sign")
            view.backgroundColor = UIColor.purple
            binaryLabel.textColor = UIColor.white
            isNonBinary = true
            binaryLabel.backgroundColor = UIColor.blue
        } else if isNonBinary == true {
            imageView.isHidden = true
            view.backgroundColor = UIColor.lightGray
            binaryLabel.backgroundColor = UIColor.lightGray
            binaryLabel.textColor = UIColor.black
            isNonBinary = false
        }
    }
    
}

