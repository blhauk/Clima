//
//  WeatherData.swift
//  Clima
//
//  Created by Blair Haukedal on 2020-01-07.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation

struct WeatherData: Codable {
    let name: String
    let timezone: Double
    let dt: Double
    let sys: Sys
    let main: Main
    let coord: Coord
    let weather: [Weather]
}

struct Coord: Codable {
    let lat: Double
    let lon: Double
}
struct Sys: Codable {
    let country: String
    let sunrise: Double
    let sunset: Double
}

struct Main: Codable {
    let temp: Double
    let feels_like: Double
    let temp_min: Double
    let temp_max: Double
    let humidity: Double
}

struct Weather: Codable {
    let description: String
    let id: Int
}
