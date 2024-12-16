//
//  CustomService.swift
//  WeatherApplication
//
//  Created by Kenneth Francia on 12/16/24.
//

import Foundation

struct CustomService: ServiceProtocol {
    
    var customBaseURL: URL? = nil
    var path = ""
    let method: HTTPMethod
    var task: RequestTask = .requestPlain
    var needsAuthentication = false
    var usesContainer = false
    var parametersEncoding: ParametersEncoding = .url
    var showLogs = true
    
}
