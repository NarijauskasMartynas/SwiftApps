//
//  ViewController.swift
//  Calculator
//
//  Created by Martynas Narijauskas on 30/10/19.
//  Copyright © 2019 Martynas Narijauskas. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var displayLabel: UILabel!
    	
    private var isFinishedTyping : Bool = true
    
    var calcModule = CalculatorModule()
    
    private var displayValue : Double {
        get{
            guard let numberToDisplay = Double(displayLabel.text!) else{
                fatalError("Cannot convert text to double")
                }
            return numberToDisplay
        }
        set{
            displayLabel.text = String(newValue)
        }
    }
    
    @IBAction func calcButtonPressed(_ sender: UIButton) {
        
        isFinishedTyping = true
        
        guard let buttonTitle = sender.currentTitle else{
            fatalError("Title is nil")
        }
        
        calcModule.setNumber(displayValue)
        
        if let calculatedNumber = calcModule.performOperations(operationToDo: buttonTitle){
            displayValue = calculatedNumber
        }
    }

    
    @IBAction func numButtonPressed(_ sender: UIButton) {
        
        if let numberValue = sender.currentTitle{
            
            if isFinishedTyping {
                if(numberValue == "."){
                    displayLabel.text = "0."
                }
                else{
                    displayLabel.text = numberValue
                }
                isFinishedTyping = false
            }
            else{
                
                if numberValue == "." {
                    
                    let isInt = floor(displayValue) == displayValue
                    
                    if !isInt {
                        return
                    }
                }
                
                displayLabel.text = displayLabel.text! + numberValue

            }
        
        }
    
    }

}

