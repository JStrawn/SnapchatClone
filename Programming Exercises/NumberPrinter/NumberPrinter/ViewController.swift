//
//  ViewController.swift
//  NumberPrinter
//
//  Created by Juliana Strawn on 5/11/17.
//  Copyright © 2017 JStrawn. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var wordsLabel: UILabel!
    @IBOutlet weak var numbersTextField: UITextField!
    
    var numbersDictionary = [String : String]()
    var tensDictionary = [String : String]()
    
    var numbersAsWords: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        numbersDictionary = ["1" : "one",
                             "2" : "two",
                             "3" : "three",
                             "4" : "four",
                             "5" : "five",
                             "6" : "six",
                             "7" : "seven",
                             "8" : "eight",
                             "9" : "nine",
                             "10" : "ten",
                             "0" : ""]
        
        tensDictionary = ["1" : "teen",
                          "2" : "twenty",
                          "3" : "thirty",
                          "4" : "forty",
                          "5" : "fifty",
                          "6" : "sixty",
                          "7" : "seventy",
                          "8" : "eighty",
                          "9" : "ninety",
                          "0" : ""]
        
    }
    
    
    @IBAction func convertNumbersToWords(_ sender: UIButton) {
        
        var numberString = numbersTextField.text
        let numberStringLength = Int((numberString?.characters.count)!)
        
        numbersAsWords = ""
        
        // Switch cases
        switch numberStringLength {
            
            
        case 1:
            numberString = getOneNumber(string: numberString!)
            numbersAsWords = numberString
            
        case 2:
            
            numberString = getTwoNumbers(numberString: numberString!)
            numbersAsWords = numberString
            
        case 3:
            let firstDigit = numberString?.characters.first?.description
            let hundredString = getOneNumber(string: firstDigit!)
            let lastTwoDigits = numberString?.substring(from:(numberString?.index((numberString?.endIndex)!, offsetBy: -2))!)
            let tensString = getTwoNumbers(numberString: lastTwoDigits!)
            numbersAsWords = "\(hundredString) hundred and \(tensString)"
            
        case 4:
            let firstDigit = numberString?.characters.first?.description
            let thousandString = getOneNumber(string: firstDigit!)
            let secondDigit = numberString?.substring(from: (numberString?.index((numberString?.startIndex)!, offsetBy: 1))!)
            let hundredString = getOneNumber(string: secondDigit!)
            let lastTwoDigits = numberString?.substring(from:(numberString?.index((numberString?.endIndex)!, offsetBy: -2))!)
            let tensString = getTwoNumbers(numberString: lastTwoDigits!)
            
            var optionalHundred = ""
            if hundredString != "" {
                optionalHundred = "hundred"
            }
            numbersAsWords = "\(thousandString) thousand \(hundredString) \(optionalHundred) and \(tensString)"
            
        case 5:
            let firstTwoDigits = numberString?.substring(to:(numberString?.index((numberString?.startIndex)!, offsetBy: 2))!)
            let thousandString = getTwoNumbers(numberString: firstTwoDigits!)
            let thirdDigit = numberString?[2]
            let hundredString = getOneNumber(string: thirdDigit!)
            let lastTwoDigits = numberString?.substring(from:(numberString?.index((numberString?.endIndex)!, offsetBy: -2))!)
            let tensString = getTwoNumbers(numberString: lastTwoDigits!)

            var optionalHundred = ""
            if hundredString != "" {
                optionalHundred = "hundred"
            }
            numbersAsWords = "\(thousandString) thousand \(hundredString) \(optionalHundred) and \(tensString)"

        case 6:
            let firstDigit = numberString?[0]
            let hundredThousand = getOneNumber(string: firstDigit!)
            let tenThousands = getTwoNumbers(numberString:  (numberString?[Range(1...2)])!)
            let hundredString = getOneNumber(string: (numberString?[3])!)
            let tenString = getTwoNumbers(numberString: (numberString?[Range(4...5)])!)

            var optionalHundred = ""
            if hundredString != "" {
                optionalHundred = "hundred"
            }
            
            var firstOptionalAnd = ""
            if tenThousands != " " {
                firstOptionalAnd = "and"
            }
            
            var optionalAnd = ""
            if tenString != " " {
                optionalAnd = "and"
            }
            numbersAsWords = "\(hundredThousand) hundred \(firstOptionalAnd) \(tenThousands) thousand \(hundredString) \(optionalHundred) \(optionalAnd) \(tenString)"
            
        case 7:
            let million = getOneNumber(string: (numberString?[0])!)
            let hundredThousand = getOneNumber(string: (numberString?[1])!)
            let tenThousand = getTwoNumbers(numberString: (numberString?[Range(2...3)])!)
            let hundred = getOneNumber(string: (numberString?[4])!)
            let tens = getTwoNumbers(numberString:  (numberString?[Range(5...6)])!)
            
            var firstOptionalHundred = ""
            if hundredThousand != "" {
                firstOptionalHundred = "hundred"
            }
            
            var firstOptionalThousand = ""
            if tenThousand != " " {
                firstOptionalThousand = "thousand"
            }
            
            var secondOptionalHundred = ""
            if hundred != "" {
                secondOptionalHundred = "hundred"
            }
            
            var optionalAnd = ""
            if tens != " " {
                optionalAnd = "and"
            }
            
            numbersAsWords = "\(million) million \(hundredThousand) \(firstOptionalHundred) \(tenThousand) \(firstOptionalThousand) \(hundred) \(secondOptionalHundred) \(optionalAnd) \(tens)"
            
        case 8:
            let tenMillion = getTwoNumbers(numberString: (numberString?[Range(0...1)])!)
            let hundredThousand = getOneNumber(string: (numberString?[2])!)
            let tenThousand = getTwoNumbers(numberString: (numberString?[Range(3...4)])!)
            let hundred = getOneNumber(string: (numberString?[5])!)
            let tens = getTwoNumbers(numberString:  (numberString?[Range(6...7)])!)

            var firstOptionalHundred = ""
            if hundredThousand != "" {
                firstOptionalHundred = "hundred"
            }
            
            var firstOptionalThousand = ""
            if tenThousand != " " {
                firstOptionalThousand = "thousand"
            }
            
            var secondOptionalHundred = ""
            if hundred != "" {
                secondOptionalHundred = "hundred"
            }
            
            var optionalAnd = ""
            if tens != " " {
                optionalAnd = "and"
            }
            
            numbersAsWords = "\(tenMillion) million \(hundredThousand) \(firstOptionalHundred) \(tenThousand) \(firstOptionalThousand) \(hundred) \(secondOptionalHundred) \(optionalAnd) \(tens)"
            
        case 9:
            let hundredMillion = getOneNumber(string: (numberString?[0])!)
            let tenMillion = getTwoNumbers(numberString: (numberString?[Range(1...2)])!)
            let hundredThousand = getOneNumber(string: (numberString?[3])!)
            let tenThousand = getTwoNumbers(numberString: (numberString?[Range(4...5)])!)
            let hundred = getOneNumber(string: (numberString?[6])!)
            let tens = getTwoNumbers(numberString:  (numberString?[Range(7...8)])!)
            
            var firstOptionalHundred = ""
            if hundredThousand != "" {
                firstOptionalHundred = "hundred"
            }
            
            var firstOptionalThousand = ""
            if tenThousand != " " {
                firstOptionalThousand = "thousand"
            }
            
            var secondOptionalHundred = ""
            if hundred != "" {
                secondOptionalHundred = "hundred"
            }
            
            var optionalAnd = ""
            if tens != " " {
                optionalAnd = "and"
            }
            
            numbersAsWords = "\(hundredMillion) hundred \(tenMillion) million \(hundredThousand) \(firstOptionalHundred) \(tenThousand) \(firstOptionalThousand) \(hundred) \(secondOptionalHundred) \(optionalAnd) \(tens)"
            
        case 10:
            let billion =  getOneNumber(string: (numberString?[0])!)
            let hundredMillion = getOneNumber(string: (numberString?[1])!)
            let tenMillion = getTwoNumbers(numberString: (numberString?[Range(2...3)])!)
            let hundredThousand = getOneNumber(string: (numberString?[4])!)
            let tenThousand = getTwoNumbers(numberString: (numberString?[Range(5...6)])!)
            let hundred = getOneNumber(string: (numberString?[7])!)
            let tens = getTwoNumbers(numberString:  (numberString?[Range(8...9)])!)
            
            var firstOptionalHundred = ""
            if hundredMillion != "" {
                firstOptionalHundred = "hundred"
            }
            
            var optionalMillion = ""
            if (tenMillion != " ") && (hundredMillion != ""){
                optionalMillion = "million"
            }
            
            var firstOptionalThousand = ""
            if tenThousand != " " {
                firstOptionalThousand = "thousand"
            }
            
            var secondOptionalHundred = ""
            if hundredThousand != "" {
                secondOptionalHundred = "hundred"
            }
            
            var thirdOptionalHundred = ""
            if hundred != "" {
                thirdOptionalHundred = "hundred"
            }
            
            var optionalAnd = ""
            if tens != " " {
                optionalAnd = "and"
            }
            
            numbersAsWords = "\(billion) billion \(hundredMillion) \(firstOptionalHundred) \(tenMillion) \(optionalMillion) \(hundredThousand) \(secondOptionalHundred) \(tenThousand) \(firstOptionalThousand) \(hundred) \(thirdOptionalHundred) \(optionalAnd) \(tens)"
            
        default:
            numbersAsWords = "please enter a number with no commas"
        }
        
        wordsLabel.text = numbersAsWords
    }
    
    func getTwoNumbers(numberString:String) -> String {
        
        var myNumber = ""
        
        for (key, value) in tensDictionary {
            if (numberString.characters.first?.description == key) {
                myNumber.append("\(value)")
                
            }
        }
        
        for (key, value) in numbersDictionary {
            if (numberString.characters.last?.description == key) {
                if numberString.characters.first?.description == "1" {
                    for character in value.characters.reversed() {
                        if value == "one" {
                            myNumber = "eleven"
                        } else if value == "two" {
                            myNumber = "twelve"
                        } else if value == "three" {
                            myNumber = "thirteen"
                        } else if value == "five" {
                            myNumber = "fifteen"
                        } else {
                            myNumber.insert(character, at: numbersAsWords.startIndex)
                        }
                    }
                } else {
                    myNumber.append(" \(value)")
                }
            }
        }
        
        if numberString == "10" {
            myNumber = "ten"
        }
        
        return myNumber
    }
    
    
    func getOneNumber(string: String) -> String {
        
        var myNumber = ""
        
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
