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

    @IBOutlet weak var searchTextField: UITextField!
    
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var condition: UILabel!
    @IBOutlet weak var conditionImageView: UIImageView!

    @IBOutlet weak var temperatureLabel: UILabel!
    
    @IBOutlet weak var feels_like: UILabel!
    @IBOutlet weak var humidity: UILabel!
    @IBOutlet weak var temp_min: UILabel!
    @IBOutlet weak var temp_max: UILabel!
    @IBOutlet weak var local_time: UILabel!
    @IBOutlet weak var sunrise: UILabel!
    @IBOutlet weak var sunset: UILabel!
    @IBOutlet weak var latitude: UILabel!
    @IBOutlet weak var longitude: UILabel!
    
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
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        let localDate = dateFormatter.string(from: date as Date)
        print("WeatherManagerDelegate: localDate: \(localDate)")
        return localDate
    }
    
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel){
        DispatchQueue.main.async {
            print("======================")
            print("didUpdateWeather: Timezone: \(weather.timezone)")
            
            //Display City name and Country
            self.cityLabel.text = weather.cityName + ", " + weather.country
            
            //Display condition text and icon
            self.condition.text = weather.condition.capitalized
            self.conditionImageView.image = UIImage(systemName: weather.conditonName)
            
            // Display Temperature
            let temperatureString = String(format: "%.1f", weather.temperature)
            self.temperatureLabel.text = temperatureString
            
            // Display Weather details
            let feels_likeString = String(format: "%.1f°C", weather.feels_like)
            self.feels_like.text = feels_likeString
            
            let humidityString = String(format: "%.0f%%", weather.humidity)
            self.humidity.text = humidityString
            
            let temp_minString = String(format: "%.1f°C", weather.temp_min)
            self.temp_min.text = temp_minString
            
            let temp_maxString = String(format: "%.1f°C", weather.temp_max)
            self.temp_max.text = temp_maxString
            
            // Display Local Time
            let timeInterval = NSDate().timeIntervalSince1970
            let currentLocalTime = self.getTime(timeInterval + weather.timezone)
            self.local_time.text = currentLocalTime
            
            // Display Sunrise/Sunset Times
            let sunriseTime = self.getTime(weather.sunrise + weather.timezone)
            self.sunrise.text = sunriseTime
            let sunsetTime = self.getTime(weather.sunset + weather.timezone)
            self.sunset.text = sunsetTime
            
            // Display lat/long
            self.latitude.text = String(format: "%3.3f", weather.lat)
            self.longitude.text = String(format: "%3.3f", weather.lon)
            
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
            print("")
            print("======================")
            print("LocationManagerDelegate: Latitude is: \(lat)")
            print("LocationManagerDelegate: Longitude is: \(lon)")
            weatherManager.fetchWeather(latitude: lat, longitude: lon)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
