//
//  ViewController.swift
//  WeatherApp
//
//  Created by Angela Yu on 23/08/2015.
//  Copyright (c) 2015 London App Brewery. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire
import SwiftyJSON


class WeatherViewController: UIViewController, CLLocationManagerDelegate, ChangeCityDelegate {
    
    //Constants
    let WEATHER_URL = "http://api.openweathermap.org/data/2.5/weather"
//    let APP_ID = "e72ca729af228beabd5d20e3b7749713" // App brewery App id
    let APP_ID = "3a5bcb0cf9d4b4fd921469551c8b5de9"
    /***Get your own App ID at https://openweathermap.org/appid ****/
    
    
    //TODO: Declare instance variables here
    let locationManager = CLLocationManager()
    
    let weatherDataModel = WeatherDataModel()
    
    var weatherInitial = ""
    var degree = ""
    
    
    
    //Pre-linked IBOutlets
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //TODO:Set up the location manager here.
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
        
        locationManager.startUpdatingLocation()
        
        
        
    }
    
    
    
    //MARK: - Networking
    /***************************************************************/
    
    //Write the getWeatherData method here:
    func getWeatherData(url: String, parameters: [String : String]) {
        
        // asunchrouns process, running in the background
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON {
            (response) in
            //response in
            if response.result.isSuccess{
                print("Success! Got the weather data")
                // safe to forceunwrap when success, and cast to JSON,
                let weatherJSON : JSON = JSON(response.result.value!)
                print(weatherJSON)
                self.updateWeatherData(json: weatherJSON)
                
                
                /*
                 {
                 "clouds" : {
                 "all" : 75
                 },
                 "visibility" : 10000,
                 "main" : {
                 "feels_like" : 309.73000000000002,
                 "temp_min" : 304.14999999999998,
                 "temp" : 304.44,
                 "temp_max" : 305.37,
                 "humidity" : 74,
                 "pressure" : 1013
                 },
                 "cod" : 200,
                 "dt" : 1592189968,
                 "id" : 1705271,
                 "sys" : {
                 "country" : "PH",
                 "id" : 8160,
                 "sunrise" : 1592170107,
                 "type" : 1,
                 "sunset" : 1592216736
                 },
                 "weather" : [
                 {
                 "id" : 803,
                 "description" : "broken clouds",
                 "main" : "Clouds",
                 "icon" : "04d"
                 }
                 ],
                 "base" : "stations",
                 "timezone" : 28800,
                 "wind" : {
                 "deg" : 280,
                 "speed" : 2.6000000000000001
                 },
                 "coord" : {
                 "lon" : 120.88,
                 "lat" : 14.08
                 },
                 "name" : "Luksuhin"
                 }
                 */
                
            } else {
                //                print("Error \(response.result.error)")
                print("Error \(String(describing: response.result.error))")
                self.cityLabel.text = "Connection Issues"
            }
        }
    }
    
    
    
    
    
    //MARK: - JSON Parsing
    /***************************************************************/
    
    
    //Write the updateWeatherData method here:
    func updateWeatherData(json: JSON) {
        
        // from swiftyJSON library, tempResult has now assign the value of 304.44
        // optional binding for safe programming, when APIKEY get screwd
        if let tempResult = json["main"]["temp"].double {
            // tempResult is expressed in kelvin, so minus it to 273.15 to convert into celcius
//            weatherDataModel.temperature = Int(tempResult! - 273.15)
            
            // forceunwrap (!) is no need anymore because its inside the optional binding
            weatherDataModel.temperature = Int(tempResult - 273.15)
            
            // to assign the name of city/location
            weatherDataModel.city = json["name"].stringValue
            
            // to assign the id of weather conditon in the location
            weatherDataModel.condition = json["weather"][0]["id"].intValue
            let weatherConditionID = weatherDataModel.condition
            
            // assign the weather icon with ID of weather condition
            weatherDataModel.weatherIconName = weatherDataModel.updateWeatherIcon(condition: weatherConditionID)
            
            // call method to update UI
            updateUIWithWeatherData()
            
        } else {
            cityLabel.text = "Weather Unavailable"
        }
    }
    
    
    
    
    //MARK: - UI Updates
    /***************************************************************/
    
    
    //Write the updateUIWithWeatherData method here:
    
    func updateUIWithWeatherData() {
        // updating UI by the used of weatherDataModel
        cityLabel.text = weatherDataModel.city
//        temperatureLabel.text = String(weatherDataModel.temperature) + "°"
        
        temperatureLabel.text = "\(weatherDataModel.temperature)℃"
        weatherIcon.image = UIImage(named: weatherDataModel.weatherIconName)
        
                
    }
    
    @IBAction func toggleDegree(_ sender: UISegmentedControl) {
        
//        updateUIWithWeatherData()
        
        if sender.selectedSegmentIndex == 0 {
            temperatureLabel.text = "\(weatherDataModel.temperature)℃"
        } else if sender.selectedSegmentIndex == 1 {
            let far = Int(Double(weatherDataModel.temperature) + 273.15)
            temperatureLabel.text = "\(far)℉"
        }
    }
    
    
    
    
    
    
    
    
     
    //MARK: - Location Manager Delegate Methods
    /***************************************************************/
    
    
    //Write the didUpdateLocations method here:
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // setting the location to the last value of the array locations
        let location = locations[locations.count - 1]
        
        // check if the location is not invalid. Greater than zero
        if location.horizontalAccuracy > 0 {
            // stop updating location when got a valid result, also stop consuming more battery
            locationManager.stopUpdatingLocation()
            print("longitude = \(location.coordinate.longitude), latitude = \(location.coordinate.latitude)")
            
            let latitude = String(location.coordinate.latitude)
            let longitude = String(location.coordinate.longitude)
            
            let params : [String : String] = ["lat" : latitude, "lon" : longitude, "appid" : APP_ID]
            
            getWeatherData(url: WEATHER_URL, parameters: params)
        }
    }
    
    
    
    //Write the didFailWithError method here:
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
        cityLabel.text = "Location Unavailable"
    }
    
    
    
    
    //MARK: - Change City Delegate methods
    /***************************************************************/
    
    
    //Write the userEnteredANewCityName Delegate method here:
    func userEnteredANewCity(city: String) {
        print(city)
        
        let params : [String : String] = ["q" : city, "appid" : APP_ID]
        getWeatherData(url: WEATHER_URL, parameters: params)
    }
    
    
    
    //Write the PrepareForSegue Method here
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // if true go the ChangeCityViewController
        if segue.identifier == "changeCityName" {
            
            // assign the destinationVC as ChangeCityViewController
            let destinationVC = segue.destination as! ChangeCityViewController
            
            // set the delegate as self
            destinationVC.delegate = self
        }
    }
    
    
    
    
}


