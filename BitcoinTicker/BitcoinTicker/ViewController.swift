//
//  ViewController.swift
//  BitcoinTicker
//
//  Created by Martynas Narijauskas on 9/25/19.
//  Copyright © 2019 Martynas Narijauskas. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    let baseURL = "https://apiv2.bitcoinaverage.com/indices/global/ticker/BTC"
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    let currencySign = ["$", "R$", "$", "¥", "€", "£", "$", "Rp", "₪", "₹", "¥", "$", "kr", "$", "zł", "lei", "₽", "kr", "$", "$", "R"]
    var finalURL = ""
    var currentSign = ""

    @IBOutlet weak var bitcoinPriceLabel: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currencyPicker.delegate = self
        currencyPicker.dataSource = self
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currencyArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return currencyArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        finalURL = baseURL + currencyArray[row]
        currentSign = currencySign[row]
        getBitcoinInfo()
    }
    
    func getBitcoinInfo(){
        Alamofire.request(finalURL, method: .get).responseJSON{ response in
            if response.result.isSuccess{
                let bitcoinJSON = JSON(response.result.value)
                self.updateJSONInfo(json: bitcoinJSON)
            }
            else{
                self.bitcoinPriceLabel.text = "Service is unavailable"
            }
        }
    }

    func updateJSONInfo(json : JSON){
        if let bitcoinValue = json["ask"].double{
            bitcoinPriceLabel.text = "\(currentSign) \(bitcoinValue)"
        }
        else{
            bitcoinPriceLabel.text = "No currency was found"
        }
    }

}
