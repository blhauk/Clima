//
//  WeatherModel.swift
//  Clima
//
//  Created by Blair Haukedal on 2020-01-08.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation

struct WeatherModel {
    let conditionId: Int
    let cityName: String
    let currentLocalTime: Double
    let timezone: Double
    let temperature: Double
    let feels_like: Double
    let temp_min: Double
    let temp_max: Double
    let humidity: Double
    let sunrise: Double
    let sunset: Double
    let condition: String
    // let lat: Double
    // let lon: Double
    
    var conditonName: String {
        switch conditionId {
            case 200...232:
                return "cloud.bolt"
            case 300...321:
                return "cloud.drizzle"
            case 500...531:
                return "cloud.rain"
            case 600...622:
                return "cloud.snow"
            case 701...781:
                return "cloud.fog"
            case 800:
                return "sun.max"
            case 801...804:
                return "cloud"
            default:
                return "cloud"
        }
    }
}
