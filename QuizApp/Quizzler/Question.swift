 //
//  Question.swift
//  Quizzler
//
//  Created by Martynas Narijauskas on 9/11/19.
//  Copyright © 2019 London App Brewery. All rights reserved.
//

import Foundation

 class Question {
    
    let text : String
    let correctAnswer : Bool
    
    init(text : String, correctAnswer : Bool){
        self.text = text
        self.correctAnswer = correctAnswer
    }
    
 }
