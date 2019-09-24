//
//  ChangeCityViewController.swift
//  Clima
//
//  Created by Martynas Narijauskas on 9/22/19.
//  Copyright © 2019 Martynas Narijauskas. All rights reserved.
//

import UIKit

protocol ChangeCityDelegate {
    func userEnteredCityName(city : String)
}

class ChangeCityViewController: UIViewController {
    
    var delegate : ChangeCityDelegate?
    
    @IBOutlet weak var changeCityTextField: UITextField!

    
    @IBAction func getWeatherPressed(_ sender: AnyObject) {
        
        let cityName = changeCityTextField.text!
        
        delegate?.userEnteredCityName(city: cityName)
        
        self.dismiss(animated: true, completion: nil)
        
    }

    @IBAction func backButtonPressed(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
