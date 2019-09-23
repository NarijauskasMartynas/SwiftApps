//
//  ViewController.swift
//  Calculator 2
//
//  Created by Martynas Narijauskas on 9/22/19.
//  Copyright © 2019 Martynas Narijauskas. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var numberLabel: UILabel!
    var result : Double = 0
    var previousNumber : Double = 0
    var operation : String = ""
    var isCalculation : Bool = true

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        numberLabel.text = "\(result)"
    }
    
    @IBAction func numberButtonPressed(_ sender: UIButton) {
        switch sender.tag {
        case 10:
            //AC tag = 10
            numberLabel.text = "0"
            previousNumber = 0
            operation = ""
        case 11:
            //+/- tag = 11
            result = 0 - Double(numberLabel.text!.replacingOccurrences(of: ",", with: "."))!
            numberLabel.text = "\(result)"
        case 12:
            //, tag = 12
            if !numberLabel.text!.contains(".") && !numberLabel.text!.contains(","){
                numberLabel.text = numberLabel.text! + ","
            }
        case 13:
            //% tag = 13
            result = Double(numberLabel.text!.replacingOccurrences(of: ",", with: "."))! / 100
            numberLabel.text = "\(result)"
        case 14:
        // \ tag = 14
            previousNumber = Double(numberLabel.text!.replacingOccurrences(of: ",", with: "."))!
            operation = "/"
            isCalculation = true
        case 15:
            // x tag = 15
            previousNumber = Double(numberLabel.text!.replacingOccurrences(of: ",", with: "."))!
            operation = "x"
            isCalculation = true
        case 16:
            // - tag = 16
            previousNumber = Double(numberLabel.text!.replacingOccurrences(of: ",", with: "."))!
            operation = "-"
            isCalculation = true
        case 17:
            // + tag = 17
            previousNumber = Double(numberLabel.text!.replacingOccurrences(of: ",", with: "."))!
            operation = "+"
            isCalculation = true
        case 18:
            var result : Double = 0
            switch operation {
            case "/":
                if(Double(numberLabel.text!.replacingOccurrences(of: ",", with: "."))! == 0){
                    numberLabel.text = "Error"
                    isCalculation = true
                }
                else{
                    result = previousNumber / Double(numberLabel.text!.replacingOccurrences(of: ",", with: "."))!
                    numberLabel.text = String(result)
                }

            case "x":
                result = previousNumber * Double(numberLabel.text!.replacingOccurrences(of: ",", with: "."))!
                numberLabel.text = String(result)
            case "-":
                result = previousNumber - Double(numberLabel.text!.replacingOccurrences(of: ",", with: "."))!
                numberLabel.text = String(result)
            case "+":
                result = previousNumber + Double(numberLabel.text!.replacingOccurrences(of: ",", with: "."))!
                numberLabel.text = String(result)
            default:
                operation = ""
            }
        default:
            enterNumber(inputNumber: sender.tag)
        }
    }
    
    func enterNumber(inputNumber: Int){
        if(isCalculation){
            numberLabel.text = "\(inputNumber)"
            isCalculation = false
        }
        else{
            if(numberLabel.text == "0"){
                numberLabel.text = "\(inputNumber)"
            }
            else{
                numberLabel.text = numberLabel.text! + "\(inputNumber)"
            }
        }
    }
}
