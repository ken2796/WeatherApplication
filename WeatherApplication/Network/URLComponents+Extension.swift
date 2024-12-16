//
//  URLComponents+Extension.swift
//  WeatherApplication
//
//  Created by Kenneth Francia on 12/16/24.
//

import Foundation

extension URLComponents {
    
    init(service: ServiceProtocol) {
        let url: URL
        if let customService = service as? CustomService,
           let customBaseURL = customService.customBaseURL {
            if !service.path.isEmpty {
                url = customBaseURL.appendingPathComponent(service.path)
            } else {
                url = customBaseURL
            }
        } else {
            url = service.baseURL.appendingPathComponent(service.path)
        }
        self.init(url: url, resolvingAgainstBaseURL: false)!
        guard case let .requestParameters(parameters) = service.task, service.parametersEncoding == .url else { return }
        queryItems = parameters.map { key, value in
            return URLQueryItem(name: key, value: String(describing: value))
        }
    }
}
