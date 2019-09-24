//
//  VWeatherViewController.swift
//  Clima
//
//  Created by Martynas Narijauskas on 9/22/19.
//  Copyright © 2019 Martynas Narijauskas. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire
import SwiftyJSON

class WeatherViewController: UIViewController, CLLocationManagerDelegate, ChangeCityDelegate {
    
    let WEATHER_URL = "http://api.openweathermap.org/data/2.5/weather"
    let APP_ID = "4075e6ffe155ff174aec14794dfeb235"
    
    let locationManager = CLLocationManager()
    let weatherDataModel = WeatherDataModel()
    
    var temperatureInCelsius = true

    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        let temperatureLabelTap = UITapGestureRecognizer(target: self, action: #selector(self.temperatureLabelTapped(_:)))
        temperatureLabel.addGestureRecognizer(temperatureLabelTap)
        
        }
    
   @objc func temperatureLabelTapped(_ sender: UITapGestureRecognizer){
    
        if temperatureInCelsius{
            weatherDataModel.temperature = Int(round(Double(weatherDataModel.temperature) * 1.8 + 32.0))
            temperatureLabel.text = "\(weatherDataModel.temperature) F"
            temperatureInCelsius = false
        }
        else{
            weatherDataModel.temperature = Int(round((Double(weatherDataModel.temperature) - 32.0) / 1.8))
            temperatureLabel.text = "\(weatherDataModel.temperature) C"
            temperatureInCelsius = true
        }
    }

    func getWeatherData(url : String, params : [String: String]){
        Alamofire.request(url, method: .get, parameters: params).responseJSON{ response in
            
            if response.result.isSuccess{
                let weatherJSON : JSON = JSON(response.result.value!)
                print(weatherJSON)
                self.updateWeatherData(json: weatherJSON)
            }
            else{
                print(response.result.error)
                self.cityLabel.text = "Connection error"
            }
            
        }
    }

    func updateWeatherData(json : JSON){
        if let temperature = json["main"]["temp"].double{
            if(temperatureInCelsius){
                weatherDataModel.temperature = Int(temperature - 273.15)
            }
            else{
                weatherDataModel.temperature = Int(round((temperature - 273.15) * 1.8 + 32))
            }
            weatherDataModel.city = json["name"].stringValue
            weatherDataModel.condition = json["weather"][0]["id"].intValue
            weatherDataModel.weatherIconName = weatherDataModel.updateWeatherIcon(condition: weatherDataModel.condition)
            
            updateUIWithWeatherData()
            
        }
        else{
            cityLabel.text = "Weather unavailable"
        }
    }
    
    func updateUIWithWeatherData(){
        cityLabel.text = weatherDataModel.city
        if temperatureInCelsius {
            temperatureLabel.text = "\(weatherDataModel.temperature) C"
        }
        else{
            temperatureLabel.text = "\(weatherDataModel.temperature) F"

        }
        weatherIcon.image = UIImage(named :weatherDataModel.weatherIconName)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[locations.count - 1]
        
        if location.horizontalAccuracy > 0 {
            locationManager.stopUpdatingLocation()
            locationManager.delegate = nil
            
            print("Lat: \(location.coordinate.latitude) long: \(location.coordinate.longitude)")
            
            let params : [String : String] = ["lat" : String(location.coordinate.latitude), "lon" : String(location.coordinate.longitude), "appid" : APP_ID]
            
            getWeatherData(url: WEATHER_URL, params: params)

        }
    }
    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
        cityLabel.text = "City unavailable"
    }
 
    func userEnteredCityName(city: String) {
        let params : [String : String] = ["q" : city, "appid" : APP_ID]
        getWeatherData(url: WEATHER_URL, params: params)
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "changeCityName"{
            let vc = segue.destination as! ChangeCityViewController
            vc.delegate = self
        }
    }

}
