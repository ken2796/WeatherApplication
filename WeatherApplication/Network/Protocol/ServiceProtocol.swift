//
//  ServiceProtocol.swift
//  WeatherApplication
//
//  Created by Kenneth Francia on 12/16/24.
//

import Foundation

typealias Headers = [String: String]
protocol ServiceProtocol {
    var path: String { get }
    var method: HTTPMethod { get }
    var task: RequestTask { get }
    var needsAuthentication: Bool { get }
    var usesContainer: Bool { get }
    var parametersEncoding: ParametersEncoding { get }
}

extension ServiceProtocol {
    var baseURL: URL {
        let baseURL = "http://api.weatherapi.com/v1/"
        return URL(string: baseURL)!
    }

    var headers: Headers {
        var headers = [
            "Content-Type": "application/json"
        ]
        
        headers["key"] = "55669b45f3a14775a82193453241512"

        return headers
    }
}
