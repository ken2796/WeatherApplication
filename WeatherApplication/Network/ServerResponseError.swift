//
//  ServerResponseError.swift
//  WeatherApplication
//
//  Created by Kenneth Francia on 12/16/24.
//

import Foundation

struct ServerResponseError: Decodable {
    let error: ErrorResponse?
    
    private func getErrorDescription() -> String {
        if let error = error {
            return error.message
        }
        return NSLocalizedString("no errors", comment: "")
    }
}
