//
//  ViewController.swift
//  StringToNumber
//
//  Created by Juliana Strawn on 5/12/17.
//  Copyright © 2017 JStrawn. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var stringInput: UITextField!
    
    var numbersString:String!
    var myInt:Int!
    var myFinalInt:Int!
    var numbersDictionary = [String : Int]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        numbersDictionary = ["1" : 1,
                             "2" : 2,
                             "3" : 3,
                             "4" : 4,
                             "5" : 5,
                             "6" : 6,
                             "7" : 7,
                             "8" : 8,
                             "9" : 9,
                             "0" : 0]
    }
    
    @IBAction func buttonWasPressed(_ sender: UIButton) {
        
        var myMultipliedInt = 0
        numbersString = stringInput.text
        
        for _ in numbersString.characters {
            let numberOfCharacters = numbersString.characters.count
            if numberOfCharacters > 0 {
                // get number
                myInt = getOneNumber(string: numbersString[0])
                
                // multiply that number by 1000 or however many zeros would be there
                var multiplierString = ""
                for number in numbersString.characters {
                    multiplierString.append(number)
                }
                
                // turn multiplier into an int
                var multiplier = 1
                for _ in (multiplierString.characters) {
                    multiplier = multiplier * 10
                }
                
                //the for loop runs one too many times so divide by 10
                multiplier = multiplier/10
                
                
                myMultipliedInt = myMultipliedInt + (myInt * multiplier)
                
                myFinalInt = myMultipliedInt
                
                // remove it from the string and do the same until string is empty
                numbersString.remove(at: numbersString.startIndex)
            }
            
            print(myFinalInt)

            
        }
        

    }
    
    func getOneNumber(string: String) -> Int {
        
        var myNumber:Int = 0
        
        for (key, value) in numbersDictionary {
            if (string.contains(key))
            {
                myNumber = value
            }
            
        }
        return myNumber
    }

    
    
}


extension String {
    
    var length: Int {
        return self.characters.count
    }
    
    subscript (i: Int) -> String {
        return self[Range(i ..< i + 1)]
    }
    
    func substring(from: Int) -> String {
        return self[Range(min(from, length) ..< length)]
    }
    
    func substring(to: Int) -> String {
        return self[Range(0 ..< max(0, to))]
    }
    
    subscript (r: Range<Int>) -> String {
        let range = Range(uncheckedBounds: (lower: max(0, min(length, r.lowerBound)),
                                            upper: min(length, max(0, r.upperBound))))
        let start = index(startIndex, offsetBy: range.lowerBound)
        let end = index(start, offsetBy: range.upperBound - range.lowerBound)
        return self[Range(start ..< end)]
    }
    
}





