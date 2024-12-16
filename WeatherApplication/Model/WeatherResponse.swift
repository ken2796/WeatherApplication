//
//  WeatherResponse.swift
//  WeatherApplication
//
//  Created by Kenneth Francia on 12/16/24.
//

import Foundation

struct WeatherData: Codable {
    let location: Location
    let current: Current?
}

struct Location: Codable {
    let name: String
    var latitude: Double?
    var longitude: Double?
}

struct Current: Codable {
    let tempC: Double?
    let condition: Condition
    let humidity: Int?
    let cloud: Int?
    let feelslikeC: Double?
    let uv: Double?
}

struct Condition: Codable {
    let text: String
    let icon: String
    var iconURL: String {
        return "http:\(icon)"
    }
    let code: Int
}
