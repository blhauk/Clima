//
//  WeatherManager.swift
//  Clima
//
//  Created by Blair Haukedal on 2020-01-07.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
    func didFailWithError(error: Error)
}

struct WeatherManager {
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?APPID=65a0730eb8fda66c538cc3162c0ca2f5&units=metric"
    
    var delegate: WeatherManagerDelegate?
    
    func fetchWeather(cityName: String){
        let urlString = "\(weatherURL)&q=\(cityName)"
        performRequest(with: urlString)
    }
    
    func fetchWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        let urlString = "\(weatherURL)&lat=\(latitude)&lon=\(longitude)"
        performRequest(with: urlString)
    }
    
    func performRequest(with urlString: String) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                
                if let safeData = data {
                    if let weather = self.parseJSON(safeData) {
                        self.delegate?.didUpdateWeather(self, weather: weather)
                    }
                }
            }
            task.resume()
        } else {
            print("URL call failed")
        }
    }
    
    func parseJSON(_ weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let name = decodedData.name
            let temp = decodedData.main.temp
            let id = decodedData.weather[0].id
            let sunrise = decodedData.sys.sunrise
            let sunset = decodedData.sys.sunset

            // let description = decodedData.weather[0].description
            
            let weather = WeatherModel(conditionId: id, cityName: name, temperature: temp, sunrise: sunrise, sunset: sunset)
            
            print("City:\(name)")
            print("Temperature float:\(temp)")
            print("Temperature string: \(weather.temperatureString)")
            print("ID:\(id)")
            print("Condition name: \(weather.conditonName)")
            print("Sunrise: \(sunrise)")
            print("Sunset: \(sunset)")

            print()
            
            return weather
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }

}

