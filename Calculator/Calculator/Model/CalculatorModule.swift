//
//  CalculatorModule.swift
//  Calculator
//
//  Created by Martynq on 01/11/2019.
//  Copyright © 2019 London App Brewery. All rights reserved.
//

import Foundation

struct CalculatorModule{
    
    private var number : Double?
    
    private var intermediateCalc : (number: Double, operation: String)?
    
    mutating func setNumber(_ number : Double){
        self.number = number
    }
    
    mutating func performOperations(operationToDo : String) -> Double?{
        
        if let num = number{
            switch operationToDo {
            case "+/-":
                number = num * -1
            case "AC":
                number = 0
            case "%":
                number = num / 100
            case "=":
                number = makeCalculation(number2: num)
            default:
                intermediateCalc = (number: num, operation: operationToDo)
            
        }}
        
        return number
    }
    
    private func makeCalculation(number2: Double) -> Double?{
        
        if let number1 = intermediateCalc?.number, let operationTodo = intermediateCalc?.operation{
            switch operationTodo {
            case "+":
                return number1 + number2
            case "-":
                return number1 - number2
            case "×":
                return number1 * number2
            case "÷":
                return number1 / number2
            default:
                fatalError("Operation not found")
            }
        }
        return nil
    }
}
