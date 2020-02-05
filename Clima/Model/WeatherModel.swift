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
    let temperature: Double
    let sunrise: Double
    let sunset: Double
    // let lat: Double
    // let lon: Double
    
    var temperatureString: String {
        return String(format: "%.1f", temperature)
    }
    
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
            return "cloud.bolt"
        default:
            return "cloud"
        }
    }
}