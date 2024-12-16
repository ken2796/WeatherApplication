//
//  WeatherService.swift
//  WeatherApplication
//
//  Created by Kenneth Francia on 12/16/24.
//

import Foundation

enum WeatherService: ServiceProtocol {
    case getCurrentWeather(String)
    
    var path: String {
        switch self {
        case .getCurrentWeather:
            return "current.json"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        default: return .get
        }
    }
    
    var task: RequestTask {
        switch self {
        case .getCurrentWeather(let query):
            return .requestParameters(["q": query])
        }
    }
    
    //MARK: This code is for token and for the future purposes
    var needsAuthentication: Bool {
        switch self {
        default:
            return false
        }
    }
    
    //MARK: This code is for encapsulated `data` for the future purposes
    var usesContainer: Bool {
        switch self {
        default:
            return false
        }
    }
    
    var parametersEncoding: ParametersEncoding {
        switch self {
        default:
            return .url
        }
    }
}
