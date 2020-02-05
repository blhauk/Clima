//
//  ViewController.swift
//  Clima
//
//  Created by Angela Yu on 01/09/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {

    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var sunrise: UILabel!
    @IBOutlet weak var sunset: UILabel!
    
    var weatherManager = WeatherManager()
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        //locationManager.requestLocation()
        locationManager.startUpdatingLocation()

        
        weatherManager.delegate  = self
        searchTextField.delegate = self
    }
    @IBAction func locationPressed(_ sender: UIButton) {
        //locationManager.requestLocation()
        locationManager.startUpdatingLocation()
    }
}

//MARK: - UITextFieldDelegate
extension WeatherViewController: UITextFieldDelegate {
    @IBAction func searchPressed(_ sender: UIButton) {
        searchTextField.endEditing(true)
        print(searchTextField.text!)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.endEditing(true)
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            textField.placeholder = "Search"
            return true
        } else {
            textField.placeholder = "Type something"
            return false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if var city = searchTextField.text {
            city = cleanCityName(city)
            weatherManager.fetchWeather(cityName: city)
        }
        
        searchTextField.text = ""
    }
    
    func cleanCityName(_ city: String) -> String {
        var cleanCity  = city
        
        // Remove any traling whitespace
        while cleanCity.last?.isWhitespace == true {
            cleanCity = String(city.dropLast())
        }
        cleanCity = cleanCity.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        return cleanCity
    }
}
 
//MARK: - WeatherManagerDelegate
extension WeatherViewController: WeatherManagerDelegate{
    
    func getTime(_ epochTime: Double) -> String {
                   let date = NSDate(timeIntervalSince1970: epochTime)
                   let dateFormatter = DateFormatter()
                   dateFormatter.timeStyle = DateFormatter.Style.short//Set time style
                   dateFormatter.timeZone = .current
                   let localDate = dateFormatter.string(from: date as Date)
                   return localDate
    }
    
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel){
        DispatchQueue.main.async {
            self.temperatureLabel.text = weather.temperatureString
            self.conditionImageView.image = UIImage(systemName: weather.conditonName)
            self.cityLabel.text = weather.cityName
            let sunriseTime = self.getTime(weather.sunrise)
            let sunsetTime = self.getTime(weather.sunset)
            self.sunset.text = sunsetTime
            self.sunrise.text = sunriseTime
            
        }
    }
    
    func didFailWithError(error: Error) {
        print("Failed with error: \(error)")
    }
}

//MARK: - CLLocationManagerDelegate
extension WeatherViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            print("Lat is: \(lat)")
            print("Long is: \(lon)")
            weatherManager.fetchWeather(latitude: lat, longitude: lon)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
